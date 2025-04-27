import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(initSettings);
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
