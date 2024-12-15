import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNoticeService {
  static final LocalNoticeService _instance = LocalNoticeService._internal();

  factory LocalNoticeService() => _instance;

  LocalNoticeService._internal();

  Future<void> setup() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon', // Ensure your app icon is added here.
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Pomodoro Notifications',
          channelDescription: 'Notification channel for Pomodoro Timer',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  Future<void> addNotification(String title, String body, int endTime) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.fromMillisecondsSinceEpoch(endTime),
      ),
    );
  }
}
