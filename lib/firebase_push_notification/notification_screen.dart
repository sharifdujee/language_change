import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatelessWidget {
  static const route = '/notification_route';
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cast the arguments to RemoteMessage
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: ${message?.notification?.title ?? 'No Title'}'),
            Text('Body: ${message?.notification?.body ?? 'No Body'}'),
            Text('Payload: ${message?.data ?? 'No Payload'}'),
          ],
        ),
      ),
    );
  }
}
