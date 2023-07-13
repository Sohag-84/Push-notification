// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
