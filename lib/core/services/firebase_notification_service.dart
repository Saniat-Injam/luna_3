import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/controllers/notification_badge_controller.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/notification/screen/notification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
  ),
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();

  // Mark notification as unread when received in background
  try {
    final badgeController = Get.find<NotificationBadgeController>();
    await badgeController.markNewNotificationReceived();
  } catch (e) {
    // Controller might not be initialized yet, that's okay
    // We'll handle it when the app starts
  }

  await NotificationService.instance.showNotification(message);
}

/// Background notification response handler
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  logger.i('Background notification tapped: ${notificationResponse.payload}');
  // Handle background notification tap
  // Note: This runs in a separate isolate, so navigation should be handled carefully
}

class NotificationService {
  // Singleton object
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _fcmTokenKey = 'fcm-token';
  static String? fcmToken;

  final _messaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  // Network caller instance
  NetworkCaller? _networkCaller;

  Future<void> initialize() async {
    await StorageService.getAllDataFromStorage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Try to initialize network caller, but don't fail if it's not available yet
    try {
      _networkCaller = Get.find<NetworkCaller>();
      logger.i("NetworkCaller found and initialized");
    } catch (e) {
      logger.w(
        "NetworkCaller not available yet during initialization. Will retry later.",
      );
      _networkCaller = null;
    }

    // Setup Flutter local notifications first
    await setupFlutterNotifications();

    // request permission
    await _requestPermission();

    // setup message handler
    await _setupMessageHandlers();

    // Get initial token
    fcmToken = await _messaging.getToken();
    if (fcmToken != null) {
      await _saveFcmTokenLocally(fcmToken!);
      logger.i("FCM Token obtained: $fcmToken");
    }

    // Don't send token during initialization - wait for explicit login
    logger.i(
      "FCM token obtained and saved locally. Will send to server after login.",
    );

    // Listen for token changes and send immediately
    _messaging.onTokenRefresh.listen((newToken) async {
      logger.i("FCM Token refreshed: $newToken");
      fcmToken = newToken;
      await _saveFcmTokenLocally(newToken);

      // Only send refreshed token if user is logged in
      if (_networkCaller != null &&
          StorageService.accessToken != null &&
          StorageService.accessToken!.isNotEmpty) {
        final bool isLoggedIn = await StorageService.isLoggedIn();
        if (isLoggedIn) {
          await _sendTokenToServerWithRetry(
            accessToken: StorageService.accessToken,
          );
        } else {
          logger.i("Token refreshed but user not logged in");
        }
      } else {
        logger.i(
          "Token refreshed but NetworkCaller not available or user not logged in",
        );
      }
    });
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    logger.i('Permission status: ${settings.authorizationStatus}');

    // For Android 13+ request notification permission
    if (GetPlatform.isAndroid) {
      final androidPlugin =
          _localNotification
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted =
          await androidPlugin?.requestNotificationsPermission();
      logger.i('Android notification permission granted: $granted');
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'My high importance notifications',
      importance: Importance.high,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // ios setup
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // Add notification categories if you plan to use notification actions
      notificationCategories: [
        DarwinNotificationCategory(
          'general',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Open App'),
          ],
        ),
      ],
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // flutter notification setup
    await _localNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        // Handle notification tap when app is running
        final payload = notificationResponse.payload;
        logger.i('Notification tapped with payload: $payload');

        // Navigate to notification screen
        if (Get.context != null) {
          Get.to(() => NotificationScreen());
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      RemoteNotification? notification = message.notification;

      if (notification == null) {
        logger.w("Received message without notification data");
        return;
      }

      logger.i("Showing notification: ${notification.title}");

      // Mark notification as unread when it arrives
      try {
        final badgeController = Get.find<NotificationBadgeController>();
        await badgeController.markNewNotificationReceived();
      } catch (e) {
        // Controller might not be initialized yet, that's okay
        logger.w(
          "NotificationBadgeController not found during notification show",
        );
      }

      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'My high importance notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
            // Add more customization
            color: const Color(0xFF2196F3),
            showWhen: true,
            when: DateTime.now().millisecondsSinceEpoch,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: 'general',
            // Add custom sound if needed
            // sound: 'notification_sound.aiff',
          ),
        ),
        payload: message.data.isNotEmpty ? message.data.toString() : null,
      );

      logger.i("Notification displayed successfully");
    } catch (e) {
      logger.e("Failed to show notification: $e");
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      logger.i('Received foreground message: ${message.notification?.title}');
      logger.i('Message data: ${message.data}');

      // Mark notification as unread when received in foreground
      try {
        final badgeController = Get.find<NotificationBadgeController>();
        badgeController.markNewNotificationReceived();
      } catch (e) {
        // Controller might not be initialized yet, that's okay
        logger.w(
          "NotificationBadgeController not found during foreground message",
        );
      }

      showNotification(message);
    });

    // Background message (app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Check if app was opened from a terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      logger.i('App opened from terminated state via notification');
      _handleBackgroundMessage(initialMessage);
    }
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    logger.i('Background message received: ${message.notification?.title}');
    logger.i('Message data: ${message.data}');

    // Handle different message types
    if (message.data['type'] == 'chat') {
      logger.i('Chat notification received');
      // Navigate to chat or specific screen based on your app logic
    } else if (message.data['type'] == 'general') {
      logger.i('General notification received');
      // Navigate to notification screen
      if (Get.context != null) {
        Get.to(() => NotificationScreen());
      }
    }
  }

  /// Save FCM token locally for offline scenarios
  Future<void> _saveFcmTokenLocally(String token) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_fcmTokenKey, token);
      logger.i("FCM token saved locally");
    } catch (e) {
      logger.e("Failed to save FCM token locally: $e");
    }
  }

  /// Get saved FCM token from local storage
  Future<String?> get savedFcmToken async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(_fcmTokenKey);
    } catch (e) {
      logger.e("Failed to get saved FCM token: $e");
      return null;
    }
  }

  /// Send token to server with retry mechanism
  Future<void> _sendTokenToServerWithRetry({
    required String? accessToken,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    if (accessToken == null || accessToken.isEmpty) {
      logger.i("No access token available. Skipping FCM token upload.");
      return;
    }

    if (fcmToken == null || fcmToken!.isEmpty) {
      logger.i("No FCM token available. Skipping token upload.");
      return;
    }

    // Try to get NetworkCaller if not available
    if (_networkCaller == null) {
      try {
        _networkCaller = Get.find<NetworkCaller>();
        logger.i("NetworkCaller obtained for token sending");
      } catch (e) {
        logger.w(
          "NetworkCaller still not available. Skipping token send for now.",
        );
        return;
      }
    }

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        logger.i(
          "Sending FCM token to server (attempt $attempt/$maxRetries)...",
        );

        final response = await _networkCaller!.postRequest(
          url: Urls.setFCMToken,
          body: {"fcmToken": fcmToken},
          accessToken: accessToken,
        );

        if (response.isSuccess) {
          logger.i("FCM token sent successfully");
          return; // Success, exit the retry loop
        } else {
          // Check if it's an authentication error - don't retry for these
          if (response.errorMessage?.contains("Unauthorized") == true ||
              response.errorMessage?.contains("Invalid Token") == true) {
            logger.e(
              "Authentication error while sending FCM token: ${response.errorMessage}",
            );
            logger.e("Stopping retries due to authentication failure");
            return; // Don't retry for auth errors
          }

          logger.w(
            "Failed to send FCM token (attempt $attempt): ${response.errorMessage}",
          );
          if (attempt == maxRetries) {
            logger.e("Failed to send FCM token after $maxRetries attempts");
          }
        }
      } catch (e) {
        logger.e("Exception while sending FCM token (attempt $attempt): $e");
        if (attempt == maxRetries) {
          logger.e(
            "Failed to send FCM token after $maxRetries attempts due to exceptions",
          );
        }
      }

      // Wait before next retry (except for the last attempt)
      if (attempt < maxRetries) {
        await Future.delayed(delay);
      }
    }
  }

  /// Public method to manually trigger token sending (useful after login)
  /// Validates user login status before sending
  static Future<void> sendTokenToServer({required String? accessToken}) async {
    try {
      // Validate that user is actually logged in
      final bool isLoggedIn = await StorageService.isLoggedIn();
      if (!isLoggedIn) {
        logger.w("User not logged in, skipping FCM token send");
        return;
      }

      if (accessToken == null || accessToken.isEmpty) {
        logger.w("Access token is null or empty, skipping FCM token send");
        return;
      }

      logger.i("Sending FCM token for authenticated user...");
      await instance._sendTokenToServerWithRetry(accessToken: accessToken);
    } catch (e) {
      logger.e("Failed to send FCM token: $e");
    }
  }

  // Deprecated: Use sendTokenToServer instead
  @Deprecated('Use sendTokenToServer instead')
  static Future<void> tryToSendTokenToServer({
    required String? accessToken,
  }) async {
    await sendTokenToServer(accessToken: accessToken);
  }

  /// Request exact alarm permission for Android 14+
  Future<bool> requestExactAlarmPermission() async {
    if (GetPlatform.isAndroid) {
      final androidPlugin =
          _localNotification
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidPlugin?.requestExactAlarmsPermission() ?? false;
    }
    return true;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (GetPlatform.isAndroid) {
      final androidPlugin =
          _localNotification
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    } else if (GetPlatform.isIOS) {
      final iosPlugin =
          _localNotification
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      return await iosPlugin?.checkPermissions().then(
            (permissions) => permissions?.isEnabled ?? false,
          ) ??
          false;
    }
    return true;
  }

  /// Force refresh token and send to server immediately
  /// This should be called after successful login
  static Future<void> refreshAndSendToken({required String accessToken}) async {
    try {
      logger.i("Force refreshing FCM token...");
      await FirebaseMessaging.instance.deleteToken();
      final newToken = await FirebaseMessaging.instance.getToken();

      if (newToken != null) {
        fcmToken = newToken;
        await instance._saveFcmTokenLocally(newToken);
        logger.i("New FCM token obtained: $newToken");

        // Send immediately with retry
        await instance._sendTokenToServerWithRetry(accessToken: accessToken);
      }
    } catch (e) {
      logger.e("Failed to refresh and send FCM token: $e");
    }
  }

  /// Get current FCM token (useful for debugging)
  static Future<String?> getCurrentToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      logger.e("Failed to get current FCM token: $e");
      return null;
    }
  }

  /// Clear FCM token when user logs out
  static Future<void> clearToken() async {
    try {
      logger.i("Clearing FCM token...");

      // Delete token from Firebase
      await FirebaseMessaging.instance.deleteToken();

      // Clear local storage
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_fcmTokenKey);

      // Clear in-memory token
      fcmToken = null;

      logger.i("FCM token cleared successfully");
    } catch (e) {
      logger.e("Failed to clear FCM token: $e");
    }
  }
}
