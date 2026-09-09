import 'package:equatable/equatable.dart';

class BedtimeReport extends Equatable {
  final String targetBedtime; // e.g. "23:00"
  final int daysAchieved;
  final int totalDays;

  const BedtimeReport({
    required this.targetBedtime,
    required this.daysAchieved,
    required this.totalDays,
  });

  @override
  List<Object?> get props => [targetBedtime, daysAchieved, totalDays];
}
