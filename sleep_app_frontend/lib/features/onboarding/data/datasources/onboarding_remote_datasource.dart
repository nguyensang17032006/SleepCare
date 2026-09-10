import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/assessment_requirement.dart';
import '../model/assessment_answer_model.dart';
import '../model/daily_sleep_score_model.dart';
import '../model/questionnaire_question_model.dart';
import '../model/sleep_assessment_model.dart';
import '../model/sleep_metrics_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<AssessmentRequirement> checkRequiredAssessment();

  Future<List<QuestionnaireQuestionModel>> getActiveQuestions({
    required String questionnaireCode,
  });

  Future<SleepAssessmentModel> submitSleepAssessment({
    required SleepAssessmentModel assessment,
    required List<AssessmentAnswerModel> answers,
    required SleepMetricsModel metrics,
    required DailySleepScoreModel dailyScore,
  });

  Future<List<DailySleepScoreModel>> getDailySleepScores({
    required DateTime startDate,
    required DateTime endDate,
  });
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final SupabaseClient supabaseClient;

  const OnboardingRemoteDataSourceImpl({required this.supabaseClient});

  String _currentUserId() {
    final userId = supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    return userId;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<String> _getActiveQuestionnaireVersionId(
    String questionnaireCode,
  ) async {
    final questionnaire = await supabaseClient
        .from('questionnaires')
        .select('id')
        .eq('code', questionnaireCode)
        .single();

    final questionnaireId = questionnaire['id'] as String;

    final version = await supabaseClient
        .from('questionnaire_versions')
        .select('id')
        .eq('questionnaire_id', questionnaireId)
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(1)
        .single();

    return version['id'] as String;
  }

  String _getQuestionnaireCode(String assessmentType) {
    switch (assessmentType) {
      case 'baseline_full':
      case 'repeat_full':
        return 'FULL_PSQI';

      case 'daily_short':
        return 'DAILY_SLEEP_CHECKIN';

      default:
        throw ArgumentError('Loại khảo sát không hợp lệ: $assessmentType');
    }
  }

  @override
  Future<AssessmentRequirement> checkRequiredAssessment() async {
    final userId = _currentUserId();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayString = _formatDate(today);

    // 1. Tìm khảo sát full gần nhất.
    final latestFullAssessment = await supabaseClient
        .from('sleep_assessments')
        .select('id, assessment_type, assessment_date, completed_at')
        .eq('user_id', userId)
        .eq('status', 'completed')
        .inFilter('assessment_type', ['baseline_full', 'repeat_full'])
        .order('assessment_date', ascending: false)
        .order('completed_at', ascending: false)
        .limit(1)
        .maybeSingle();

    // 2. Chưa từng làm full thì bắt buộc baseline.
    // Phải kiểm tra trước daily.
    if (latestFullAssessment == null) {
      return AssessmentRequirement.baselineFull;
    }

    final latestFullDate = DateTime.parse(
      latestFullAssessment['assessment_date'] as String,
    );

    final normalizedLatestFullDate = DateTime(
      latestFullDate.year,
      latestFullDate.month,
      latestFullDate.day,
    );

    final daysPassed = today.difference(normalizedLatestFullDate).inDays;

    // 3. Đã đủ 30 ngày thì bắt buộc repeat.
    // Kiểm tra trước việc user đã làm daily hôm nay.
    if (daysPassed >= 30) {
      return AssessmentRequirement.repeatFull;
    }

    // 4. Chưa đến ngày repeat thì kiểm tra hôm nay
    // đã hoàn thành bất kỳ khảo sát nào chưa.
    final todayAssessment = await supabaseClient
        .from('sleep_assessments')
        .select('id')
        .eq('user_id', userId)
        .eq('assessment_date', todayString)
        .eq('status', 'completed')
        .limit(1)
        .maybeSingle();

    if (todayAssessment != null) {
      return AssessmentRequirement.none;
    }

    // 5. Chưa làm khảo sát hôm nay thì hiện daily.
    return AssessmentRequirement.dailyShort;
  }

  @override
  Future<List<QuestionnaireQuestionModel>> getActiveQuestions({
    required String questionnaireCode,
  }) async {
    final versionId = await _getActiveQuestionnaireVersionId(questionnaireCode);

    final response = await supabaseClient
        .from('questionnaire_questions')
        .select()
        .eq('questionnaire_version_id', versionId)
        .order('position');

    return (response as List)
        .map(
          (json) => QuestionnaireQuestionModel.fromJson(
            Map<String, dynamic>.from(json as Map),
          ),
        )
        .toList();
  }

  @override
  Future<SleepAssessmentModel> submitSleepAssessment({
    required SleepAssessmentModel assessment,
    required List<AssessmentAnswerModel> answers,
    required SleepMetricsModel metrics,
    required DailySleepScoreModel dailyScore,
  }) async {
    final userId = _currentUserId();

    final questionnaireCode = _getQuestionnaireCode(assessment.assessmentType);

    final versionId = await _getActiveQuestionnaireVersionId(questionnaireCode);

    /*
     * BƯỚC 1: Tạo sleep_assessments.
     */
    final assessmentJson = assessment.toJson();

    assessmentJson['user_id'] = userId;
    assessmentJson['questionnaire_version_id'] = versionId;

    final assessmentResponse = await supabaseClient
        .from('sleep_assessments')
        .insert(assessmentJson)
        .select()
        .single();

    final savedAssessment = SleepAssessmentModel.fromJson(
      Map<String, dynamic>.from(assessmentResponse),
    );

    final assessmentId = savedAssessment.id;

    if (assessmentId == null) {
      throw const PostgrestException(message: 'Không nhận được assessment ID.');
    }

    /*
     * BƯỚC 2: Lưu từng câu trả lời.
     */
    if (answers.isNotEmpty) {
      final answersJson = answers
          .map((answer) => answer.toJson(assessmentIdOverride: assessmentId))
          .toList();

      await supabaseClient.from('assessment_answers').insert(answersJson);
    }

    /*
     * BƯỚC 3: Lưu các chỉ số giấc ngủ.
     */
    await supabaseClient
        .from('assessment_sleep_metrics')
        .insert(metrics.toJson(assessmentIdOverride: assessmentId));

    /*
     * BƯỚC 4: Lưu điểm dùng cho biểu đồ hằng ngày.
     *
     * Nếu cùng user và ngày đã tồn tại thì cập nhật
     * thay vì tạo dòng trùng.
     */
    final dailyScoreJson = dailyScore.toJson(
      sourceAssessmentIdOverride: assessmentId,
    );

    dailyScoreJson['user_id'] = userId;
    dailyScoreJson['source_type'] = savedAssessment.assessmentType;

    await supabaseClient
        .from('daily_sleep_scores')
        .upsert(dailyScoreJson, onConflict: 'user_id,score_date');

    /*
     * BƯỚC 5: Hoàn thành onboarding sau baseline.
     */
    if (savedAssessment.assessmentType == 'baseline_full') {
      await supabaseClient
          .from('profile_sleep_app')
          .update({
            'onboarding_completed': true,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', userId);
    }

    return savedAssessment;
  }

  @override
  Future<List<DailySleepScoreModel>> getDailySleepScores({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final userId = _currentUserId();

    final response = await supabaseClient
        .from('daily_sleep_scores')
        .select()
        .eq('user_id', userId)
        .gte('score_date', _formatDate(startDate))
        .lte('score_date', _formatDate(endDate))
        .order('score_date');

    return (response as List)
        .map(
          (json) => DailySleepScoreModel.fromJson(
            Map<String, dynamic>.from(json as Map),
          ),
        )
        .toList();
  }
}
