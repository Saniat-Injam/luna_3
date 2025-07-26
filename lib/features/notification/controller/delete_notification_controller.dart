import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';

class DeleteNotificationController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<bool> deleteNotification(String notificationId) async {
    isLoading = true;
    bool isDeleted = false;
    update();

    final response = await Get.find<NetworkCaller>().deleteRequest(
      Urls.deleteUserNotification(notificationId),
    );

    if (response.isSuccess) {
      isDeleted = true;
    } else {
      isDeleted = false;
    }

    isLoading = false;
    update();
    return isDeleted;
  }

  Future<bool> deleteNotificationByAdmin(String notificationId) async {
    isLoading = true;
    bool isDeleted = false;
    update();

    // Using the same NetworkCaller instance to make the request
    final response = await Get.find<NetworkCaller>().deleteRequest(
      Urls.deleteAnyNotification(notificationId),
    );

    if (response.isSuccess) {
      isDeleted = true;
    } else {
      isDeleted = false;
    }

    isLoading = false;
    update();
    return isDeleted;
  }
}
