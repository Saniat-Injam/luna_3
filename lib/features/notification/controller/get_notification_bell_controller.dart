import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/notification/model/notification_bell_model.dart';

class GetNotificationBellController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationBellModel? _notificationBellModel;
  NotificationBellModel? get notificationBellModel => _notificationBellModel;

  /// Toggles the loading state
  void toggleLoading() {
    _isLoading = !_isLoading;
    update(); // Notify listeners about the change
  }

  /// Fetches getNotificationForNotificationBell
  Future<bool> getNotificationBell() async {
    _isLoading = true; // Start loading
    bool isSuccess = false;
    update(); // Notify listeners about the change

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getNotificationForNotificationBell,
    );

    if (response.isSuccess) {
      _notificationBellModel = NotificationBellModel.fromJson(
        response.responseData['data'],
      );
      isSuccess = true;
    } else {
      // Handle error case
      _notificationBellModel = null; // Clear the model on error
      // EasyLoading.showError(
      //   'Failed to fetch notifications',
      //   duration: const Duration(seconds: 2),
      // );
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}
