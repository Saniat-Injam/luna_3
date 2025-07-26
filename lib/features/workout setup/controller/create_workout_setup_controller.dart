import 'package:barbell/core/services/firebase_notification_service.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/main_layout/view/main_layout.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class CreateWorkoutSetupController extends GetxController {
  final WorkoutSetupController workoutSetupController = Get.find();

  final Map<String, dynamic> workoutSetupData = {};

  Future<void> createOrUpdateWorkoutSetup({bool isUpdate = false}) async {
    EasyLoading.show(status: 'Loading...');
    Map<String, dynamic> requestBody = {
      "goal": workoutSetupController.selectedFitnessGoal.value,
      "gender": workoutSetupController.selectedGender.value,
      "weight": workoutSetupController.weightInKg.value,
      "age": workoutSetupController.age.value,
      "height": workoutSetupController.cmController.text,
      "dietaryPreference": workoutSetupController.selectedDiet.value,
      "exercisePreference": workoutSetupController.exercisePreference.value,
      "calorieGoal": workoutSetupController.calories.value,
      "proteinGoal": workoutSetupController.proteinGoal.value,
      "carbsGoal": workoutSetupController.carbsGoal.value,
      "fatsGoal": workoutSetupController.fatsGoal.value,
      "fiberGoal": workoutSetupController.fiberGoal.value,
      "sleepQuality": workoutSetupController.selectedSleepQuality.value,
    };

    final response = await Get.find<NetworkCaller>().postRequest(
      url: isUpdate ? Urls.updateWorkoutSetup : Urls.workoutSetup,
      body: requestBody,
    );

    if (response.isSuccess) {
      EasyLoading.showSuccess('${response.responseData['message']}');
      workoutSetupData.addAll(response.responseData);
      await Get.find<ProfileController>().getProfileData();
      Get.offAll(() => MainLayout());
    } else {
      EasyLoading.showError('Failed to create workout setup');
      AppLoggerHelper.error(
        'Failed to create workout setup: ${response.errorMessage}',
      );
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }
}
