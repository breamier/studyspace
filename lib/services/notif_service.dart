import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' as io;

class NotifService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;
    if (io.Platform.isAndroid) {
      await _requestPermission();
    }

    const initSettingsAndroid =
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
}
