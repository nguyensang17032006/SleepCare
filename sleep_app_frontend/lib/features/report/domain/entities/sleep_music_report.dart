import 'package:equatable/equatable.dart';

class SleepMusicReport extends Equatable {
  final String suggestionText;

  const SleepMusicReport({
    required this.suggestionText,
  });

  @override
  List<Object?> get props => [suggestionText];
}
