import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ===========================================================
// BACKGROUND NOTIFICATION ACTION
//
// Bắt buộc là top-level function.
// Khi showsUserInterface = false, Android gọi callback này
// mà KHÔNG mở ứng dụng.
// ===========================================================

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse response,
) {
  NotificationService()
      .handleBackgroundNotificationResponse(response);
}

class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // =========================================================
  // CHANNEL
  // =========================================================

  static const String _bedtimeChannelId =
      'sleepcare_bedtime_reminders_v2';

  static const String _bedtimeChannelName =
      'Nhắc giờ đi ngủ';

  static const String _bedtimeChannelDescription =
      'Thông báo nhắc chuẩn bị đi ngủ và giờ đi ngủ';

  // =========================================================
  // ACTION IDS
  // =========================================================

  static const String _actionUnderstood =
      'bedtime_understood';

  static const String _actionSnooze =
      'bedtime_snooze_action';

  // =========================================================
  // PAYLOAD
  // =========================================================

  static const String _payloadReminder =
      'bedtime_reminder';

  static const String _payloadSnooze =
      'bedtime_snooze';

  // =========================================================
  // SNOOZE ID
  // Chỉ cho phép tồn tại 1 snooze
  // =========================================================

  static const int _snoozeNotificationId = 300;

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    try {
      // =====================================================
      // TIMEZONE
      // =====================================================

      await _initializeTimezone();

      // =====================================================
      // INITIALIZATION SETTINGS
      // =====================================================

      const androidSettings =
          AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings =
          InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,

        // User bấm body notification / action có mở UI
        onDidReceiveNotificationResponse:
            _onDidReceiveNotificationResponse,

        // User bấm action có showsUserInterface = false
        onDidReceiveBackgroundNotificationResponse:
            notificationTapBackground,
      );

      // =====================================================
      // ANDROID PERMISSION
      // =====================================================

      final androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final granted =
            await androidPlugin
                .requestNotificationsPermission();

        debugPrint(
          'Android notification permission: $granted',
        );
      }

      // =====================================================
      // CHANNEL
      // =====================================================

      const bedtimeChannel =
          AndroidNotificationChannel(
        _bedtimeChannelId,
        _bedtimeChannelName,
        description:
            _bedtimeChannelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await androidPlugin
          ?.createNotificationChannel(
        bedtimeChannel,
      );

      _isInitialized = true;

      debugPrint(
        'NotificationService initialized successfully',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'NotificationService init error: $e',
      );

      debugPrint('$stackTrace');

      rethrow;
    }
  }

  // =========================================================
  // INITIALIZE TIMEZONE
  // =========================================================

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();

    try {
      final currentTimeZone =
          (await FlutterTimezone.getLocalTimezone())
              .identifier;

      tz.setLocalLocation(
        tz.getLocation(currentTimeZone),
      );

      debugPrint(
        'Notification timezone: $currentTimeZone',
      );
    } catch (e) {
      debugPrint(
        'Không thể lấy timezone thiết bị: $e',
      );

      tz.setLocalLocation(
        tz.getLocation(
          'Asia/Ho_Chi_Minh',
        ),
      );
    }
  }

  // =========================================================
  // REMINDER DETAILS
  //
  // Có:
  // [Đã hiểu] [Nhắc lại sau]
  //
  // showsUserInterface = false
  // => không mở app.
  // =========================================================

  NotificationDetails _bedtimeReminderDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _bedtimeChannelId,
        _bedtimeChannelName,
        channelDescription:
            _bedtimeChannelDescription,

        importance: Importance.max,
        priority: Priority.high,

        playSound: true,
        enableVibration: true,

        visibility:
            NotificationVisibility.public,

        category:
            AndroidNotificationCategory.reminder,

        autoCancel: true,

        icon: '@mipmap/ic_launcher',

        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            _actionUnderstood,
            'Đã hiểu',

            // Không mở app
            showsUserInterface: false,

            // Bấm xong đóng notification
            cancelNotification: true,
          ),

          AndroidNotificationAction(
            _actionSnooze,
            'Nhắc lại sau',

            // Không mở app
            showsUserInterface: false,

            // Bấm xong đóng notification
            cancelNotification: true,
          ),
        ],
      ),

      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel:
            InterruptionLevel.timeSensitive,
      ),
    );
  }

  // =========================================================
  // SNOOZE DETAILS
  //
  // Notification snooze chỉ có "Đã hiểu".
  // Không có "Nhắc lại sau" lần nữa.
  // =========================================================

  NotificationDetails _snoozeNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _bedtimeChannelId,
        _bedtimeChannelName,
        channelDescription:
            _bedtimeChannelDescription,

        importance: Importance.max,
        priority: Priority.high,

        playSound: true,
        enableVibration: true,

        visibility:
            NotificationVisibility.public,

        category:
            AndroidNotificationCategory.reminder,

        autoCancel: true,

        icon: '@mipmap/ic_launcher',

        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            _actionUnderstood,
            'Đã hiểu',
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),

      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel:
            InterruptionLevel.timeSensitive,
      ),
    );
  }

  // =========================================================
  // MAIN ISOLATE RESPONSE
  // =========================================================

  void _onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) {
    _handleNotificationResponse(
      response,
    );
  }

  // =========================================================
  // BACKGROUND ISOLATE RESPONSE
  //
  // Hàm public để top-level callback gọi được.
  // =========================================================

  Future<void>
      handleBackgroundNotificationResponse(
    NotificationResponse response,
  ) async {
    debugPrint(
      'BACKGROUND NOTIFICATION ACTION',
    );

    await _handleNotificationResponse(
      response,
      isBackground: true,
    );
  }

  // =========================================================
  // HANDLE RESPONSE
  // =========================================================

  Future<void> _handleNotificationResponse(
    NotificationResponse response, {
    bool isBackground = false,
  }) async {
    // Background isolate có singleton riêng,
    // nên phải chuẩn bị plugin/timezone lại.
    if (isBackground) {
      await _initializeForBackground();
    } else {
      await _ensureInitialized();
    }

    debugPrint(
      '==============================',
    );

    debugPrint(
      'NOTIFICATION RESPONSE',
    );

    debugPrint(
      'Background: $isBackground',
    );

    debugPrint(
      'id=${response.id}',
    );

    debugPrint(
      'actionId=${response.actionId}',
    );

    debugPrint(
      'payload=${response.payload}',
    );

    debugPrint(
      '==============================',
    );

    final actionId =
        response.actionId;

    final payload =
        response.payload;

    // =====================================================
    // ĐÃ HIỂU
    // =====================================================

    if (actionId ==
        _actionUnderstood) {
      if (response.id != null) {
        await _notificationsPlugin.cancel(
          id: response.id!,
        );
      }

      debugPrint(
        'User chọn: Đã hiểu',
      );

      return;
    }

    // =====================================================
    // NHẮC LẠI SAU
    // =====================================================

    if (actionId ==
        _actionSnooze) {
      final snoozeMinutes =
          _extractSnoozeMinutes(
        payload,
      );

      if (snoozeMinutes == null ||
          snoozeMinutes <= 0) {
        debugPrint(
          'Không tìm thấy snoozeMinutes hợp lệ trong payload: $payload',
        );

        return;
      }

      // Đóng notification hiện tại
      if (response.id != null) {
        await _notificationsPlugin.cancel(
          id: response.id!,
        );
      }

      // Xóa snooze cũ nếu có
      await _notificationsPlugin.cancel(
        id: _snoozeNotificationId,
      );

      // Tạo snooze mới đúng 1 lần
      await _scheduleOneTimeSnooze(
        snoozeMinutes,
      );

      debugPrint(
        'User chọn: Nhắc lại sau',
      );

      debugPrint(
        'Snooze sau $snoozeMinutes phút',
      );

      return;
    }

    // =====================================================
    // USER BẤM VÀO BODY
    // =====================================================

    if (payload?.startsWith(
          _payloadReminder,
        ) ==
        true) {
      debugPrint(
        'User clicked bedtime reminder body',
      );

      return;
    }

    if (payload ==
        _payloadSnooze) {
      debugPrint(
        'User clicked bedtime snooze body',
      );

      return;
    }
  }

  // =========================================================
  // BACKGROUND INITIALIZATION
  //
  // Không request permission trong background.
  // Chỉ initialize plugin + timezone để có thể schedule snooze.
  // =========================================================

  Future<void>
      _initializeForBackground() async {
    await _initializeTimezone();

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings:
          initializationSettings,

      onDidReceiveNotificationResponse:
          _onDidReceiveNotificationResponse,

      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackground,
    );

    _isInitialized = true;

    debugPrint(
      'NotificationService background initialized',
    );
  }

  // =========================================================
  // SCHEDULE BEDTIME REMINDERS
  //
  // Chỉ schedule notification chính.
  //
  // KHÔNG schedule snooze trước.
  // =========================================================

  Future<void>
      scheduleBedtimeReminders({
    required int hour,
    required int minute,
    required List<int> activeDays,
    required String title,
    required String body,
    required int snoozeMinutes,
  }) async {
    await _ensureInitialized();

    if (activeDays.isEmpty) {
      debugPrint(
        'Không có ngày nào được chọn -> bỏ qua schedule notification',
      );

      return;
    }

    // Xóa lịch cũ
    await cancelAllBedtimeReminders();

    final uniqueDays =
        activeDays.toSet().toList()
          ..sort();

    debugPrint(
      '==============================',
    );

    debugPrint(
      'SCHEDULE BEDTIME REMINDERS',
    );

    debugPrint(
      'Reminder time: '
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}',
    );

    debugPrint(
      'Days: $uniqueDays',
    );

    debugPrint(
      'Snooze setting: $snoozeMinutes phút',
    );

    debugPrint(
      'Timezone: ${tz.local.name}',
    );

    debugPrint(
      '==============================',
    );

    for (final day in uniqueDays) {
      if (day < 1 ||
          day > 7) {
        debugPrint(
          'Bỏ qua weekday không hợp lệ: $day',
        );

        continue;
      }

      // Ví dụ:
      // bedtime_reminder|10
      //
      // 10 = snoozeMinutes

      final payload =
          '$_payloadReminder|$snoozeMinutes';

      await _scheduleWeeklyReminder(
        id:
            _notificationIdForDay(
          day,
        ),

        dayOfWeek:
            day,

        hour:
            hour,

        minute:
            minute,

        title:
            title.isNotEmpty
                ? title
                : '🌙 Đến giờ chuẩn bị đi ngủ',

        body:
            body.isNotEmpty
                ? body
                : 'Hãy thư giãn và chuẩn bị cho một giấc ngủ ngon.',

        payload:
            payload,
      );
    }

    await debugPendingNotifications();
  }

  // =========================================================
  // WEEKLY REMINDER
  // =========================================================

  Future<void>
      _scheduleWeeklyReminder({
    required int id,
    required int dayOfWeek,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String payload,
  }) async {
    final scheduledDate =
        _nextInstanceOfTimeAndDay(
      dayOfWeek,
      hour,
      minute,
    );

    debugPrint(
      'Schedule notification '
      'id=$id '
      'weekday=$dayOfWeek '
      'at=$scheduledDate '
      'payload=$payload',
    );

    await _notificationsPlugin.zonedSchedule(
      id:
          id,

      title:
          title,

      body:
          body,

      scheduledDate:
          scheduledDate,

      notificationDetails:
          _bedtimeReminderDetails(),

      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle,

      matchDateTimeComponents:
          DateTimeComponents
              .dayOfWeekAndTime,

      payload:
          payload,
    );
  }

  // =========================================================
  // ONE-TIME SNOOZE
  //
  // Không lặp.
  // =========================================================

  Future<void> _scheduleOneTimeSnooze(
    int snoozeMinutes,
  ) async {
    final now =
        tz.TZDateTime.now(
      tz.local,
    );

    final scheduledDate =
        now.add(
      Duration(
        minutes:
            snoozeMinutes,
      ),
    );

    debugPrint(
      '==============================',
    );

    debugPrint(
      'SCHEDULE ONE-TIME SNOOZE',
    );

    debugPrint(
      'Now: $now',
    );

    debugPrint(
      'Snooze minutes: $snoozeMinutes',
    );

    debugPrint(
      'Snooze at: $scheduledDate',
    );

    debugPrint(
      '==============================',
    );

    await _notificationsPlugin.zonedSchedule(
      id:
          _snoozeNotificationId,

      title:
          '😴 Đã đến giờ đi ngủ',

      body:
          'Đặt điện thoại xuống và dành thời gian để cơ thể nghỉ ngơi.',

      scheduledDate:
          scheduledDate,

      notificationDetails:
          _snoozeNotificationDetails(),

      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle,

      // Không có matchDateTimeComponents
      // => chỉ chạy 1 lần.
      payload:
          _payloadSnooze,
    );

    await debugPendingNotifications();
  }

  // =========================================================
  // EXTRACT SNOOZE MINUTES
  //
  // bedtime_reminder|10
  // =========================================================

  int? _extractSnoozeMinutes(
    String? payload,
  ) {
    if (payload == null ||
        payload.isEmpty) {
      return null;
    }

    final parts =
        payload.split('|');

    if (parts.length != 2) {
      return null;
    }

    if (parts[0] !=
        _payloadReminder) {
      return null;
    }

    return int.tryParse(
      parts[1],
    );
  }

  // =========================================================
  // CALCULATE NEXT WEEKDAY
  // =========================================================

  tz.TZDateTime
      _nextInstanceOfTimeAndDay(
    int dayOfWeek,
    int hour,
    int minute,
  ) {
    final now =
        tz.TZDateTime.now(
      tz.local,
    );

    var scheduledDate =
        tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (
        scheduledDate.weekday !=
            dayOfWeek) {
      scheduledDate =
          scheduledDate.add(
        const Duration(
          days: 1,
        ),
      );
    }

    if (!scheduledDate
        .isAfter(now)) {
      scheduledDate =
          scheduledDate.add(
        const Duration(
          days: 7,
        ),
      );
    }

    return scheduledDate;
  }

  // =========================================================
  // NOTIFICATION ID
  // =========================================================

  int _notificationIdForDay(
    int day,
  ) {
    return 100 + day;
  }

  // =========================================================
  // CANCEL ALL
  // =========================================================

  Future<void>
      cancelAllBedtimeReminders() async {
    await _ensureInitialized();

    for (
      int day = 1;
      day <= 7;
      day++
    ) {
      await _notificationsPlugin.cancel(
        id:
            _notificationIdForDay(
          day,
        ),
      );
    }

    await _notificationsPlugin.cancel(
      id: _snoozeNotificationId,
    );

    debugPrint(
      'All bedtime reminders and snooze reminder cancelled',
    );
  }

  // =========================================================
  // DEBUG PENDING
  // =========================================================

  Future<void>
      debugPendingNotifications() async {
    await _ensureInitialized();

    final pending =
        await _notificationsPlugin
            .pendingNotificationRequests();

    debugPrint(
      '==============================',
    );

    debugPrint(
      'PENDING NOTIFICATIONS: ${pending.length}',
    );

    for (final notification
        in pending) {
      debugPrint(
        'id=${notification.id}, '
        'title=${notification.title}, '
        'body=${notification.body}, '
        'payload=${notification.payload}',
      );
    }

    debugPrint(
      '==============================',
    );
  }

  // =========================================================
  // TEST
  //
  // Dùng đúng reminder details để test action.
  // =========================================================

  Future<void>
      showTestNotification() async {
    await _ensureInitialized();

    await _notificationsPlugin.show(
      id:
          999,

      title:
          '🌙 Test notification',

      body:
          'Kiểm tra nút hành động.',

      notificationDetails:
          _bedtimeReminderDetails(),

      // Test snooze = 10 phút
      payload:
          '$_payloadReminder|10',
    );
  }

  // =========================================================
  // ENSURE INITIALIZED
  // =========================================================

  Future<void>
      _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}