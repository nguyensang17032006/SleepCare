import 'package:flutter/foundation.dart';
import '../../main.dart'; // for supabaseClient

class MusicPersonalizationService {
  Future<void> processDailySleepScore(int sleepQuality) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Lấy danh sách các bài hát trong bảng listening_sessions (trong 12 tiếng qua)
      final now = DateTime.now();
      final twelveHoursAgo = now.subtract(const Duration(hours: 12));

      final sessions = await supabaseClient
          .from('listening_sessions')
          .select('track_id, listened_seconds')
          .eq('user_id', userId)
          .gte('started_at', twelveHoursAgo.toUtc().toIso8601String());

      if (sessions == null || (sessions as List).isEmpty) {
        return;
      }

      // 2. Chấm điểm preference_score
      // sleepQuality: 0=Rất tốt, 1=Khá tốt, 2=Khá tệ, 3=Rất tệ
      int delta = 0;
      if (sleepQuality == 0) {
        delta = 10;
      } else if (sleepQuality == 1) {
        delta = 5;
      } else if (sleepQuality == 2) {
        delta = -5;
      } else if (sleepQuality == 3) {
        delta = -10;
      }

      // Lấy các bài hát đã nghe trên 30s
      Set<String> trackIds = {};
      for (var s in sessions) {
        if (s['listened_seconds'] != null && s['listened_seconds'] > 30) {
          trackIds.add(s['track_id']);
        }
      }

      for (String trackId in trackIds) {
        final statResponse = await supabaseClient
            .from('user_track_stats')
            .select('preference_score')
            .eq('user_id', userId)
            .eq('track_id', trackId)
            .maybeSingle();

        num currentScore = 0;
        if (statResponse != null && statResponse['preference_score'] != null) {
          currentScore = statResponse['preference_score'];
        }

        num newScore = (currentScore + delta).clamp(0, 100);

        if (statResponse != null) {
          await supabaseClient
              .from('user_track_stats')
              .update({
                'preference_score': newScore,
                'updated_at': DateTime.now().toUtc().toIso8601String(),
              })
              .eq('user_id', userId)
              .eq('track_id', trackId);
        } else {
          await supabaseClient.from('user_track_stats').insert({
            'user_id': userId,
            'track_id': trackId,
            'preference_score': newScore,
          });
        }

        // 3. Nếu bài hát đạt điểm cao, thêm vào bảng recommendations
        if (newScore >= 70) {
          final recResponse = await supabaseClient
              .from('music_recommendations')
              .select('id')
              .eq('user_id', userId)
              .eq('track_id', trackId)
              .eq('status', 'shown')
              .maybeSingle();

          if (recResponse == null) {
            await supabaseClient.from('music_recommendations').insert({
              'user_id': userId,
              'track_id': trackId,
              'recommendation_score': newScore,
              'recommendation_reason': 'Bài hát này đã giúp bạn ngủ ngon hơn',
            });
          }
        }
      }
    } catch (e) {
      debugPrint('MusicPersonalizationService error: $e');
    }
  }
}
