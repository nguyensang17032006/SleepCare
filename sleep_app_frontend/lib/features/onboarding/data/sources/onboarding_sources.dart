import '../../../../main.dart'; // To access supabaseClient

class OnboardingRemoteSource {
  Future<void> saveSleepAssessment({
    required Map<String, dynamic> assessmentData,
    required Map<String, dynamic> metricsData,
  }) async {
    try {
      // Get the current user ID
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in');
      }

      assessmentData['user_id'] = userId;

      if (assessmentData['assessment_type'] == 'baseline_full') {
        final profile = await supabaseClient
            .from('profile_sleep_app')
            .select('onboarding_completed')
            .eq('id', userId)
            .maybeSingle();
        bool hasOnboarded = profile != null
            ? (profile['onboarding_completed'] ?? false)
            : false;
        if (hasOnboarded) {
          assessmentData['assessment_type'] = 'repeat_full';
        }
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

      // (Optional) Mark user's onboarding as completed
      await supabaseClient
          .from('profile_sleep_app')
          .update({'onboarding_completed': true})
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
