import '../../domain/entities/bedtime_report.dart';

class BedtimeReportModel extends BedtimeReport {
  const BedtimeReportModel({
    required super.targetBedtime,
    required super.daysAchieved,
    required super.totalDays,
  });

  factory BedtimeReportModel.fromJson(Map<String, dynamic> json) {
    return BedtimeReportModel(
      targetBedtime: json['target_bedtime'] as String? ?? '23:00',
      daysAchieved: (json['days_achieved'] as num?)?.toInt() ?? 0,
      totalDays: (json['total_days'] as num?)?.toInt() ?? 7,
    );
  }
}
