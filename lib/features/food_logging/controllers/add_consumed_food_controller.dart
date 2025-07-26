import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/food_analysis_summary_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_logging_controller.dart';
import 'package:barbell/features/food_logging/view/food_logging_screen.dart';
import 'package:barbell/features/food_logging/widgets/nutrition_success_dialog.dart';
import 'package:logger/logger.dart';

class AddConsumedFoodController extends GetxController {
  String get consumedAs =>
      Get.find<FoodLoggingController>().consumedAs.toLowerCase();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  //? ---------------- Add consumed food ----------------
  Future<bool> addConsumedFoodOnClickAdd(String foodId) async {
    // try {
    // EasyLoading.show(status: 'Adding...');
    _isLoading = true;
    _errorMessage = '';
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().multipart(
      url: Urls.addConsumedFood(consumedAs: consumedAs, foodId: foodId),
      type: MultipartRequestType.POST,
    );

    if (response.isSuccess) {
      EasyLoading.showSuccess('Food added successfully');
      Get.offAll(() => const FoodLoggingScreen());
      await Get.find<FoodAnalysisSummaryController>()
          .fetchFoodAnalysisSummary();
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to add food';
      EasyLoading.showError('Failed to add food');
      Logger().e('Error: ${response.errorMessage}');
      isSuccess = false;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }

  //? ---------------- Add consumed food by taking photo ----------------
  Future<bool> addConsumedFoodByTakingPhoto({required XFile image}) async {
    bool isSuccess = false;
    _isLoading = true;
    EasyLoading.show(status: 'Analyzing food image...');
    update();
    try {
      final response = await Get.find<NetworkCaller>().multipart(
        url: Urls.addConsumedFood(consumedAs: consumedAs),
        type: MultipartRequestType.POST,
        file: image,
      );

      if (response.isSuccess) {
        // Check if calories is 0 (food not properly detected)
        final nutritionData =
            response.responseData['data']['nutritionPerServing'];
        final calories = nutritionData?['calories'] ?? 0;

        if (calories == 0) {
          // Show error dialog with retry options
          Get.dialog(
            AlertDialog(
              backgroundColor: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Food Not Detected',
                    style: TextStyle(
                      color: AppColors.textTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'We couldn\'t analyze the food properly from your image. Please try:\n\n• Taking a clearer photo\n• Better lighting\n• Closer view of the food\n• Less background clutter',
                style: TextStyle(
                  color: AppColors.textDescription,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
          EasyLoading.dismiss();
          isSuccess = false;
          update();
          return isSuccess;
        }

        EasyLoading.showSuccess('Food analyzed successfully');
        await Get.find<FoodAnalysisSummaryController>()
            .fetchFoodAnalysisSummary();
        // Show beautiful nutrition dialog
        await Get.dialog(
          NutritionSuccessDialog(
            nutritionData: response.responseData['data'],
            consumedAs:
                response.responseData['data']['consumedAs'] ?? consumedAs,
            servings: response.responseData['data']['servings'] ?? 1,
          ),
          barrierDismissible: false,
        );

        // Navigate to food logging screen after dialog closes
        Get.offAll(() => const FoodLoggingScreen());
        isSuccess = true;
        update();
        return isSuccess;
      } else {
        EasyLoading.showError('Failed to analyze food');
        return isSuccess;
      }
    } catch (e) {
      _errorMessage = 'Error uploading image';
      EasyLoading.showError('Something went wrong');
      Logger().e('Error: $e');
      return isSuccess;
    } finally {
      _isLoading = false;
      EasyLoading.dismiss();
      update();
    }
  }

  //? ---------------- Add consumed food by scanning barcode/QR ----------------
  Future<bool> addConsumedFoodByScan({
    required Map<String, dynamic> nutritionPerServing,
    int servings = 1,
  }) async {
    try {
      EasyLoading.show(status: 'Adding...');
      _isLoading = true;
      _errorMessage = '';
      update();

      final Map<String, dynamic> requestBody = {
        'nutritionPerServing': nutritionPerServing,
        'servings': servings,
        'consumedAs': consumedAs,
      };

      final response = await Get.find<NetworkCaller>().multipart(
        url: Urls.addConsumedFood(consumedAs: consumedAs),
        type: MultipartRequestType.POST,
        fieldsData: requestBody,
      );

      if (response.isSuccess) {
        await Get.find<FoodAnalysisSummaryController>()
            .fetchFoodAnalysisSummary();
        EasyLoading.showSuccess('Food added successfully');
        // Optionally navigate or refresh
        Get.offAll(() => const FoodLoggingScreen());
        return true;
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to add food';
        EasyLoading.showError('Failed to add food');
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error adding food: ${e.toString()}';
      EasyLoading.showError('Something went wrong');
      Logger().e('Error: $e');
      return false;
    } finally {
      _isLoading = false;
      EasyLoading.dismiss();
      update();
    }
  }
}
