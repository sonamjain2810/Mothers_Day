import 'package:flutter/material.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import '/api/NotificationManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'App_Theme.dart';
import 'HomePage.dart';
import 'utils/SizeConfig.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification;
  tz.initializeTimeZones();
  /*NotificationService().showNotification(
    title: "Good Morning Messages & Images",
    body: "It Works!",
  );*/

  DateFormat format = DateFormat("yyyy-mm-dd hh:mm");
  DateTime date = DateTime.now();
  date = date.add(const Duration(
    days: 1,
    hours: 0,
    minutes: 0,
  ));
  NotificationService().scheduleNotification(
      title: 'Good Morning Messages & Images',
      body: 'Scheduled Notification',
      scheduleNotificationDateTime: date);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final facebookAppEvents = FacebookAppEvents();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            title: 'App Name', // Replace your app name here
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      );
    });
  }
}
