// ignore_for_file: prefer_const_constructors

import 'package:firebase_notification/services/notification_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context: context);

    notificationServices.getToken().then((value) {
      print("=== === Device Token: $value === ===");
    });
    notificationServices.setupInteractMessage(context: context);
    // notificationServices.refreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notification"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Firebase Push notification"),
      ),
    );
  }
}
