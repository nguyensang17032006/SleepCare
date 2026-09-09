class DailySleepScore {
  final String? id;
  final String? userId;
  final DateTime scoreDate;
  final double score;
  final String qualityLevel;
  final String sourceType;

  final String? sourceAssessmentId;

  final Map<String, dynamic> scoringDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DailySleepScore({
    this.id,
    this.userId,
    required this.scoreDate,
    required this.score,
    required this.qualityLevel,
    required this.sourceType,
    this.sourceAssessmentId,
    this.scoringDetails = const {},
    this.createdAt,
    this.updatedAt,
  });

  DailySleepScore copyWith({
    String? id,
    String? userId,
    DateTime? scoreDate,
    double? score,
    String? qualityLevel,
    String? sourceType,
    String? sourceAssessmentId,
    Map<String, dynamic>? scoringDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailySleepScore(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      scoreDate: scoreDate ?? this.scoreDate,
      score: score ?? this.score,
      qualityLevel: qualityLevel ?? this.qualityLevel,
      sourceType: sourceType ?? this.sourceType,
      sourceAssessmentId: sourceAssessmentId ?? this.sourceAssessmentId,
      scoringDetails: scoringDetails ?? this.scoringDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
