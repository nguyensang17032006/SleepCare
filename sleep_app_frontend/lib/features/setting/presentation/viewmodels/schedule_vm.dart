import 'package:flutter/material.dart';

import 'package:sleep_app_frontend/core/services/notification_service.dart';
import 'package:sleep_app_frontend/features/setting/data/sources/schedule_source.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleSource _source;
  final NotificationService _notificationService;

  ScheduleViewModel({
    ScheduleSource? source,
    NotificationService? notificationService,
  })  : _source =
            source ?? ScheduleSource(),
        _notificationService =
            notificationService ??
                NotificationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage =>
      _errorMessage;

  String? _warningMessage;
  String? get warningMessage =>
      _warningMessage;

  TimeOfDay _bedtime =
      const TimeOfDay(
    hour: 22,
    minute: 30,
  );

  TimeOfDay get bedtime =>
      _bedtime;

  Set<int> _activeDays = {
    1,
    2,
    3,
    4,
    5,
  };

  Set<int> get activeDays =>
      Set.unmodifiable(_activeDays);

  int _reminderOffsetMinutes = 15;

  int get reminderOffsetMinutes =>
      _reminderOffsetMinutes;

  bool _notificationsEnabled = true;

  bool get notificationsEnabled =>
      _notificationsEnabled;

  int? _sleepTimerMinutes;

  int? get sleepTimerMinutes =>
      _sleepTimerMinutes;

  bool _isSleepTimerLoading = false;

  bool get isSleepTimerLoading =>
      _isSleepTimerLoading;

  int _snoozeMinutes = 15;

  int get snoozeMinutes =>
      _snoozeMinutes;

  bool _isSnoozeLoading = false;

  bool get isSnoozeLoading =>
      _isSnoozeLoading;

  // =========================================================
  // SETTERS
  // =========================================================

  void setBedtime(
    TimeOfDay value,
  ) {
    _bedtime = value;
    notifyListeners();
  }

  void toggleDay(
    int day,
  ) {
    if (_activeDays.contains(day)) {
      _activeDays.remove(day);
    } else {
      _activeDays.add(day);
    }

    notifyListeners();
  }

  void setActiveDays(
    Set<int> days,
  ) {
    _activeDays =
        Set<int>.from(days);

    notifyListeners();
  }

  void setReminderOffset(
    int minutes,
  ) {
    _reminderOffsetMinutes =
        minutes;

    notifyListeners();
  }

  void setNotificationsEnabled(
    bool value,
  ) {
    _notificationsEnabled =
        value;

    notifyListeners();
  }

  // =========================================================
  // LOAD SCHEDULE
  // =========================================================

  Future<void>
      loadSchedule() async {
    _isLoading = true;
    _errorMessage = null;
    _warningMessage = null;

    notifyListeners();

    try {
      final data =
          await _source.getSchedule();

      if (data == null) {
        _sleepTimerMinutes = null;
        _snoozeMinutes = 15;
        return;
      }

      final bedtimeValue =
          data['bedtime'];

      if (bedtimeValue != null) {
        _bedtime =
            _parseTimeOfDay(
          bedtimeValue.toString(),
        );
      }

      final activeDaysValue =
          data['active_days'];

      if (activeDaysValue is List) {
        _activeDays =
            activeDaysValue
                .map(
                  (item) =>
                      (item as num)
                          .toInt(),
                )
                .toSet();
      }

      final reminderValue =
          data[
              'reminder_offset_minutes'];

      if (reminderValue != null) {
        _reminderOffsetMinutes =
            (reminderValue as num)
                .toInt();
      }

      final notificationValue =
          data[
              'notifications_enabled'];

      if (notificationValue
          is bool) {
        _notificationsEnabled =
            notificationValue;
      }

      final sleepTimerValue =
          data[
              'sleep_timer_minutes'];

      _sleepTimerMinutes =
          sleepTimerValue == null
              ? null
              : (sleepTimerValue
                      as num)
                  .toInt();

      final snoozeValue =
          data['snooze_minutes'];

      _snoozeMinutes =
          snoozeValue == null
              ? 15
              : (snoozeValue as num)
                  .toInt();

      debugPrint(
        'SLEEP TIMER LOADED: $_sleepTimerMinutes',
      );

      debugPrint(
        'SNOOZE LOADED: $_snoozeMinutes phút',
      );
    } catch (e) {
      debugPrint(
        'LOAD SCHEDULE VM ERROR: $e',
      );

      _errorMessage =
          'Không thể tải cài đặt lịch ngủ.';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SAVE SCHEDULE + CREATE NOTIFICATIONS
  // =========================================================

  Future<bool>
      saveSchedule() async {
    if (_activeDays.isEmpty) {
      _errorMessage =
          'Vui lòng chọn ít nhất một ngày.';

      notifyListeners();

      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    _warningMessage = null;

    notifyListeners();

    try {
      // =====================================================
      // 1. LƯU SUPABASE
      // =====================================================

      await _source.saveSchedule(
        bedtime:
            _formatTime(_bedtime),
        activeDays: _activeDays,
        reminderOffsetMinutes:
            _reminderOffsetMinutes,
        notificationsEnabled:
            _notificationsEnabled,
      );

      // =====================================================
      // 2. USER TẮT NOTIFICATION
      // =====================================================

      if (!_notificationsEnabled) {
        await _notificationService
            .cancelAllBedtimeReminders();

        debugPrint(
          'BEDTIME NOTIFICATIONS DISABLED',
        );

        return true;
      }

      // =====================================================
      // 3. TÍNH THỜI GIAN REMINDER
      // =====================================================

      final bedtimeMinutes =
          (_bedtime.hour * 60) +
              _bedtime.minute;

      var reminderMinutes =
          bedtimeMinutes -
              _reminderOffsetMinutes;

      var reminderDays =
          Set<int>.from(
        _activeDays,
      );

      // Ví dụ:
      //
      // Bedtime:
      // T2 00:15
      //
      // Reminder:
      // trước 30 phút
      //
      // => CN 23:45
      if (reminderMinutes < 0) {
        reminderMinutes +=
            24 * 60;

        reminderDays =
            reminderDays.map(
          (day) {
            if (day == 1) {
              return 7;
            }

            return day - 1;
          },
        ).toSet();
      }

      final reminderHour =
          reminderMinutes ~/ 60;

      final reminderMinute =
          reminderMinutes % 60;

      // =====================================================
      // DEBUG
      // =====================================================

      final sortedBedtimeDays =
          _activeDays.toList()
            ..sort();

      final sortedReminderDays =
          reminderDays.toList()
            ..sort();

      debugPrint(
        '==============================',
      );

      debugPrint(
        'BEDTIME: ${_formatTime(_bedtime)}',
      );

      debugPrint(
        'BEDTIME DAYS: $sortedBedtimeDays',
      );

      debugPrint(
        'REMINDER OFFSET: '
        '$_reminderOffsetMinutes phút',
      );

      debugPrint(
        'REMINDER TIME: '
        '${reminderHour.toString().padLeft(2, '0')}:'
        '${reminderMinute.toString().padLeft(2, '0')}',
      );

      debugPrint(
        'REMINDER DAYS: $sortedReminderDays',
      );

      debugPrint(
        'SNOOZE: $_snoozeMinutes phút',
      );

      debugPrint(
        '==============================',
      );

      // =====================================================
      // 4. TẠO NOTIFICATION CHÍNH + BÁO LẠI
      // =====================================================

      await _notificationService
          .scheduleBedtimeReminders(
        hour: reminderHour,
        minute: reminderMinute,
        activeDays:
            reminderDays.toList(),
        title:
            'Đến giờ chuẩn bị đi ngủ 🌙',
        body:
            _reminderOffsetMinutes ==
                    0
                ? 'Đã đến giờ đi ngủ của bạn.'
                : 'Còn $_reminderOffsetMinutes phút nữa là đến giờ đi ngủ.',
        snoozeMinutes:
            _snoozeMinutes,
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'SAVE SCHEDULE VM ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      _errorMessage =
          'Không thể lưu lịch ngủ. Vui lòng thử lại.';

      return false;
    } finally {
      _isSaving = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SLEEP TIMER
  // =========================================================

  Future<void>
      loadSleepTimer() async {
    _isSleepTimerLoading = true;

    notifyListeners();

    try {
      _sleepTimerMinutes =
          await _source
              .getSleepTimerMinutes();
    } catch (e) {
      debugPrint(
        'LOAD SLEEP TIMER VM ERROR: $e',
      );
    } finally {
      _isSleepTimerLoading = false;

      notifyListeners();
    }
  }

  Future<bool> updateSleepTimer(
    int minutes,
  ) async {
    if (minutes <= 0) {
      return false;
    }

    _isSleepTimerLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _source
          .updateSleepTimerMinutes(
        minutes,
      );

      _sleepTimerMinutes =
          minutes;

      return true;
    } catch (e) {
      debugPrint(
        'UPDATE SLEEP TIMER VM ERROR: $e',
      );

      _errorMessage =
          'Không thể lưu hẹn giờ tắt nhạc.';

      return false;
    } finally {
      _isSleepTimerLoading = false;

      notifyListeners();
    }
  }

  Future<bool>
      clearSleepTimer() async {
    _isSleepTimerLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _source
          .clearSleepTimer();

      _sleepTimerMinutes = null;

      return true;
    } catch (e) {
      debugPrint(
        'CLEAR SLEEP TIMER VM ERROR: $e',
      );

      _errorMessage =
          'Không thể tắt hẹn giờ.';

      return false;
    } finally {
      _isSleepTimerLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SNOOZE
  // =========================================================

  Future<bool>
      updateSnoozeMinutes(
    int minutes,
  ) async {
    if (minutes <= 0) {
      return false;
    }

    _isSnoozeLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      debugPrint(
        'UPDATE SNOOZE: $minutes phút',
      );

      await _source
          .updateSnoozeMinutes(
        minutes,
      );

      _snoozeMinutes = minutes;

      debugPrint(
        'SNOOZE UPDATED SUCCESS: '
        '$_snoozeMinutes phút',
      );

      return true;
    } catch (e) {
      debugPrint(
        'UPDATE SNOOZE VM ERROR: $e',
      );

      _errorMessage =
          'Không thể lưu thời gian báo lại.';

      return false;
    } finally {
      _isSnoozeLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // TEXT
  // =========================================================

  String get sleepTimerText {
    final minutes =
        _sleepTimerMinutes;

    if (minutes == null) {
      return 'Chưa đặt';
    }

    if (minutes < 60) {
      return '$minutes phút';
    }

    final hours =
        minutes ~/ 60;

    final remainingMinutes =
        minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours giờ';
    }

    return '$hours giờ '
        '$remainingMinutes phút';
  }

  // =========================================================
  // HELPERS
  // =========================================================

  String _formatTime(
    TimeOfDay time,
  ) {
    final hour =
        time.hour
            .toString()
            .padLeft(
              2,
              '0',
            );

    final minute =
        time.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$hour:$minute:00';
  }

  TimeOfDay _parseTimeOfDay(
    String value,
  ) {
    final parts =
        value.split(':');

    if (parts.length < 2) {
      return const TimeOfDay(
        hour: 22,
        minute: 30,
      );
    }

    return TimeOfDay(
      hour:
          int.tryParse(
            parts[0],
          ) ??
          22,
      minute:
          int.tryParse(
            parts[1],
          ) ??
          30,
    );
  }
}