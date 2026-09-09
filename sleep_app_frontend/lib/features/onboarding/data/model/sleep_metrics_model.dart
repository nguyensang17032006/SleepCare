import '../../domain/entities/sleep_metrics.dart';

class SleepMetricsModel extends SleepMetrics {
  const SleepMetricsModel({
    super.assessmentId,
    super.bedtime,
    super.wakeTime,
    super.sleepLatencyMinutes,
    super.sleepDurationMinutes,
    super.awakeningsCount,
    super.sleepEfficiencyPercent,
    super.subjectiveQualityScore,
    super.createdAt,
    super.updatedAt,
  });

  factory SleepMetricsModel.fromJson(Map<String, dynamic> json) {
    return SleepMetricsModel(
      assessmentId: json['assessment_id'] as String?,
      bedtime: json['bedtime'] as String?,
      wakeTime: json['wake_time'] as String?,
      sleepLatencyMinutes: (json['sleep_latency_minutes'] as num?)?.toInt(),
      sleepDurationMinutes: (json['sleep_duration_minutes'] as num?)?.toInt(),
      awakeningsCount: (json['awakenings_count'] as num?)?.toInt(),
      sleepEfficiencyPercent: (json['sleep_efficiency_percent'] as num?)
          ?.toDouble(),
      subjectiveQualityScore: (json['subjective_quality_score'] as num?)
          ?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  factory SleepMetricsModel.fromEntity(SleepMetrics entity) {
    return SleepMetricsModel(
      assessmentId: entity.assessmentId,
      bedtime: entity.bedtime,
      wakeTime: entity.wakeTime,
      sleepLatencyMinutes: entity.sleepLatencyMinutes,
      sleepDurationMinutes: entity.sleepDurationMinutes,
      awakeningsCount: entity.awakeningsCount,
      sleepEfficiencyPercent: entity.sleepEfficiencyPercent,
      subjectiveQualityScore: entity.subjectiveQualityScore,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson({String? assessmentIdOverride}) {
    final finalAssessmentId = assessmentIdOverride ?? assessmentId;

    if (finalAssessmentId == null) {
      throw StateError('assessmentId chưa có nên không thể lưu chỉ số ngủ.');
    }

    final json = <String, dynamic>{
      'assessment_id': finalAssessmentId,
      'bedtime': bedtime,
      'wake_time': wakeTime,
      'sleep_latency_minutes': sleepLatencyMinutes,
      'sleep_duration_minutes': sleepDurationMinutes,
      'awakenings_count': awakeningsCount,
      'sleep_efficiency_percent': sleepEfficiencyPercent,
      'subjective_quality_score': subjectiveQualityScore,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }

  SleepMetrics toEntity() {
    return SleepMetrics(
      assessmentId: assessmentId,
      bedtime: bedtime,
      wakeTime: wakeTime,
      sleepLatencyMinutes: sleepLatencyMinutes,
      sleepDurationMinutes: sleepDurationMinutes,
      awakeningsCount: awakeningsCount,
      sleepEfficiencyPercent: sleepEfficiencyPercent,
      subjectiveQualityScore: subjectiveQualityScore,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
