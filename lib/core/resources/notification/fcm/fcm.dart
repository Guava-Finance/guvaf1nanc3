import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/services/storage.dart';

final fcmProvider = Provider<FCMService>((ref) => FCMService(
      storageService: ref.watch(securedStorageServiceProvider),
    ));

class FCMService {
  FCMService({
    required this.storageService,
  });

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final SecuredStorageService storageService;

   FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  /// Initialize FCM
  /// To be done once the user gets to the Dashboard
  Future<void> initialize() async {
    /// Request permission for notifications (if not already granted)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.log('User granted permission for notifications');
    } else {
      AppLogger.log('User declined or has not accepted permission');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.log('Got a message whilst in the foreground!');
      AppLogger.log('Message data: ${message.data}');

      if (message.notification != null) {
        AppLogger.log(
            'Message also contained a notification: ${message.notification}');
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.log('Message opened from background: ${message.data}');
    });

    // Handle initial message when the app is opened from a terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.log('App opened from terminated state: ${initialMessage.data}');
    }
  }

  Future<String?> fcmToken() async {
    final persistedToken = await storageService.readFromStorage(
      Strings.fcmToken,
    );

    String? token = await _firebaseMessaging.getToken();

    if (token != null && token != persistedToken) {
      await storageService.writeToStorage(key: Strings.fcmToken, value: token);

      return token;
    }

    return null;
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    AppLogger.log('Handling a background message: ${message.messageId}');
    AppLogger.log('Message data: ${message.data}');
    if (message.notification != null) {
      AppLogger.log('Notification: ${message.notification}');
    }
  }

  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    AppLogger.log('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    AppLogger.log('Unsubscribed from topic: $topic');
  }

  // Get the current FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Delete the FCM token (useful for logout scenarios)
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    AppLogger.log('FCM token deleted');
  }
}
