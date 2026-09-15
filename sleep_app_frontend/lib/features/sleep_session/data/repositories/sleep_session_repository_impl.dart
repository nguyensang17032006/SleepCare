import '../../domain/entities/active_sleep_session.dart';
import '../../domain/repositories/sleep_session_repository.dart';
import '../sources/session_source.dart';

class SleepSessionRepositoryImpl implements SleepSessionRepository {
  final SessionSource remoteDataSource;

  const SleepSessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ActiveSleepSession> startSession({required String trackId}) {
    return remoteDataSource.startSession(trackId: trackId);
  }

  @override
  Future<void> finishSession({
    required ActiveSleepSession session,
    required int listenedSeconds,
    required int lastPositionSeconds,
    required double completionPercent,
    required bool timerCompleted,
  }) {
    return remoteDataSource.finishSession(
      session: session,
      listenedSeconds: listenedSeconds,
      lastPositionSeconds: lastPositionSeconds,
      completionPercent: completionPercent,
      timerCompleted: timerCompleted,
    );
  }
}
