import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';

class HomeProvider with ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        print("title");
      },
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {},
    );
  }

  Future<void> sendNotification(DateTime at,
      {String title, String message}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    // cancel all notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    // then send new one
    await flutterLocalNotificationsPlugin.schedule(
      0,
      title,
      message,
      at,
      platformChannelSpecifics,
    );
  }
}
