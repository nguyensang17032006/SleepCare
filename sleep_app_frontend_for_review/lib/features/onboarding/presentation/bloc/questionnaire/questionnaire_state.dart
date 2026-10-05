import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_requirement.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/daily_sleep_score.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/questionnaire_question.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/sleep_assessment.dart';

enum QuestionnaireStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class QuestionnaireState {
  final QuestionnaireStatus status;

  /// Cho biết đây là baseline_full hay repeat_full.
  final AssessmentRequirement? requirement;

  /// Danh sách câu hỏi FULL_PSQI lấy từ database.
  final List<QuestionnaireQuestion> questions;

  /// Câu trả lời được lưu theo questionId.
  final Map<String, Object?> answers;

  /// Kết quả assessment sau khi lưu thành công.
  final SleepAssessment? savedAssessment;

  /// Điểm ngày được tạo từ khảo sát full.
  final DailySleepScore? dailyScore;

  final String? errorMessage;

  const QuestionnaireState({
    this.status = QuestionnaireStatus.initial,
    this.requirement,
    this.questions = const [],
    this.answers = const {},
    this.savedAssessment,
    this.dailyScore,
    this.errorMessage,
  });

  bool get isComplete {
    final requiredQuestions = questions.where(
      (question) => question.isRequired,
    );

    return requiredQuestions.every((question) {
      final value = answers[question.id];

      if (value == null) {
        return false;
      }

      if (value is String && value.trim().isEmpty) {
        return false;
      }

      return true;
    });
  }

  QuestionnaireState copyWith({
    QuestionnaireStatus? status,
    AssessmentRequirement? requirement,
    List<QuestionnaireQuestion>? questions,
    Map<String, Object?>? answers,
    SleepAssessment? savedAssessment,
    DailySleepScore? dailyScore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QuestionnaireState(
      status: status ?? this.status,
      requirement: requirement ?? this.requirement,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      savedAssessment: savedAssessment ?? this.savedAssessment,
      dailyScore: dailyScore ?? this.dailyScore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
