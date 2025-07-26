import 'package:get/get.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/notification/controller/get_notification_bell_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBadgeController extends GetxController {
  static const String _hasUnreadNotificationsKey = 'has_unread_notifications';

  // Observable for unread notification status
  final RxBool hasUnreadNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNotificationStatus();
  }

  /// Initialize notification status by checking server and local storage
  Future<void> _initializeNotificationStatus() async {
    // First load from local storage for immediate UI update
    await _loadUnreadStatus();

    // Then check server for actual status
    await _checkServerForNewNotifications();
  }

  /// Check server for new notifications using GetNotificationBellController
  Future<void> _checkServerForNewNotifications() async {
    try {
      // Get or create the notification bell controller
      final notificationBellController = Get.put(
        GetNotificationBellController(),
      );

      // Fetch notification status from server
      final success = await notificationBellController.getNotificationBell();

      if (success && notificationBellController.notificationBellModel != null) {
        final model = notificationBellController.notificationBellModel!;

        // Check if there are new notifications
        final hasNewNotifications = model.newNotification > 0;

        // Update the badge status
        if (hasNewNotifications != hasUnreadNotifications.value) {
          hasUnreadNotifications.value = hasNewNotifications;
          await _saveUnreadStatus(hasNewNotifications);
        }
      }
    } catch (e) {
      // Handle error silently, keep current status
      AppLoggerHelper.error('Error checking server for new notifications', e);
    }
  }

  /// Load unread status from local storage
  Future<void> _loadUnreadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      hasUnreadNotifications.value =
          prefs.getBool(_hasUnreadNotificationsKey) ?? false;
    } catch (e) {
      // Handle error silently, default to false
      hasUnreadNotifications.value = false;
    }
  }

  /// Save unread status to local storage
  Future<void> _saveUnreadStatus(bool hasUnread) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasUnreadNotificationsKey, hasUnread);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Mark that new notification received
  Future<void> markNewNotificationReceived() async {
    hasUnreadNotifications.value = true;
    await _saveUnreadStatus(true);
  }

  /// Mark all notifications as read (when user enters notification screen)
  Future<void> markNotificationsAsRead() async {
    hasUnreadNotifications.value = false;
    await _saveUnreadStatus(false);
  }

  /// Refresh notification status from server
  /// This can be called manually to sync with server
  Future<void> refreshNotificationStatus() async {
    await _checkServerForNewNotifications();
  }

  /// Update notification badge based on server response
  /// This can be called from any controller that fetches notification data
  void updateFromServerResponse({required int newNotificationCount}) {
    final hasNewNotifications = newNotificationCount > 0;
    if (hasNewNotifications != hasUnreadNotifications.value) {
      hasUnreadNotifications.value = hasNewNotifications;
      _saveUnreadStatus(hasNewNotifications);
    }
  }

  /// Check if there are unread notifications
  bool get hasUnread => hasUnreadNotifications.value;
}
