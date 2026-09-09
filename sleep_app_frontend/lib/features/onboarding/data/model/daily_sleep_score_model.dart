import '../../domain/entities/daily_sleep_score.dart';

class DailySleepScoreModel extends DailySleepScore {
  const DailySleepScoreModel({
    super.id,
    required super.userId,
    required super.scoreDate,
    required super.score,
    required super.qualityLevel,
    required super.sourceType,
    super.sourceAssessmentId,
    super.scoringDetails = const {},
    super.createdAt,
    super.updatedAt,
  });

  factory DailySleepScoreModel.fromJson(Map<String, dynamic> json) {
    return DailySleepScoreModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      scoreDate: DateTime.parse(json['score_date'] as String),
      score: (json['score'] as num).toDouble(),
      qualityLevel: json['quality_level'] as String,
      sourceType: json['source_type'] as String,
      sourceAssessmentId: json['source_assessment_id'] as String?,
      scoringDetails: Map<String, dynamic>.from(
        json['scoring_details'] as Map? ?? {},
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  factory DailySleepScoreModel.fromEntity(DailySleepScore entity) {
    return DailySleepScoreModel(
      id: entity.id,
      userId: entity.userId,
      scoreDate: entity.scoreDate,
      score: entity.score,
      qualityLevel: entity.qualityLevel,
      sourceType: entity.sourceType,
      sourceAssessmentId: entity.sourceAssessmentId,
      scoringDetails: entity.scoringDetails,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson({String? sourceAssessmentIdOverride}) {
    final finalAssessmentId = sourceAssessmentIdOverride ?? sourceAssessmentId;

    if (finalAssessmentId == null) {
      throw StateError(
        'sourceAssessmentId chưa được tạo nên không thể lưu điểm daily.',
      );
    }

    return {
      'user_id': userId,
      'score_date': scoreDate.toIso8601String().split('T').first,
      'score': score,
      'quality_level': qualityLevel,
      'source_type': sourceType,
      'source_assessment_id': finalAssessmentId,
      'scoring_details': scoringDetails,
    };
  }

  DailySleepScore toEntity() {
    return DailySleepScore(
      id: id,
      userId: userId,
      scoreDate: scoreDate,
      score: score,
      qualityLevel: qualityLevel,
      sourceType: sourceType,
      sourceAssessmentId: sourceAssessmentId,
      scoringDetails: scoringDetails,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
