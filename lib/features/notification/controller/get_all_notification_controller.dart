import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/notification/controller/notification_controller.dart';
import 'package:barbell/features/notification/model/notifications_model.dart';
import 'package:logger/logger.dart';

class GetAllNotificationController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationsModel? _notificationsModel;
  NotificationsModel? get notificationsModel => _notificationsModel;

  /// Toggles the loading state
  void toggleLoading() {
    _isLoading = !_isLoading;
    update(); // Notify listeners about the change
  }

  /// Get all notifications
  Future<bool> getAllNotifications() async {
    _isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getAllNotifications,
    );

    if (response.isSuccess) {
      final data = response.responseData['data'];
      if (data != null) {
        _notificationsModel = NotificationsModel.fromJson(data);
      } else {
        _notificationsModel = NotificationsModel(
          id: '',
          userId: '',
          profileId: '',
          createdAt: '',
          newNotification: 0,
          notificationList: [],
          oldNotificationCount: 0,
          seenNotificationCount: 0,
          updatedAt: '',
        ); // Default to an empty model
      }

      // Clear swipe offsets when notifications are reloaded
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().clearOffsets();
      }

      isSuccess = true;
    } else {
      // Handle error case
      _notificationsModel = null; // Clear the model on error
      EasyLoading.showError(
        'Failed to fetch all notifications',
        duration: const Duration(seconds: 2),
      );
      Logger().e('Error: ${response.errorMessage}');
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}
