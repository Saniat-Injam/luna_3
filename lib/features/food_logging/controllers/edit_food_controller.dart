import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/food_logging/controllers/add_food_manually_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/models/nutrition_perserving_model.dart';
import 'package:logger/logger.dart';

class EditFoodController extends GetxController {
  final AddFoodManuallyController foodCtrl =
      Get.find<AddFoodManuallyController>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> editFoodItem(String foodId) async {
    _isLoading = true;
    EasyLoading.show(status: 'Editing food item...');
    bool isSuccess = false;
    update();

    final FoodCaloriesModel updatedItem = FoodCaloriesModel(
      name: foodCtrl.nameController.text.trim(),
      servings: int.tryParse(foodCtrl.servingsController.text),
      preparationTime: int.tryParse(foodCtrl.prepTimeController.text.trim()),
      nutritionPerServing: NutritionPerServingModel(
        calories: double.tryParse(foodCtrl.energyController.text.trim()),
        carbs: double.tryParse(foodCtrl.carbsController.text.trim()),
        protein: double.tryParse(foodCtrl.proteinController.text.trim()),
        fats: double.tryParse(foodCtrl.fatController.text.trim()),
        fiber: double.tryParse(foodCtrl.fiberController.text.trim()),
      ),
      ingredients:
          foodCtrl.ingredientsController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
      instructions: foodCtrl.instructionsController.text,
    );

    final response = await Get.find<NetworkCaller>().multipart(
      url: Urls.editFood(foodId),
      type: MultipartRequestType.PUT,
      fieldsData: updatedItem.toJson(),
      file:
          foodCtrl.imageController.imagePath != null
              ? XFile(foodCtrl.imageController.imagePath!)
              : null,
    );

    if (response.isSuccess) {
      isSuccess = true;
      EasyLoading.showSuccess('Food item edited successfully');
      await Get.find<GetAllFoodsController>().getAllFoods();
      Get.back();
    } else {
      EasyLoading.showError(
        response.errorMessage ?? 'Failed to edit food item',
      );
      Logger().e('Edit Food Error: ${response.errorMessage}');
      isSuccess = false;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }
}
