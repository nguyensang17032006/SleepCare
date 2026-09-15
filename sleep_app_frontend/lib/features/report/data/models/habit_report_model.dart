import '../../domain/entities/habit_report.dart';

class HabitReportModel extends HabitReport {
  const HabitReportModel({
    required super.habits,
  });

  factory HabitReportModel.fromJson(Map<String, dynamic> json) {
    var habitsList = json['habits'] as List? ?? [];
    return HabitReportModel(
      habits: habitsList.map((e) => e.toString()).toList(),
    );
  }
}
