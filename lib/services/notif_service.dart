import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' as io;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:studyspace/constants/custom_notifications.dart';

class NotifService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;
    if (io.Platform.isAndroid) {
      await _requestPermission();
    }

    // Initialize TimeZone
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Initialize Android
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  Future<void> _requestPermission() async {
    if (io.Platform.isAndroid) {
      final androidImplementation =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        if (granted ?? false) {
          print("Notification permission granted");
        } else {
          print("Notification permission denied");
        }
      }
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'study_space_id',
      'Study Space',
      channelDescription: 'Study Space',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    ));
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    if (!_isInitialized) {
      await initNotification();
    }
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  // Scheduled Notification
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (!_isInitialized) {
      await initNotification();
    }
    // Get current DateTime
    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    if (scheduledDate.isBefore(now)) {
      print("Scheduled time is in the past. Skip");
      return;
    }

    // Schedule Notification
    await notificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);

    print("_________Scheduled Notif_______$scheduledDate ____");
  }

  // Cancel Notification
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> printScheduledNotifications() async {
    final notifications =
        await notificationsPlugin.pendingNotificationRequests();
    for (var notif in notifications) {
      print('🔔 ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}');
    }
  }

  Future<void> scheduleDailyCustomNotifications() async {
    await cancelAllNotifications();

    final now = DateTime.now();
    final random = Random();

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));

      // 8:00 AM Notification
      await scheduleNotification(
        id: dayOffset * 2,
        title: "Study Space 🛰️",
        body: customNotificationMessages[
            random.nextInt(customNotificationMessages.length)],
        dateTime: DateTime(date.year, date.month, date.day, 23, 30),
      );

      // Random Time Notification (between 10AM and 8PM)
      final randomHour = 10 + random.nextInt(10);
      await scheduleNotification(
        id: dayOffset * 2 + 1,
        title: "Study Space 🌌",
        body: customNotificationMessages[
            random.nextInt(customNotificationMessages.length)],
        dateTime: DateTime(date.year, date.month, date.day, randomHour),
      );
    }
  }

  static void scheduleDailyNotifStatic() {
    scheduleDailyNotifCallback();
  }
}

@pragma('vm:entry-point') // For background notif
void scheduleDailyNotifCallback() async {
  final service = NotifService();
  await service.initNotification();
  await service.scheduleDailyCustomNotifications();

  print("Scheduling notifications...");

  await service.showNotification(
    title: "Test Notification",
    body: "Alarm triggered at ${DateTime.now()}",
  );
}
