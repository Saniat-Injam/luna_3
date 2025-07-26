import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/models/nutrition_perserving_model.dart';
import 'package:logger/logger.dart';

class AddFoodManuallyController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();
  // ------------------- Nutrients controllers -------------------
  final TextEditingController energyController = TextEditingController(
    text: '0.0',
  );
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController fiberController = TextEditingController();

  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final imageController = Get.find<FoodImageController>();

  void calculateEnergy() {
    double energy = 0.0;
    energy += (double.tryParse(carbsController.text) ?? 0.0) * 4;
    energy += (double.tryParse(proteinController.text) ?? 0.0) * 4;
    energy += (double.tryParse(fatController.text) ?? 0.0) * 9;
    energy += (double.tryParse(fiberController.text) ?? 0.0) * 2;
    energyController.text = energy.toStringAsFixed(1);
    update();
  }

  //! ---------------- Create food item ----------------
  bool isCreating = false;
  String errorMessage = '';

  Future<bool> createPersonalFoodItem({
    bool? isForAllUsers,
    bool? isEdit,
  }) async {
    if (imageController.imagePath == null) {
      errorMessage = 'Please select an image';
      EasyLoading.showError(errorMessage);
      update();
      return false;
    }
    EasyLoading.show(status: 'Creating...');
    isCreating = true;
    bool isSuccess = false;
    update();

    final FoodCaloriesModel data = FoodCaloriesModel(
      name: nameController.text,
      servings: int.parse(servingsController.text),
      nutritionPerServing: NutritionPerServingModel(
        calories: double.parse(energyController.text),
        protein: double.parse(proteinController.text),
        carbs: double.parse(carbsController.text),
        fats: double.parse(fatController.text),
        fiber: double.parse(fiberController.text),
      ),
      ingredients:
          ingredientsController.text
              .split(', ')
              .map((ingredient) => ingredient.trim())
              .toList(),
      instructions: instructionsController.text,
      preparationTime: int.parse(prepTimeController.text),
    );

    final response = await Get.find<NetworkCaller>().multipartRequest(
      url:
          isForAllUsers == true
              ? Urls.addFoodManually
              : Urls.addPersonalizeFoodManually,
      image: XFile(imageController.imagePath!),
      jsonData: data.toJson(),
    );

    if (response.isSuccess) {
      isSuccess = true;
      EasyLoading.showSuccess('Food item created successfully');
      await Get.find<GetAllFoodsController>().getAllFoods();
      Get.back();
    } else {
      EasyLoading.showError('Something went wrong');
      Logger().e('Error: ${response.errorMessage}');
    }

    isCreating = false;
    update();
    EasyLoading.dismiss();
    return isSuccess;
  }

  //! ---------------- On clicked update button ----------------
  void updateFoodItem(FoodCaloriesModel item) async {
    nameController.text = item.name ?? '';
    servingsController.text = item.servings?.toString() ?? '';
    prepTimeController.text = item.preparationTime?.toString() ?? '';
    energyController.text =
        item.nutritionPerServing?.calories?.toString() ?? '0.0';
    carbsController.text = item.nutritionPerServing?.carbs?.toString() ?? '0.0';
    proteinController.text =
        item.nutritionPerServing?.protein?.toString() ?? '0.0';
    fatController.text = item.nutritionPerServing?.fats?.toString() ?? '0.0';
    fiberController.text = item.nutritionPerServing?.fiber?.toString() ?? '0.0';
    ingredientsController.text = item.ingredients?.join(', ') ?? '';
    instructionsController.text = item.instructions ?? '';
    update();
  }

  //! ---------------- Dispose controllers ----------------
  @override
  void onClose() {
    nameController.dispose();
    servingsController.dispose();
    prepTimeController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    energyController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();
    fiberController.dispose();
    super.onClose();
  }
}
