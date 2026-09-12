import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:sleep_app_frontend/core/services/audio_player_service.dart';
import 'package:sleep_app_frontend/features/sleep_session/domain/entities/active_sleep_session.dart';
import 'package:sleep_app_frontend/features/sleep_session/domain/repositories/sleep_session_repository.dart';

import 'sleep_session_event.dart';
import 'sleep_session_state.dart';

class SleepSessionBloc extends Bloc<SleepSessionEvent, SleepSessionState> {
  final SleepSessionRepository repository;
  final AudioPlayerService audioPlayerService;

  Timer? _timer;
  bool _isFinishing = false;

  SleepSessionBloc({required this.repository, required this.audioPlayerService})
    : super(const SleepSessionState()) {
    on<SleepSessionStarted>(_onStarted);
    on<SleepSessionPlayPauseRequested>(_onPlayPauseRequested);
    on<SleepSessionTicked>(_onTicked);
    on<SleepSessionStopped>(_onStopped);
    on<SleepSessionTimerCompleted>(_onTimerCompleted);
  }

  Future<void> _onStarted(
    SleepSessionStarted event,
    Emitter<SleepSessionState> emit,
  ) async {
    if (event.durationMinutes <= 0) {
      emit(
        state.copyWith(
          status: SleepSessionStatus.failure,
          errorMessage: 'Thời gian ngủ không hợp lệ',
        ),
      );
      return;
    }

    _timer?.cancel();
    _isFinishing = false;

    final totalSeconds = event.durationMinutes * 60;

    emit(
      SleepSessionState(
        status: SleepSessionStatus.starting,
        trackId: event.trackId,
        musicUrl: event.musicUrl,
        musicName: event.musicName,
        totalSeconds: totalSeconds,
        remainingSeconds: totalSeconds,
      ),
    );

    ActiveSleepSession? activeSession;

    try {
      // Tạo bedtime_sessions và listening_sessions trong database.
      activeSession = await repository.startSession(trackId: event.trackId);

      // Dùng AudioPlayerService toàn ứng dụng, không tạo AudioPlayer mới.
      await audioPlayerService.player.setAudioSource(
        AudioSource.uri(
          Uri.parse(event.musicUrl),
          tag: MediaItem(
            id: event.trackId,
            title: event.musicName,
            artist: 'SleepCare',
          ),
        ),
      );

      await audioPlayerService.player.setLoopMode(LoopMode.one);
      unawaited(audioPlayerService.player.play());

      emit(
        state.copyWith(
          status: SleepSessionStatus.playing,
          activeSession: activeSession,
          errorMessage: null,
        ),
      );

      _startTimer();
    } catch (error) {
      _timer?.cancel();

      await audioPlayerService.player.stop();

      // Nếu đã tạo session nhưng phát nhạc lỗi thì vẫn đóng session.
      if (activeSession != null) {
        try {
          await repository.finishSession(
            session: activeSession,
            listenedSeconds: 0,
            lastPositionSeconds: 0,
            completionPercent: 0,
            timerCompleted: false,
          );
        } catch (_) {
          // Không ghi đè lỗi ban đầu.
        }
      }

      emit(
        state.copyWith(
          status: SleepSessionStatus.failure,
          activeSession: activeSession,
          errorMessage: error.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onPlayPauseRequested(
    SleepSessionPlayPauseRequested event,
    Emitter<SleepSessionState> emit,
  ) async {
    try {
      if (state.status == SleepSessionStatus.playing) {
        await audioPlayerService.player.pause();

        emit(
          state.copyWith(status: SleepSessionStatus.paused, errorMessage: null),
        );
        return;
      }

      if (state.status == SleepSessionStatus.paused) {
        unawaited(audioPlayerService.player.play());

        emit(
          state.copyWith(
            status: SleepSessionStatus.playing,
            errorMessage: null,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SleepSessionStatus.failure,
          errorMessage: error.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _onTicked(SleepSessionTicked event, Emitter<SleepSessionState> emit) {
    // Khi tạm dừng thì không giảm giờ và không cộng thời gian nghe.
    if (state.status != SleepSessionStatus.playing) {
      return;
    }

    if (state.remainingSeconds <= 1) {
      _timer?.cancel();
      _timer = null;

      emit(
        state.copyWith(
          remainingSeconds: 0,
          listenedSeconds: state.listenedSeconds + 1,
        ),
      );

      add(const SleepSessionTimerCompleted());
      return;
    }

    emit(
      state.copyWith(
        remainingSeconds: state.remainingSeconds - 1,
        listenedSeconds: state.listenedSeconds + 1,
      ),
    );
  }

  Future<void> _onStopped(
    SleepSessionStopped event,
    Emitter<SleepSessionState> emit,
  ) async {
    await _finishSession(emit: emit, timerCompleted: false);
  }

  Future<void> _onTimerCompleted(
    SleepSessionTimerCompleted event,
    Emitter<SleepSessionState> emit,
  ) async {
    await _finishSession(emit: emit, timerCompleted: true);
  }

  Future<void> _finishSession({
    required Emitter<SleepSessionState> emit,
    required bool timerCompleted,
  }) async {
    if (_isFinishing ||
        state.status == SleepSessionStatus.completed ||
        state.activeSession == null) {
      return;
    }

    _isFinishing = true;
    _timer?.cancel();
    _timer = null;

    try {
      final player = audioPlayerService.player;

      final lastPositionSeconds = player.position.inSeconds;
      final trackDurationSeconds = player.duration?.inSeconds ?? 0;

      final completionPercent = trackDurationSeconds > 0
          ? ((state.listenedSeconds / trackDurationSeconds) * 100)
                .clamp(0, 100)
                .toDouble()
          : 0.0;

      await player.stop();

      await repository.finishSession(
        session: state.activeSession!,
        listenedSeconds: state.listenedSeconds,
        lastPositionSeconds: lastPositionSeconds,
        completionPercent: completionPercent,
        timerCompleted: timerCompleted,
      );

      emit(
        state.copyWith(
          status: SleepSessionStatus.completed,
          remainingSeconds: timerCompleted ? 0 : state.remainingSeconds,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SleepSessionStatus.failure,
          errorMessage: error.toString().replaceAll('Exception: ', ''),
        ),
      );
    } finally {
      _isFinishing = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(const SleepSessionTicked());
      }
    });
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await audioPlayerService.player.stop();
    return super.close();
  }
}
