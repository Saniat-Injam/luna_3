import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';

class DeleteFoodController extends GetxController {
  final getAllFoodsController = Get.find<GetAllFoodsController>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> deleteFoodItem(String foodId) async {
    EasyLoading.show(
      status: 'Deleting food item...',
      maskType: EasyLoadingMaskType.black,
    );
    _isLoading = true;
    bool isDeleted = false;
    update();

    final response = await Get.find<NetworkCaller>().deleteRequest(
      Urls.deleteFoodItem(foodId),
    );

    if (response.isSuccess) {
      EasyLoading.showSuccess('Food item deleted successfully');
      _isLoading = false;
      isDeleted = true;
      getAllFoodsController.removeFoodItem(foodId);
      update();
    } else {
      EasyLoading.showError('Failed to delete food item');
      await getAllFoodsController.getAllFoods();
      _isLoading = false;
      update();
    }

    EasyLoading.dismiss();
    return isDeleted;
  }
}
