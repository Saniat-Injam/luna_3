import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/barbell_llm/view/workout_plan_screen.dart';
import 'package:barbell/features/barbell_llm/models/saved_workout_plan_model.dart';

class BarbellLLMController extends GetxController {
  // Text Controllers
  final fitnessGoalController = TextEditingController();
  final experienceLevelController = TextEditingController();
  final equipmentController = TextEditingController();
  final messageController = TextEditingController();
  final feedbackController = TextEditingController();

  // NetworkCaller instance for API calls
  final NetworkCaller _networkCaller = NetworkCaller();

  // Observable States
  final isLoading = false.obs;
  final selectedTab = 'Ask'.obs;
  final chatMessages = <Map<String, dynamic>>[].obs;
  final messageFeedback = <int, Map<String, dynamic>>{}.obs;
  final selectedDaysPerWeek = 4.obs;
  final selectedExperienceLevel = 'intermediate'.obs;
  final workoutPlanResponse = Rxn<WorkoutPlanResponse>();
  final savedWorkoutPlan = Rxn<SavedWorkoutPlanData>();
  final isLoadingSavedPlan = false.obs;

  // Days per week options
  final List<int> daysPerWeekOptions = [3, 4, 5, 6, 7];

  // Experience level options
  final List<String> experienceLevelOptions = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  // @override
  // void onClose() {
  //   fitnessGoalController.dispose();
  //   experienceLevelController.dispose();
  //   equipmentController.dispose();
  //   messageController.dispose();

  //   super.onClose();
  // }

  // Update days per week selection
  void updateDaysPerWeek(int days) {
    selectedDaysPerWeek.value = days;
  }

  // Update experience level selection
  void updateExperienceLevel(String level) {
    selectedExperienceLevel.value = level;
  }

  //----------------------- Generated Workout Plan API ------------------------------
  Future<void> generatePlan() async {
    try {
      EasyLoading.show(status: 'Generating workout plan...');

      final requestBody = {
        "goal": fitnessGoalController.text.trim(),
        "days_per_week": selectedDaysPerWeek.value,
        "available_equipment": equipmentController.text.trim(),
        "fitness_level": selectedExperienceLevel.value.toLowerCase(),
      };

      final response = await _networkCaller.postRequest(
        url: Urls.createExerciseRoutine,
        body: requestBody,
      );

      if (response.isSuccess) {
        workoutPlanResponse.value = WorkoutPlanResponse.fromJson(
          response.responseData,
        );

        update();

        EasyLoading.dismiss();
        EasyLoading.showSuccess('Workout plan generated successfully!');

        Get.to(() => const WorkoutPlanScreen());
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to generate workout plan');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong: ${e.toString()}');
    }
  }
  //---------------------------- END Generated Workout Plan API -----------------------

  //----------------------------- Save Workout Plan API -------------------------------
  Future<void> saveWorkoutPlan() async {
    if (workoutPlanResponse.value?.data == null) {
      EasyLoading.showError('No workout plan to save');
      return;
    }

    try {
      EasyLoading.show(status: 'Saving workout plan...');

      final requestBody = {"data": workoutPlanResponse.value!.data!.toJson()};

      final response = await _networkCaller.postRequest(
        url: Urls.saveWorkoutPlan,
        body: requestBody,
      );

      if (response.isSuccess) {
        update();

        EasyLoading.dismiss();
        EasyLoading.showSuccess('Workout plan saved successfully!');
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to save workout plan');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong: ${e.toString()}');
    }
  }
  //---------------------------- END Save Workout Plan API ----------------------------

  //----------------------- Update Workout Plan API -----------------------------------
  Future<void> updateWorkoutPlan(String feedback) async {
    try {
      EasyLoading.show(status: 'Updating workout plan...');

      final requestBody = {"feedBack": feedback};

      final response = await _networkCaller.postRequest(
        url: Urls.updateExerciseRoutine,
        body: requestBody,
      );

      if (response.isSuccess) {
        try {
          final updatedResponse = UpdateWorkoutPlanResponse.fromJson(
            response.responseData,
          );

          // Update the stored workout plan with new data
          if (updatedResponse.data?.plan != null &&
              updatedResponse.data!.plan.isNotEmpty) {
            workoutPlanResponse.value = WorkoutPlanResponse(
              success: updatedResponse.success,
              message: updatedResponse.message,
              data: WorkoutPlanData(
                workoutPlan: WorkoutPlan(plan: updatedResponse.data!.plan),
              ),
            );

            // Update GetBuilder widgets
            update();

            // Show success and just update the current screen
            EasyLoading.dismiss();
            EasyLoading.showSuccess('Workout plan updated successfully!');
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError('No workout plan data received');
          }
        } catch (parseError) {
          EasyLoading.dismiss();
          EasyLoading.showError('Error parsing response');
          Logger().e('Error parsing response: ${parseError.toString()}');
        }
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to update workout plan');
        Logger().e('Failed to update workout plan: ${response.errorMessage}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      Logger().e('Error updating workout plan: ${e.toString()}');
    }
  }
  //----------------------- END Update Workout Plan API -----------------------------

  //----------------------- Load Saved Workout Plan API -----------------------
  Future<void> loadSavedWorkoutPlan() async {
  
      EasyLoading.show(status: 'Loading workout plan...');

      final response = await _networkCaller.getRequest(
        url: Urls.getWorkoutRoutine,
      );

      if (response.isSuccess && response.responseData != null) {
        final savedPlanResponse = SavedWorkoutPlanResponse.fromJson(
          response.responseData!,
        );

        if (savedPlanResponse.success) {
          savedWorkoutPlan.value = savedPlanResponse.data;
          Logger().i('✅ Saved workout plan loaded successfully');
        } else {
          savedWorkoutPlan.value = null;
          Logger().w('⚠️ No saved workout plan found');
        }
      } else {
        savedWorkoutPlan.value = null;
        
      }
      EasyLoading.dismiss();
    
  }
  //----------------------- END Load Saved Workout Plan API -----------------------

  /// Convert saved workout plan to display format
  WorkoutPlan? get displayWorkoutPlan {
    if (workoutPlanResponse.value?.data?.workoutPlan != null) {
      // Return generated workout plan
      return workoutPlanResponse.value!.data!.workoutPlan;
    } else if (savedWorkoutPlan.value != null) {
      // Convert saved workout plan to display format
      return WorkoutPlan(
        plan:
            savedWorkoutPlan.value!.workoutPlan.plan
                .map(
                  (day) => WorkoutDay(
                    day: day.day,
                    focus: day.focus,
                    exercises:
                        day.exercises
                            .map(
                              (exercise) => Exercise(
                                name: exercise.name,
                                sets: exercise.sets,
                                reps: exercise.reps,
                                restPeriodMinutes: exercise.restPeriodMinutes,
                              ),
                            )
                            .toList(),
                  ),
                )
                .toList(),
      );
    }
    return null;
  }

  /// Check if current plan is from saved data (not newly generated)
  bool get isDisplayingSavedPlan =>
      workoutPlanResponse.value == null && savedWorkoutPlan.value != null;
}
