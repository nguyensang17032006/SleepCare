import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepSession/sleep_session_bloc.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepSession/sleep_session_event.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepSession/sleep_session_state.dart';

class SleepSessionScreen extends StatefulWidget {
  final String trackId;
  final String musicUrl;
  final String musicName;
  final int durationMinutes;

  const SleepSessionScreen({
    super.key,
    required this.trackId,
    required this.musicUrl,
    required this.musicName,
    required this.durationMinutes,
  });

  @override
  State<SleepSessionScreen> createState() => _SleepSessionScreenState();
}

class _SleepSessionScreenState extends State<SleepSessionScreen> {
  @override
  void initState() {
    super.initState();

    context.read<SleepSessionBloc>().add(
      SleepSessionStarted(
        trackId: widget.trackId,
        musicUrl: widget.musicUrl,
        musicName: widget.musicName,
        durationMinutes: widget.durationMinutes,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _exitSession() async {
    final bloc = context.read<SleepSessionBloc>();
    final state = bloc.state;

    if (state.status != SleepSessionStatus.completed) {
      bloc.add(const SleepSessionStopped());
    }

    // Chờ Bloc lưu dữ liệu trước khi đóng màn hình.
    await bloc.stream.firstWhere(
      (state) =>
          state.status == SleepSessionStatus.completed ||
          state.status == SleepSessionStatus.failure,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepSessionBloc, SleepSessionState>(
      listener: (context, state) {
        if (state.status == SleepSessionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Không thể bắt đầu phiên ngủ',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isStarting = state.status == SleepSessionStatus.starting;
        final isFinished = state.status == SleepSessionStatus.completed;
        final isPlaying = state.status == SleepSessionStatus.playing;

        return PopScope(
          canPop: isFinished,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _exitSession();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      Icon(
                        isFinished ? Icons.wb_sunny : Icons.nightlight_round,
                        color: isFinished
                            ? Colors.amber
                            : AppTheme.primaryColor.withValues(alpha: 0.5),
                        size: 80,
                      ),

                      const SizedBox(height: 24),

                      if (isStarting)
                        const CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        )
                      else
                        Text(
                          isFinished
                              ? 'Chào buổi sáng!'
                              : _formatTime(state.remainingSeconds),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 16),

                      if (!isFinished && !isStarting)
                        Text(
                          'Đang phát: ${widget.musicName}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      if (!isFinished && !isStarting) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Bạn có thể khóa màn hình. '
                          'Nhạc sẽ tự dừng khi hết thời gian.',
                          style: TextStyle(color: Colors.white30, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],

                      const Spacer(),

                      if (!isFinished && !isStarting)
                        IconButton(
                          onPressed: () {
                            context.read<SleepSessionBloc>().add(
                              const SleepSessionPlayPauseRequested(),
                            );
                          },
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white54,
                          ),
                        ),

                      const SizedBox(height: 24),

                      TextButton(
                        onPressed: isStarting ? null : _exitSession,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white54,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(isFinished ? 'Quay lại' : 'Kết thúc'),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
