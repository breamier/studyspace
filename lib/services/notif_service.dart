import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' as io;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

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
  Future<void> scheduleNotification(
      {int id = 1,
      required String title,
      required String body,
      required int hour,
      required int minute}) async {
    if (!_isInitialized) {
      await initNotification();
    }
    // Get current DateTime
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Schedule Notification
    await notificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);

    if (scheduledDate.isBefore(now)) {
      print("Scheduled time is in the past. Skipping...");
      return;
    } else {
      print("_________Scheduled Notif_______$hour:$minute ____");
    }
  }

  // Cancel Notification
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
