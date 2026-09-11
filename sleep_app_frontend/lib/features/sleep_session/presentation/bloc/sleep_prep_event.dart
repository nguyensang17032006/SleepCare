import 'package:sleep_app_frontend/features/library/domain/entities/music.dart';

sealed class SleepPrepEvent {
  const SleepPrepEvent();
}

// Tải hoặc tải lại danh sách nhạc đã lưu.
final class SleepPrepStarted extends SleepPrepEvent {
  const SleepPrepStarted();
}

// Chọn bài muốn nghe khi ngủ.
final class SleepPrepTrackSelected extends SleepPrepEvent {
  final Music music;

  const SleepPrepTrackSelected(this.music);
}

// Chọn thời gian phát nhạc.
final class SleepPrepDurationChanged extends SleepPrepEvent {
  final int minutes;

  const SleepPrepDurationChanged(this.minutes);
}
