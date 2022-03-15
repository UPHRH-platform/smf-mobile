// import 'dart:convert';
// import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:smf_mobile/pages/home_page.dart';

class NotificationHelper {
  // static void onSelectNotification(
  //   BuildContext context,
  //   String payload,
  // ) {
  //   Map data = jsonDecode(payload);
  //   print('Application ID 2: ' + data['applicationId']);
  // }

  static Future<void> scheduleNotification(
      // BuildContext context,
      DateTime scheduledNotificationDateTime,
      int notificationId,
      String title,
      String notes,
      String applicationId) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('flutter_devs');
    // var initializationSettingsIOs = const IOSInitializationSettings();
    // var initSetttings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: (payload) async {
    //   // print('payload: $payload');
    //   // onSelectNotification(context, payload!);
    // });

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      icon: 'flutter_devs',
      enableVibration: true,
      enableLights: true,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('mixkit_happy_bell'),
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
      styleInformation: BigTextStyleInformation(''),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    Map payload = {'applicationId': applicationId};
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(notificationId, title, notes,
        scheduledNotificationDateTime, platformChannelSpecifics,
        payload: jsonEncode(payload));
  }
}
