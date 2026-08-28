import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/setting/data/sources/schedule_source.dart';
import '../../../../core/services/notification_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleSource _source = ScheduleSource();

  bool isLoading = true;
  bool isSaving = false;

  TimeOfDay bedtime = const TimeOfDay(hour: 22, minute: 30);
  List<int> activeDays = [1, 2, 3, 4, 5]; // Mon-Fri
  int reminderOffsetMinutes = 15;
  bool notificationsEnabled = true;

  Future<void> loadSchedule() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _source.getSchedule();
      if (data != null) {
        if (data['bedtime'] != null) {
          final parts = (data['bedtime'] as String).split(':');
          if (parts.length >= 2) {
            bedtime = TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 22,
              minute: int.tryParse(parts[1]) ?? 30,
            );
          }
        }
        if (data['active_days'] != null) {
          activeDays = List<int>.from(data['active_days']);
        }
        if (data['reminder_offset_minutes'] != null) {
          reminderOffsetMinutes = data['reminder_offset_minutes'] as int;
        }
        if (data['notifications_enabled'] != null) {
          notificationsEnabled = data['notifications_enabled'] as bool;
        }
      }
    } catch (e) {
      debugPrint('Error loading schedule: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateBedtime(TimeOfDay time) {
    bedtime = time;
    notifyListeners();
  }

  void toggleDay(int day) {
    if (activeDays.contains(day)) {
      activeDays.remove(day);
    } else {
      activeDays.add(day);
    }
    notifyListeners();
  }

  void updateReminderOffset(int minutes) {
    reminderOffsetMinutes = minutes;
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  Future<bool> saveSchedule() async {
    isSaving = true;
    notifyListeners();

    try {
      final bedtimeStr =
          "${bedtime.hour.toString().padLeft(2, '0')}:${bedtime.minute.toString().padLeft(2, '0')}:00";

      await _source.saveSchedule(
        bedtime: bedtimeStr,
        activeDays: activeDays,
        reminderOffsetMinutes: reminderOffsetMinutes,
        notificationsEnabled: notificationsEnabled,
      );

      // Handle Notifications
      final notificationService = NotificationService();
      if (notificationsEnabled) {
        // Calculate reminder time
        final totalMinutes =
            bedtime.hour * 60 + bedtime.minute - reminderOffsetMinutes;
        int reminderHour = (totalMinutes ~/ 60) % 24;
        if (reminderHour < 0) reminderHour += 24;
        int reminderMinute = totalMinutes % 60;
        if (reminderMinute < 0) reminderMinute += 60;

        await notificationService.scheduleBedtimeReminders(
          hour: reminderHour,
          minute: reminderMinute,
          activeDays: activeDays,
          title: "Đã đến giờ đi ngủ!",
          body: "Hãy mở app và bắt đầu một giấc ngủ thật ngon nhé.",
        );
      } else {
        await notificationService.cancelAllBedtimeReminders();
      }

      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving schedule: $e');
      isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
