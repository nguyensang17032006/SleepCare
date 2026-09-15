import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/active_sleep_session.dart';

class SessionSource {
  final SupabaseClient supabaseClient;

  const SessionSource({required this.supabaseClient});

  String _currentUserId() {
    final userId = supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      throw const AuthException('Người dùng chưa đăng nhập');
    }

    return userId;
  }

  Future<ActiveSleepSession> startSession({required String trackId}) async {
    final userId = _currentUserId();
    final now = DateTime.now().toUtc();

    // Tạo phiên ngủ.
    final bedtimeResponse = await supabaseClient
        .from('bedtime_sessions')
        .insert({
          'user_id': userId,

          // Cột này bắt buộc trong database.
          'scheduled_for': now.toIso8601String(),

          'started_at': now.toIso8601String(),
          'status': 'started',
        })
        .select('id')
        .single();

    final bedtimeSessionId = bedtimeResponse['id'].toString();

    try {
      // Tạo phiên nghe nhạc.
      final listeningResponse = await supabaseClient
          .from('listening_sessions')
          .insert({
            'user_id': userId,

            // Phải là UUID của bảng tracks.
            'track_id': trackId,

            'bedtime_session_id': bedtimeSessionId,
            'source': 'bedtime_autoplay',
            'started_at': now.toIso8601String(),
            'listened_seconds': 0,
            'last_position_seconds': 0,
            'completion_percent': 0,
            'status': 'playing',
          })
          .select('id')
          .single();

      return ActiveSleepSession(
        bedtimeSessionId: bedtimeSessionId,
        listeningSessionId: listeningResponse['id'].toString(),
        startedAt: now,
      );
    } catch (error) {
      // Nếu không tạo được listening session thì đánh dấu phiên ngủ thất bại.
      await supabaseClient
          .from('bedtime_sessions')
          .update({
            'ended_at': DateTime.now().toUtc().toIso8601String(),
            'status': 'failed',
            'failure_reason': error.toString(),
          })
          .eq('id', bedtimeSessionId);

      rethrow;
    }
  }

  Future<void> finishSession({
    required ActiveSleepSession session,
    required int listenedSeconds,
    required int lastPositionSeconds,
    required double completionPercent,
    required bool timerCompleted,
  }) async {
    final endedAt = DateTime.now().toUtc().toIso8601String();

    final safeCompletion = completionPercent.clamp(0.0, 100.0);

    await supabaseClient
        .from('listening_sessions')
        .update({
          'ended_at': endedAt,
          'listened_seconds': listenedSeconds,
          'last_position_seconds': lastPositionSeconds,
          'completion_percent': safeCompletion,
          'status': timerCompleted ? 'completed' : 'stopped',
          'updated_at': endedAt,
        })
        .eq('id', session.listeningSessionId);

    await supabaseClient
        .from('bedtime_sessions')
        .update({'ended_at': endedAt, 'status': 'completed'})
        .eq('id', session.bedtimeSessionId);
  }
}
