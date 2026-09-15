class SleepAssessment {
  final String? id;
  final String? userId;
  final String? questionnaireVersionId;

  final String assessmentType;
  final DateTime assessmentDate;
  final String status;

  final double? rawTotalScore;
  final double? normalizedScore;
  final String? qualityLevel;

  final Map<String, dynamic> scoringDetails;

  final DateTime startedAt;
  final DateTime? completedAt;

  const SleepAssessment({
    this.id,
    this.userId,
    this.questionnaireVersionId,
    required this.assessmentType,
    required this.assessmentDate,
    this.status = 'draft',
    this.rawTotalScore,
    this.normalizedScore,
    this.qualityLevel,
    this.scoringDetails = const {},
    required this.startedAt,
    this.completedAt,
  });

  SleepAssessment copyWith({
    String? id,
    String? userId,
    String? questionnaireVersionId,
    String? assessmentType,
    DateTime? assessmentDate,
    String? status,
    double? rawTotalScore,
    double? normalizedScore,
    String? qualityLevel,
    Map<String, dynamic>? scoringDetails,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return SleepAssessment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questionnaireVersionId:
          questionnaireVersionId ?? this.questionnaireVersionId,
      assessmentType: assessmentType ?? this.assessmentType,
      assessmentDate: assessmentDate ?? this.assessmentDate,
      status: status ?? this.status,
      rawTotalScore: rawTotalScore ?? this.rawTotalScore,
      normalizedScore: normalizedScore ?? this.normalizedScore,
      qualityLevel: qualityLevel ?? this.qualityLevel,
      scoringDetails: scoringDetails ?? this.scoringDetails,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
