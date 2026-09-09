import 'package:equatable/equatable.dart';

class MusicReport extends Equatable {
  final int consecutiveDays;
  final int averageListeningMinutes;
  final String favoriteGenre;

  const MusicReport({
    required this.consecutiveDays,
    required this.averageListeningMinutes,
    required this.favoriteGenre,
  });

  @override
  List<Object?> get props => [consecutiveDays, averageListeningMinutes, favoriteGenre];
}
