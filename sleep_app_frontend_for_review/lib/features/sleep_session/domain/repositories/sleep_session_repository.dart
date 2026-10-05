import '../entities/active_sleep_session.dart';

abstract class SleepSessionRepository {
  Future<ActiveSleepSession> startSession({required String trackId});

  Future<void> finishSession({
    required ActiveSleepSession session,
    required int listenedSeconds,
    required int lastPositionSeconds,
    required double completionPercent,
    required bool timerCompleted,
  });
}
