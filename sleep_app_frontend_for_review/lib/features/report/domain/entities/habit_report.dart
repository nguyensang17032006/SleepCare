import 'package:equatable/equatable.dart';

class HabitReport extends Equatable {
  final List<String> habits;

  const HabitReport({required this.habits});

  @override
  List<Object?> get props => [habits];
}
