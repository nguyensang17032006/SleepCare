import 'package:sleep_app_frontend/features/library/domain/entities/music.dart';

sealed class SleepPrepState {
  const SleepPrepState();
}

final class SleepPrepInitial extends SleepPrepState {
  const SleepPrepInitial();
}

final class SleepPrepLoading extends SleepPrepState {
  const SleepPrepLoading();
}

final class SleepPrepEmpty extends SleepPrepState {
  const SleepPrepEmpty();
}

final class SleepPrepLoaded extends SleepPrepState {
  final List<Music> savedMusics;
  final Music selectedMusic;
  final int durationMinutes;

  const SleepPrepLoaded({
    required this.savedMusics,
    required this.selectedMusic,
    this.durationMinutes = 30,
  });

  SleepPrepLoaded copyWith({
    List<Music>? savedMusics,
    Music? selectedMusic,
    int? durationMinutes,
  }) {
    return SleepPrepLoaded(
      savedMusics: savedMusics ?? this.savedMusics,
      selectedMusic: selectedMusic ?? this.selectedMusic,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

final class SleepPrepFailure extends SleepPrepState {
  final String message;

  const SleepPrepFailure(this.message);
}
