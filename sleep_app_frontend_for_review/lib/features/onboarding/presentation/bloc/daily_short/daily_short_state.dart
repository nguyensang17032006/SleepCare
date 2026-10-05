import '../../../domain/entities/questionnaire_question.dart';

enum DailyShortStatus { initial, loading, ready, submitting, success, failure }

class DailyShortState {
  final DailyShortStatus status;

  final List<QuestionnaireQuestion> questions;

  /// Key là questionId, value là câu trả lời của user.
  final Map<String, Object?> answers;

  final double? dailyScore;
  final String? errorMessage;

  const DailyShortState({
    this.status = DailyShortStatus.initial,
    this.questions = const [],
    this.answers = const {},
    this.dailyScore,
    this.errorMessage,
  });

  bool get isLoading => status == DailyShortStatus.loading;

  bool get isSubmitting => status == DailyShortStatus.submitting;

  bool get isSuccess => status == DailyShortStatus.success;

  /// Kiểm tra tất cả câu bắt buộc đã được trả lời.
  bool get isComplete {
    for (final question in questions) {
      if (!question.isRequired) {
        continue;
      }

      final value = answers[question.id];

      if (value == null) {
        return false;
      }

      if (value is String && value.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  DailyShortState copyWith({
    DailyShortStatus? status,
    List<QuestionnaireQuestion>? questions,
    Map<String, Object?>? answers,
    double? dailyScore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DailyShortState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      dailyScore: dailyScore ?? this.dailyScore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
