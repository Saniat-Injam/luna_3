import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/notification/model/notification_model.dart';

class GetNotificationById extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;

  /// Toggles the loading state
  void toggleLoading() {
    _isLoading = !_isLoading;
    update(); // Notify listeners about the change
  }

  /// Get all notifications
  Future<bool> getNotification(String notificationId) async {
    _isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.viewSpecificNotification(notificationId),
    );

    if (response.isSuccess) {
      _notificationModel = NotificationModel.fromJson(
        response.responseData['data'],
      );
      isSuccess = true;
    } else {
      // Handle error case
      _notificationModel = null; // Clear the model on error
      EasyLoading.showError(
        'Failed to fetch notification',
        duration: const Duration(seconds: 2),
      );
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}
