import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Request notification permissions from the user
  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("ℹ️ User granted provisional permission");
    } else {
      print("❌ User denied permission");
    }
  }

  /// Initialize local notifications safely for both Android and iOS
  static Future<void> localNotiInit() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / Darwin initialization
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Platform-specific permission requests
    await _requestPlatformSpecificPermissions();

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    print("✅ Local notifications initialized");
  }

  /// Platform-specific permission requests
  static Future<void> _requestPlatformSpecificPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        print("✅ Android notification permission requested");
      }
    } else if (Platform.isIOS) {
      // iOS permissions are already handled via DarwinInitializationSettings
      final bool isSimulator = await _isIOSSimulator();
      if (isSimulator) {
        print(
            "⚠️ Running on iOS simulator - some notification features may be limited");
      }
    }
  }

  /// Detect if running on iOS simulator
  static Future<bool> _isIOSSimulator() async {
    if (!Platform.isIOS) return false;
    try {
      final apnsToken = await messaging.getAPNSToken();
      return apnsToken == null;
    } catch (e) {
      return true; // If APNS token unavailable, assume simulator
    }
  }

  /// Handle notification taps
  static void onNotificationTap(NotificationResponse notificationResponse) {
    print("📩 Notification tapped: ${notificationResponse.payload}");
    // navigatorKey.currentState!.pushNamed("/message", arguments: notificationResponse);
  }

  /// Show a simple notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your channel name',
      channelDescription: 'your channel description',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformDetails,
        payload: payload,
      );
      print("✅ Notification shown successfully");
    } catch (e) {
      print("❌ Error showing notification: $e");
    }
  }

  /// Get FCM token safely
  static Future<String?> getFCMToken() async {
    try {
      if (Platform.isIOS && await _isIOSSimulator()) {
        final dummyToken = "ios_simulator_dummy_token";
        print("⚠️ Using dummy FCM token for iOS simulator: $dummyToken");
        return dummyToken;
      } else {
        final token = await messaging.getToken();
        print("✅ FCM Token: $token");
        return token;
      }
    } catch (e) {
      print("❌ Error getting FCM token: $e");
      return null;
    }
  }
}
