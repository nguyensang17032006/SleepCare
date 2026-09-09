import '../../domain/entities/overview_report.dart';

class OverviewReportModel extends OverviewReport {
  const OverviewReportModel({
    required super.averageSleepDurationHours,
    required super.deltaMinutes,
    required super.weekData,
  });

  factory OverviewReportModel.fromJson(Map<String, dynamic> json) {
    var weekDataList = json['week_data'] as List? ?? [];
    List<DailySleepData> parsedWeekData = weekDataList.map((i) {
      return DailySleepData(
        date: DateTime.parse(i['date']),
        hasData: i['has_data'] as bool? ?? false,
      );
    }).toList();

    return OverviewReportModel(
      averageSleepDurationHours: (json['average_sleep_duration_hours'] as num?)?.toDouble() ?? 0.0,
      deltaMinutes: (json['delta_minutes'] as num?)?.toInt() ?? 0,
      weekData: parsedWeekData,
    );
  }
}
