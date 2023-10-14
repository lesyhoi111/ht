import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  void initlocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/llipse20');
    var iosInitializationSetting = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotifications.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  void firebaseInit(BuildContext context) {
    // FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onMessage.listen((message) {
      // print('=====title: ${message.notification?.title}');
      // print('=====title: ${message.notification?.body}');
      // print('=====payload: ${message.notification!.android!.imageUrl}');
      // print('=====payload: ${message.data}');
      initlocalNotification(context, message);
      ShowNotification(message);
    });
  }

  Future<void> ShowNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Important Notification',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotifications.show(0, message.notification?.title.toString(),
          message.notification?.body.toString(), notificationDetails);
    });
  }

  void requestNotiPermission() async {
    NotificationSettings setting = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('user permission');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('user provisional permission');
    } else {
      // AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('user denied');
    }
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
  }
}

Future<void> handleBackgrounfMessage(RemoteMessage message) async {
  // print('=====title: ${message.notification?.title}');
  // print('=====title: ${message.notification?.body}');
  // print('=====payload: ${message.data}');
}
