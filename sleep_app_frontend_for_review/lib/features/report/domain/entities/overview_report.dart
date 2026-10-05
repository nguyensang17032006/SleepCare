import 'package:equatable/equatable.dart';

class DailySleepData extends Equatable {
  final DateTime date;
  final bool hasData;

  const DailySleepData({
    required this.date,
    required this.hasData,
  });

  @override
  List<Object?> get props => [date, hasData];
}

class OverviewReport extends Equatable {
  final double averageSleepDurationHours;
  final int deltaMinutes;
  final List<DailySleepData> weekData;

  const OverviewReport({
    required this.averageSleepDurationHours,
    required this.deltaMinutes,
    required this.weekData,
  });

  @override
  List<Object?> get props => [averageSleepDurationHours, deltaMinutes, weekData];
}
