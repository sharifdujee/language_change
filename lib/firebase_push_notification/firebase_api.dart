import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather/firebase_push_notification/notification_screen.dart';
import 'package:weather/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('payload: ${message.data}');
}

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  navigatorKey.currentState?.pushNamed(
    NotificationScreen.route,
    arguments: message,
  );
}

Future<void> initPushNotification() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotification.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.toMap()),
    );
  });
}

final _androidChannel = const AndroidNotificationChannel(
  'high_importance_channel',
  'high_importance_notification',
  description: 'This channel is used for important notifications',
  importance: Importance.defaultImportance,
);

final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

Future<void> initLocalNotification() async {
  const android = AndroidInitializationSettings('@drawable/ic_launcher');

  const settings = InitializationSettings(android: android);
  await _localNotification.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        await handleMessage(message);
      }
    },
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('The token is $fCMToken');
    await initPushNotification();
    await initLocalNotification();

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
