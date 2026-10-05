class AssessmentAnswer {
  final String? id;

  final String? assessmentId;

  final String questionId;
  final Object? answerValue;
  final double? answerScore;
  final DateTime? answeredAt;

  const AssessmentAnswer({
    this.id,
    this.assessmentId,
    required this.questionId,
    required this.answerValue,
    this.answerScore,
    this.answeredAt,
  });

  AssessmentAnswer copyWith({
    String? id,
    String? assessmentId,
    String? questionId,
    Object? answerValue,
    double? answerScore,
    DateTime? answeredAt,
  }) {
    return AssessmentAnswer(
      id: id ?? this.id,
      assessmentId: assessmentId ?? this.assessmentId,
      questionId: questionId ?? this.questionId,
      answerValue: answerValue ?? this.answerValue,
      answerScore: answerScore ?? this.answerScore,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
