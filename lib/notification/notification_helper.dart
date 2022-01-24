import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsHelper {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const _initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  static const _initializationSettings =
      InitializationSettings(android: _initializationSettingsAndroid);

  static Future<void> init() async {
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
    tz.initializeDatabase([]);
  }

  static const _androidNotificationDetails = AndroidNotificationDetails(
    'trip',
    'trip reminder',
    channelDescription: '7 days until trip reminder',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const _notificationDetails =
      NotificationDetails(android: _androidNotificationDetails);

  static Future<void> setNotification(
    DateTime dateTime,
    String body,
    int id,
  ) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Your next trip',
      body,
      tz.TZDateTime(
        tz.local,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        10,
      ),
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
