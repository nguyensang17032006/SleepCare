import '../../domain/entities/sleep_assessment.dart';

class SleepAssessmentModel extends SleepAssessment {
  const SleepAssessmentModel({
    super.id,
    required super.userId,
    super.questionnaireVersionId,
    required super.assessmentType,
    required super.assessmentDate,
    super.status = 'draft',
    super.rawTotalScore,
    super.normalizedScore,
    super.qualityLevel,
    super.scoringDetails = const {},
    required super.startedAt,
    super.completedAt,
  });

  factory SleepAssessmentModel.fromJson(Map<String, dynamic> json) {
    return SleepAssessmentModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      questionnaireVersionId: json['questionnaire_version_id'] as String?,
      assessmentType: json['assessment_type'] as String,
      assessmentDate: DateTime.parse(json['assessment_date'] as String),
      status: json['status'] as String? ?? 'draft',
      rawTotalScore: (json['raw_total_score'] as num?)?.toDouble(),
      normalizedScore: (json['normalized_score'] as num?)?.toDouble(),
      qualityLevel: json['quality_level'] as String?,
      scoringDetails: Map<String, dynamic>.from(
        json['scoring_details'] as Map? ?? {},
      ),
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );
  }

  factory SleepAssessmentModel.fromEntity(SleepAssessment entity) {
    return SleepAssessmentModel(
      id: entity.id,
      userId: entity.userId,
      questionnaireVersionId: entity.questionnaireVersionId,
      assessmentType: entity.assessmentType,
      assessmentDate: entity.assessmentDate,
      status: entity.status,
      rawTotalScore: entity.rawTotalScore,
      normalizedScore: entity.normalizedScore,
      qualityLevel: entity.qualityLevel,
      scoringDetails: entity.scoringDetails,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'user_id': userId,
      'questionnaire_version_id': questionnaireVersionId,
      'assessment_type': assessmentType,

      'assessment_date': assessmentDate.toIso8601String().split('T').first,

      'status': status,
      'raw_total_score': rawTotalScore,
      'normalized_score': normalizedScore,
      'quality_level': qualityLevel,
      'scoring_details': scoringDetails,
      'started_at': startedAt.toUtc().toIso8601String(),
      'completed_at': completedAt?.toUtc().toIso8601String(),
    };

    json.removeWhere((key, value) => value == null);

    return json;
  }

  SleepAssessment toEntity() {
    return SleepAssessment(
      id: id,
      userId: userId,
      questionnaireVersionId: questionnaireVersionId,
      assessmentType: assessmentType,
      assessmentDate: assessmentDate,
      status: status,
      rawTotalScore: rawTotalScore,
      normalizedScore: normalizedScore,
      qualityLevel: qualityLevel,
      scoringDetails: scoringDetails,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }
}
