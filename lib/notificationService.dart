import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotification = FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _localNotification.initialize(settings);

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpen);
  }

  /// FOREGROUND MESSAGE
  static void _onMessage(RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  /// WHEN CLICK ON NOTIFICATION
  static void _onOpen(RemoteMessage message) {
    log("Notification clicked");
  }

  /// GET TOKEN
  static Future<String?> getToken() async {
    final token = await _firebaseMessaging.getToken();
    log("FCM TOKEN: $token");
    return token;
  }
}