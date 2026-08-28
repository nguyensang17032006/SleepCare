import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Initialize Timezone
    tz.initializeTimeZones();
    try {
      final String currentTimeZone =
          (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      debugPrint('Error setting local timezone: $e');
    }

    // Android Initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    _isInitialized = true;
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('Notification clicked with payload: ${response.payload}');
  }

  Future<void> scheduleBedtimeReminders({
    required int hour,
    required int minute,
    required List<int> activeDays, // 1=Mon, 7=Sun
    required String title,
    required String body,
  }) async {
    // Cancel all existing reminders first
    await cancelAllBedtimeReminders();

    if (activeDays.isEmpty) return;

    for (int day in activeDays) {
      await _scheduleWeeklyReminder(
        id: day, // Use day as ID (1-7)
        dayOfWeek: day,
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    }
  }

  Future<void> _scheduleWeeklyReminder({
    required int id,
    required int dayOfWeek,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTimeAndDay(dayOfWeek, hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'bedtime_channel',
          'Bedtime Reminders',
          channelDescription: 'Reminders for your sleep schedule',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfTimeAndDay(int dayOfWeek, int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllBedtimeReminders() async {
    // Assuming IDs 1-7 are used for bedtime reminders
    for (int i = 1; i <= 7; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
  }
}
