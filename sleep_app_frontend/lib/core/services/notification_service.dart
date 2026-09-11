import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  static const String _bedtimeChannelId = 'bedtime_channel';
  static const String _bedtimeChannelName = 'Bedtime Reminders';

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // ==============================
      // TIMEZONE
      // ==============================

      tz.initializeTimeZones();

      try {
        final currentTimeZone =
            (await FlutterTimezone.getLocalTimezone()).identifier;

        tz.setLocalLocation(tz.getLocation(currentTimeZone));

        debugPrint('Notification timezone: $currentTimeZone');
      } catch (e) {
        debugPrint('Không thể lấy timezone thiết bị: $e');

        // Fallback Việt Nam
        tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      }

      // ==============================
      // INITIALIZATION
      // ==============================

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      // ==============================
      // ANDROID NOTIFICATION PERMISSION
      // ==============================

      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();

        debugPrint('Android notification permission: $granted');
      }

      // ==============================
      // CREATE CHANNEL
      // ==============================

      const bedtimeChannel = AndroidNotificationChannel(
        _bedtimeChannelId,
        _bedtimeChannelName,
        description: 'Nhắc người dùng chuẩn bị đi ngủ theo lịch đã thiết lập',
        importance: Importance.high,
      );

      await androidPlugin?.createNotificationChannel(bedtimeChannel);

      _isInitialized = true;

      debugPrint('NotificationService initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('NotificationService init error: $e');
      debugPrint('$stackTrace');

      rethrow;
    }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('Notification clicked: ${response.payload}');
  }

  Future<void> scheduleBedtimeReminders({
    required int hour,
    required int minute,
    required List<int> activeDays,
    required String title,
    required String body,
  }) async {
    await _ensureInitialized();

    if (activeDays.isEmpty) {
      debugPrint('Không có ngày nào được chọn -> bỏ qua schedule notification');
      return;
    }

    // Xóa reminder cũ trước khi schedule lại.
    await cancelAllBedtimeReminders();

    final uniqueDays = activeDays.toSet().toList()..sort();

    debugPrint('==============================');
    debugPrint('SCHEDULE BEDTIME REMINDERS');
    debugPrint('Time: $hour:$minute');
    debugPrint('Days: $uniqueDays');
    debugPrint('Timezone: ${tz.local.name}');
    debugPrint('==============================');

    for (final day in uniqueDays) {
      if (day < 1 || day > 7) {
        debugPrint('Bỏ qua weekday không hợp lệ: $day');
        continue;
      }

      await _scheduleWeeklyReminder(
        id: _notificationIdForDay(day),
        dayOfWeek: day,
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    }

    await debugPendingNotifications();
  }

  Future<void> _scheduleWeeklyReminder({
    required int id,
    required int dayOfWeek,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final scheduledDate = _nextInstanceOfTimeAndDay(dayOfWeek, hour, minute);

    debugPrint(
      'Schedule notification id=$id '
      'weekday=$dayOfWeek '
      'at=$scheduledDate',
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _bedtimeChannelId,
          _bedtimeChannelName,
          channelDescription:
              'Nhắc người dùng chuẩn bị đi ngủ theo lịch đã thiết lập',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),

      // Không dùng exactAllowWhileIdle.
      //
      // Bedtime reminder không cần chính xác tới từng giây
      // và tránh yêu cầu Exact Alarm permission.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,

      payload: 'bedtime_reminder',
    );
  }

  tz.TZDateTime _nextInstanceOfTimeAndDay(int dayOfWeek, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Tìm ngày trong tuần tiếp theo.
    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Nếu đúng weekday nhưng giờ đã qua,
    // chuyển sang tuần kế tiếp.
    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  int _notificationIdForDay(int day) {
    // 101 -> Monday
    // 102 -> Tuesday
    // ...
    // 107 -> Sunday
    return 100 + day;
  }

  Future<void> cancelAllBedtimeReminders() async {
    await _ensureInitialized();

    for (int day = 1; day <= 7; day++) {
      final id = _notificationIdForDay(day);

      await _notificationsPlugin.cancel(id: id);
    }

    debugPrint('All bedtime reminders cancelled');
  }

  Future<void> debugPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();

    debugPrint('==============================');
    debugPrint('PENDING NOTIFICATIONS: ${pending.length}');

    for (final notification in pending) {
      debugPrint(
        'id=${notification.id}, '
        'title=${notification.title}, '
        'body=${notification.body}, '
        'payload=${notification.payload}',
      );
    }

    debugPrint('==============================');
  }

  Future<void> showTestNotification() async {
    await _ensureInitialized();

    await _notificationsPlugin.show(
      id: 999,
      title: 'SleepCare 🌙',
      body: 'Thông báo đang hoạt động bình thường.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _bedtimeChannelId,
          _bedtimeChannelName,
          channelDescription:
              'Nhắc người dùng chuẩn bị đi ngủ theo lịch đã thiết lập',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'test_notification',
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
