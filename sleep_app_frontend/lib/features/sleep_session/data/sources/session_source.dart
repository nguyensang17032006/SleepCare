import '../../../../main.dart';

class SessionSource {
  Future<String?> startBedtimeSession() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await supabaseClient
          .from('bedtime_sessions')
          .insert({
            'user_id': userId,
            'started_at': DateTime.now().toUtc().toIso8601String(),
            'status': 'started',
            'created_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select('id')
          .single();

      return response['id'];
    } catch (e) {
      return null;
    }
  }

  Future<void> endBedtimeSession(String sessionId) async {
    try {
      await supabaseClient
          .from('bedtime_sessions')
          .update({
            'ended_at': DateTime.now().toUtc().toIso8601String(),
            'status': 'completed',
          })
          .eq('id', sessionId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> logListeningSession({
    required String bedtimeSessionId,
    required String musicUrl, // Used as track/playlist identifier if needed
    required int listenedSeconds,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabaseClient.from('listening_sessions').insert({
        'user_id': userId,
        'bedtime_session_id': bedtimeSessionId,
        'started_at': DateTime.now()
            .toUtc()
            .subtract(Duration(seconds: listenedSeconds))
            .toIso8601String(),
        'ended_at': DateTime.now().toUtc().toIso8601String(),
        'listened_seconds': listenedSeconds,
        'status': 'completed',
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      // Handle error
    }
  }
}
