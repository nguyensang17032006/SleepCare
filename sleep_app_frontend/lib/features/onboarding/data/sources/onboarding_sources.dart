import 'package:flutter/foundation.dart';
import '../../../../main.dart'; // To access supabaseClient

class OnboardingRemoteSource {
  /// Hàm kiểm tra xem user hiện tại đã hoàn thành Onboarding chưa
  Future<bool> checkOnboardingStatus() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return false;

      // 1. Kiểm tra cờ onboarding_completed từ profile
      final profile = await supabaseClient
          .from('profile_sleep_app')
          .select('onboarding_completed')
          .eq('id', userId)
          .maybeSingle();

      if (profile != null && (profile['onboarding_completed'] == true)) {
        return true;
      }

      // 2. Kiểm tra xem user đã có baseline_full nào chưa
      final assessment = await supabaseClient
          .from('sleep_assessments')
          .select('id')
          .eq('user_id', userId)
          .eq('assessment_type', 'baseline_full')
          .maybeSingle();

      return assessment != null;
    } catch (e) {
      debugPrint('Lỗi kiểm tra Onboarding Status: $e');
      return false;
    }
  }

  /// Hàm lưu kết quả khảo sát
  Future<void> saveSleepAssessment({
    required Map<String, dynamic> assessmentData,
    required Map<String, dynamic> metricsData,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in');
      }

      assessmentData['user_id'] = userId;

      // Kiểm tra nếu đã có baseline_full thì chuyển thành repeat_full
      final hasBaseline = await supabaseClient
          .from('sleep_assessments')
          .select('id')
          .eq('user_id', userId)
          .eq('assessment_type', 'baseline_full')
          .maybeSingle();

      if (hasBaseline != null && assessmentData['assessment_type'] == 'baseline_full') {
        assessmentData['assessment_type'] = 'repeat_full';
      }

      // 1. Insert into sleep_assessments
      final assessmentResponse = await supabaseClient
          .from('sleep_assessments')
          .insert(assessmentData)
          .select('id')
          .single();

      final String assessmentId = assessmentResponse['id'];

      // 2. Insert into assessment_sleep_metrics
      metricsData['assessment_id'] = assessmentId;
      await supabaseClient.from('assessment_sleep_metrics').insert(metricsData);

      // 3. Đánh dấu hoàn thành onboarding trên profile
      await supabaseClient
          .from('profile_sleep_app')
          .update({'onboarding_completed': true})
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}