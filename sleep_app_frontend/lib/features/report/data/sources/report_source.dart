import '../../../../main.dart';

class ReportSource {
  Future<List<Map<String, dynamic>>> getAssessmentsAndMetrics(
    DateTime startDate,
  ) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabaseClient
        .from('sleep_assessments')
        .select('''
          id,
          assessment_type,
          completed_at,
          assessment_sleep_metrics (
            sleep_duration_minutes,
            sleep_efficiency_percent,
            subjective_quality_score
          )
        ''')
        .eq('user_id', userId)
        .gte('completed_at', startDate.toIso8601String())
        .order('completed_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}
