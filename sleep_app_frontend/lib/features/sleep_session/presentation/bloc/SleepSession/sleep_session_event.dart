sealed class SleepSessionEvent {
  const SleepSessionEvent();
}

/// Bắt đầu phiên ngủ và phát nhạc.
class SleepSessionStarted extends SleepSessionEvent {
  final String trackId;
  final String musicUrl;
  final String musicName;
  final int durationMinutes;

  const SleepSessionStarted({
    required this.trackId,
    required this.musicUrl,
    required this.musicName,
    required this.durationMinutes,
  });
}

/// Tạm dừng hoặc tiếp tục phát nhạc.
class SleepSessionPlayPauseRequested extends SleepSessionEvent {
  const SleepSessionPlayPauseRequested();
}

/// Đếm thời gian phiên ngủ.
class SleepSessionTicked extends SleepSessionEvent {
  const SleepSessionTicked();
}

/// Người dùng chủ động kết thúc phiên ngủ.
class SleepSessionStopped extends SleepSessionEvent {
  const SleepSessionStopped();
}

/// Bộ đếm đã chạy hết thời gian.
class SleepSessionTimerCompleted extends SleepSessionEvent {
  const SleepSessionTimerCompleted();
}
