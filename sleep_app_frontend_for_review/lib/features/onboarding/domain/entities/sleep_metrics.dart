class SleepMetrics {
  final String? assessmentId;

  final String? bedtime;
  final String? wakeTime;

  final int? sleepLatencyMinutes;
  final int? sleepDurationMinutes;
  final int? awakeningsCount;

  final double? sleepEfficiencyPercent;
  final double? subjectiveQualityScore;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SleepMetrics({
    this.assessmentId,
    this.bedtime,
    this.wakeTime,
    this.sleepLatencyMinutes,
    this.sleepDurationMinutes,
    this.awakeningsCount,
    this.sleepEfficiencyPercent,
    this.subjectiveQualityScore,
    this.createdAt,
    this.updatedAt,
  });

  SleepMetrics copyWith({
    String? assessmentId,
    String? bedtime,
    String? wakeTime,
    int? sleepLatencyMinutes,
    int? sleepDurationMinutes,
    int? awakeningsCount,
    double? sleepEfficiencyPercent,
    double? subjectiveQualityScore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SleepMetrics(
      assessmentId: assessmentId ?? this.assessmentId,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepLatencyMinutes: sleepLatencyMinutes ?? this.sleepLatencyMinutes,
      sleepDurationMinutes: sleepDurationMinutes ?? this.sleepDurationMinutes,
      awakeningsCount: awakeningsCount ?? this.awakeningsCount,
      sleepEfficiencyPercent:
          sleepEfficiencyPercent ?? this.sleepEfficiencyPercent,
      subjectiveQualityScore:
          subjectiveQualityScore ?? this.subjectiveQualityScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
