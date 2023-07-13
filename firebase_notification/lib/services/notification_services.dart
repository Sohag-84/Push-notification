// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/views/message_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///request to notification permission
  void requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("=== === User permission granted === ===");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("=== === User permission provisional granted === ===");
    } else {
      print("=== === User permission denied === ===");
    }
  }

  void initLocalNotification(
      {required BuildContext context, required RemoteMessage message}) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    ///for showing ios device notification
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context: context, message: message);
      },
    );
  }

  void firebaseInit({required BuildContext context}) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("=== === Notification Title: ${message.notification!.title}");
        print("=== === Notification Body: ${message.notification!.body}");
        print("=== === Notification message id: ${message.messageId}");
        print("=== === Notification sender Id: ${message.senderId}");
        print("=== === Notification send time: ${message.sentTime}");
        print("=== === Notification data type: ${message.data['type']}");
        print("=== === Notification data id: ${message.data['id']}");
      }
      if(Platform.isAndroid){
        initLocalNotification(context: context, message: message);
        showNotification(message: message);
      }else{
        showNotification(message: message);
      }

    });
  }

  //for show notification
  Future<void> showNotification({required RemoteMessage message}) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );

    ///for showing android notification
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    ///for showing ios notification
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  ///get device token
  Future<String> getToken() async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }

  ///if token will expire then it regenerate device token
  void refreshToken() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      print("=== Token Refresh: ${event.toString()} ===");
    });
  }

  ///handle message
  void handleMessage(
      {required BuildContext context, required RemoteMessage message}) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageScreen(
            title: message.data['type'],
            id: message.data['id'],
          ),
        ),
      );
    }
  }
}
