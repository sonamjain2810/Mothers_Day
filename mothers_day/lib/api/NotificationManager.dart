import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificatioPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("flutter_logo");

    DarwinInitializationSettings initalizationIos =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initalizationIos);

    await notificatioPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            ((NotificationResponse notificationResponse) async {}));
  }

  /*Future<void> simpleNotifactionShow() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            priority: Priority.high,
            importance: Importance.max,
            channelShowBadge: true,
            icon: 'ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'));

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());
    await notificatioPlugin.show(
        0, 'simple notification', 'new user send message', notificationDetails);
  }*/

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            priority: Priority.high,
            importance: Importance.max,
            channelShowBadge: true,
            icon: 'ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher')),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificatioPlugin.show(id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduleNotificationDateTime}) async {
    return notificatioPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
