import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class NotificationApi {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _tzInitialized = false;

  static const int _dailyReminderId = 1001;
  static const String _lastFireKey = 'reminder_last_fire_date';

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) {
        print('Notification tapped: ${resp.payload}');
      },
    );
    _isInitialized = true;

    // Best-effort request for Android 13+ runtime permission
    try {
      final androidImpl = notificationPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidImpl?.requestNotificationsPermission();
    } catch (_) {}

    await _reschedulePersistedDailyReminder();
    _startForegroundMissedCheck();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminders',
        channelDescription: 'Daily reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationPlugin.show(
      id,
      title ?? 'Daily Reminder',
      body ?? 'This is your daily reminder notification.',
      notificationDetails(),
    );
  }

  // -------- Daily Reminder Logic --------
  void _ensureTimeZones() {
    if (_tzInitialized) return;
    tz.initializeTimeZones();
    _tzInitialized = true;
  }

  Future<void> scheduleDailyReminder(
    TimeOfDay time, {
    String title = 'Daily Workout Reminder',
    String body = "It's time for your daily workout!",
    bool exact = false,
  }) async {
    await initNotification();
    _ensureTimeZones();

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Daily reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notificationPlugin.cancel(_dailyReminderId); // avoid duplicates

    try {
      await notificationPlugin.zonedSchedule(
        _dailyReminderId,
        title,
        body,
        scheduled,
        platformDetails,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print(
        'Daily reminder scheduled for ${scheduled.toLocal()} (exact=$exact)',
      );
      // Log pending to verify it's registered
      final pending = await notificationPlugin.pendingNotificationRequests();
      final daily = pending.where((p) => p.id == _dailyReminderId).isNotEmpty;
      print('Pending count: ${pending.length}; daily present: $daily');
    } catch (e) {
      print('Daily reminder scheduling failed: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
    await prefs.setBool('reminder_enabled', true);
  }

  Future<void> cancelDailyReminder() async {
    await initNotification();
    await notificationPlugin.cancel(_dailyReminderId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', false);
  }

  Future<TimeOfDay?> getPersistedReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('reminder_enabled') ?? false)) return null;
    final hour = prefs.getInt('reminder_hour');
    final minute = prefs.getInt('reminder_minute');
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _reschedulePersistedDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('reminder_enabled') ?? false;
    if (!enabled) return;
    final hour = prefs.getInt('reminder_hour');
    final minute = prefs.getInt('reminder_minute');
    if (hour == null || minute == null) return;
    await scheduleDailyReminder(TimeOfDay(hour: hour, minute: minute));
  }

  // -------- Fallback logic for missed reminders while app is foreground / resumed --------
  Timer? _missedCheckTimer;
  void _startForegroundMissedCheck() {
    _missedCheckTimer?.cancel();
    // Every minute, check if we crossed the scheduled time and didn't fire yet today
    _missedCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!(prefs.getBool('reminder_enabled') ?? false)) return;
      final hour = prefs.getInt('reminder_hour');
      final minute = prefs.getInt('reminder_minute');
      if (hour == null || minute == null) return;

      final now = DateTime.now();
      final scheduledToday = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (now.isBefore(scheduledToday)) return; // not yet time

      final last = prefs.getString(_lastFireKey); // format yyyy-mm-dd
      final todayKey = '${now.year}-${now.month}-${now.day}';
      if (last == todayKey) return; // already fired today

      // Fire fallback notification
      await showNotification(
        id: _dailyReminderId,
        title: 'Daily Workout Reminder',
        body: "It's time for your daily workout!",
      );
      await prefs.setString(_lastFireKey, todayKey);
      print('Fallback daily reminder fired at ${now.toLocal()}');
    });
  }

  // -------- Debug Helpers --------

  /// Log all pending notifications (Android/iOS) to debug console.
  Future<void> logPending() async {
    final pending = await notificationPlugin.pendingNotificationRequests();
    if (pending.isEmpty) {
      print('NotificationApi: No pending notifications');
    } else {
      for (final p in pending) {
        print(
          'Pending -> id:${p.id} title:${p.title} body:${p.body} payload:${p.payload}',
        );
      }
    }
  }

  /// Schedule a one-time notification [secondsFromNow] seconds in the future (for quick testing).
  Future<void> scheduleOneTimeTest({int secondsFromNow = 5}) async {
    await initNotification();
    _ensureTimeZones();
    final scheduled = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: secondsFromNow));
    final id = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;
    try {
      await notificationPlugin.zonedSchedule(
        id,
        'Test Notification',
        'Fired after $secondsFromNow seconds',
        scheduled,
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print(
        'Scheduled one-time test notification (id=$id) at ${scheduled.toLocal()}',
      );
    } catch (e) {
      print(
        'One-time zoned schedule failed ($e); falling back to immediate notification after delay',
      );
      // Fallback: manual delayed show
      Future.delayed(Duration(seconds: secondsFromNow), () {
        notificationPlugin.show(
          id,
          'Test Notification (Fallback)',
          'Fired after $secondsFromNow seconds (fallback)',
          notificationDetails(),
        );
      });
    }
  }
}
