class QuestionOption {
  final Object value;
  final String label;
  final double? score;

  const QuestionOption({required this.value, required this.label, this.score});
}

class QuestionnaireQuestion {
  final String id;
  final String questionnaireVersionId;
  final String questionCode;
  final String questionText;
  final String questionType;
  final int position;
  final List<QuestionOption> options;
  final bool isRequired;

  const QuestionnaireQuestion({
    required this.id,
    required this.questionnaireVersionId,
    required this.questionCode,
    required this.questionText,
    required this.questionType,
    required this.position,
    required this.options,
    required this.isRequired,
  });
}
