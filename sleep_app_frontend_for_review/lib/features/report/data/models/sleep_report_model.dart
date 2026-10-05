import '../../domain/entities/sleep_report.dart';

class SleepReportModel extends SleepReport {
  const SleepReportModel({
    required super.sleepDurationHours,
    required super.sleepScore,
    required super.sleepQuality,
  });

  factory SleepReportModel.fromJson(Map<String, dynamic> json) {
    return SleepReportModel(
      sleepDurationHours: (json['sleep_duration_hours'] as num?)?.toDouble() ?? 0.0,
      sleepScore: (json['sleep_score'] as num?)?.toInt() ?? 0,
      sleepQuality: json['sleep_quality'] as String? ?? 'Chưa đánh giá',
    );
  }
}
