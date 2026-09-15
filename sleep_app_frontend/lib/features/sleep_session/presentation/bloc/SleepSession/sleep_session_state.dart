import 'package:sleep_app_frontend/features/sleep_session/domain/entities/active_sleep_session.dart';

enum SleepSessionStatus {
  initial,
  starting,
  playing,
  paused,
  completed,
  failure,
}

const _notProvided = Object();

class SleepSessionState {
  final SleepSessionStatus status;

  final String? trackId;
  final String? musicUrl;
  final String? musicName;

  final int totalSeconds;
  final int remainingSeconds;
  final int listenedSeconds;

  final ActiveSleepSession? activeSession;
  final String? errorMessage;

  const SleepSessionState({
    this.status = SleepSessionStatus.initial,
    this.trackId,
    this.musicUrl,
    this.musicName,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.listenedSeconds = 0,
    this.activeSession,
    this.errorMessage,
  });

  bool get isPlaying => status == SleepSessionStatus.playing;

  bool get isPaused => status == SleepSessionStatus.paused;

  bool get isFinished => status == SleepSessionStatus.completed;

  double get progress {
    if (totalSeconds <= 0) {
      return 0;
    }

    return ((totalSeconds - remainingSeconds) / totalSeconds).clamp(0.0, 1.0);
  }

  SleepSessionState copyWith({
    SleepSessionStatus? status,
    String? trackId,
    String? musicUrl,
    String? musicName,
    int? totalSeconds,
    int? remainingSeconds,
    int? listenedSeconds,
    Object? activeSession = _notProvided,
    Object? errorMessage = _notProvided,
  }) {
    return SleepSessionState(
      status: status ?? this.status,
      trackId: trackId ?? this.trackId,
      musicUrl: musicUrl ?? this.musicUrl,
      musicName: musicName ?? this.musicName,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      listenedSeconds: listenedSeconds ?? this.listenedSeconds,
      activeSession: identical(activeSession, _notProvided)
          ? this.activeSession
          : activeSession as ActiveSleepSession?,
      errorMessage: identical(errorMessage, _notProvided)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
