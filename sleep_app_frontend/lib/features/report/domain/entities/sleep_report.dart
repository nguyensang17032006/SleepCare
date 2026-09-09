import 'package:equatable/equatable.dart';

class SleepReport extends Equatable {
  final double sleepDurationHours;
  final int sleepScore;
  final String sleepQuality;

  const SleepReport({
    required this.sleepDurationHours,
    required this.sleepScore,
    required this.sleepQuality,
  });

  @override
  List<Object?> get props => [sleepDurationHours, sleepScore, sleepQuality];
}
