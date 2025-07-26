import 'package:logger/logger.dart';
import 'package:barbell/core/services/firebase_notification_service.dart';
import 'package:barbell/core/services/storage_service.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    colors: true,
    printEmojis: true,
  ),
);

/// Professional App Service to handle app-wide initialization
/// This ensures services are initialized once and properly managed
class AppService {
  static bool _isInitialized = false;
  static bool _isNotificationInitialized = false;

  /// Initialize essential app services
  /// Call this in main.dart after Firebase initialization
  static Future<void> initializeApp() async {
    if (_isInitialized) return;

    try {
      logger.i("🚀 Initializing App Services...");

      // Initialize storage service first
      await StorageService.getAllDataFromStorage();
      logger.i("✅ Storage Service initialized");

      // Initialize notification service
      await _initializeNotificationService();

      _isInitialized = true;
      logger.i("✅ App Services initialized successfully");
    } catch (e) {
      logger.e("❌ Failed to initialize app services: $e");
      rethrow;
    }
  }

  /// Initialize notification service separately
  /// This can be called after user login to refresh token
  static Future<void> _initializeNotificationService() async {
    if (_isNotificationInitialized) return;

    try {
      logger.i("🔔 Initializing Notification Service...");
      await NotificationService.instance.initialize();
      _isNotificationInitialized = true;
      logger.i("✅ Notification Service initialized");
    } catch (e) {
      logger.e("❌ Failed to initialize notification service: $e");
      // Don't rethrow - app should work without notifications
    }
  }

  /// Call this after controllers are initialized to send any pending FCM tokens
  /// This should be called from ControllerBinder after NetworkCaller is available
  static Future<void> initializeNetworkDependentServices() async {
    try {
      logger.i("🔗 Initializing network-dependent services...");

      // Only try to send FCM token if user is actually logged in
      final bool isLoggedIn = await StorageService.isLoggedIn();
      if (isLoggedIn &&
          StorageService.accessToken != null &&
          StorageService.accessToken!.isNotEmpty) {
        logger.i("👤 User is logged in, sending FCM token...");
        await NotificationService.sendTokenToServer(
          accessToken: StorageService.accessToken,
        );
      } else {
        logger.i(
          "👤 User not logged in or token invalid, skipping FCM token send",
        );
      }

      logger.i("✅ Network-dependent services initialized");
    } catch (e) {
      logger.e("❌ Failed to initialize network-dependent services: $e");
    }
  }

  /// Call this after user login to send FCM token
  static Future<void> onUserLogin(String accessToken) async {
    try {
      logger.i("👤 User logged in, refreshing FCM token...");

      // Refresh and send FCM token immediately
      await NotificationService.refreshAndSendToken(accessToken: accessToken);

      logger.i("✅ FCM token sent for logged in user");
    } catch (e) {
      logger.e("❌ Failed to handle user login notification setup: $e");
    }
  }

  /// Call this when user logs out
  static Future<void> onUserLogout() async {
    try {
      logger.i("👤 User logged out, clearing FCM token...");

      // Clear FCM token
      await NotificationService.clearToken();

      logger.i("✅ FCM token cleared for logged out user");
    } catch (e) {
      logger.e("❌ Failed to handle user logout notification cleanup: $e");
    }
  }

  /// Get initialization status
  static bool get isInitialized => _isInitialized;
  static bool get isNotificationInitialized => _isNotificationInitialized;

  /// Reset initialization flags (useful for testing)
  static void resetInitialization() {
    _isInitialized = false;
    _isNotificationInitialized = false;
  }
}
