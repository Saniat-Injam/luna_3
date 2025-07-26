import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/workout/controller/exercise_analysis_controller.dart';
import 'package:barbell/features/workout/controller/get_workout_by_id_controller.dart';
import 'package:barbell/features/workout/model/set_model.dart';
import 'package:barbell/features/workout/model/workout_perform_model.dart';
import 'package:barbell/features/workout/widgets/rest_timer_bottomsheet.dart';
import 'package:logger/logger.dart';

class WorkoutPerformController extends GetxController {
  // static WorkoutController get to => Get.find();

  var setList = <SetModel>[].obs;

  var sets = <Map<String, dynamic>>[].obs;
  // var restTime = 60.obs;
  var activeStartIndices = <int>{}.obs;
  var isTimerRunning = false.obs;
  var workoutCompleted = false.obs;
  var showSuccessAfterTimer = false.obs;

  void addSet() {
    sets.add({
      'SET': (sets.length + 1).toString(),
      'lbs': '0',
      'REPS': '0',
      'STARTED': false,
    });

    setList.add(
      SetModel(
        set: (setList.length + 1).toString(),
        kg: TextEditingController(text: '0'),
        reps: TextEditingController(text: '0'),
      ),
    );
  }

  void updateSetValue(int index, String field, String value) {
    if (index >= 0 && index < sets.length) {
      var set = sets[index];
      set[field] = value;
      sets[index] = Map<String, dynamic>.from(set);
      sets.refresh(); // Use sets.refresh() to ensure Obx reacts to changes in individual map items
    }
  }

  // void toggleStart(int index) {
  //   if (activeStartIndices.contains(index)) {
  //     activeStartIndices.remove(index);
  //   } else {
  //     activeStartIndices.add(index);
  //   }
  //   isTimerRunning.value = activeStartIndices.isNotEmpty;
  // }

  bool isStarted(int index) => activeStartIndices.contains(index);

  // ------------------ Start Performing Workout ------------------
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PerformExerciseModel? performedExercises;

  Future<bool> performWorkout(int index) async {
    if (activeStartIndices.contains(index)) {
      EasyLoading.showError(
        "This set is already performed, please select another set.",
      );
      return false;
    }

    activeStartIndices.add(index);

    isTimerRunning.value = activeStartIndices.isNotEmpty;

    _isLoading = true;
    bool isSuccess = false;
    update();

    Map<String, dynamic> workoutData = {
      "exercise_id": Get.find<GetWorkoutByIdController>().workout?.id,
      "set": setList[index].set,
      "reps": setList[index].reps.text,
      "resetTime": Get.find<RestTimerController>().selectedTime.value,
      "weightLifted": setList[index].kg?.text ?? "0",
      "isCompleted": false,
    };

    final response = await Get.find<NetworkCaller>().postRequest(
      url: Urls.performExercise,
      body: workoutData,
    );

    if (response.isSuccess) {
      performedExercises = PerformExerciseModel.fromJson(
        response.responseData['data'],
      );

      // Add the performed exercise to the list
      isSuccess = await markExerciseAsCompleated(
        performedExercises?.id ?? '',
        index,
      );

      if (isSuccess) {
        // If successful, set flag to show success message after timer ends
        showSuccessAfterTimer.value = true;
      } else {
        // If marking as completed fails, stop the timer
        isTimerRunning.value = false;
        activeStartIndices.remove(index);
      }
    } else {
      // Handle error - stop the timer and show error
      EasyLoading.showError(
        "An error occurred during workout",
      );
      Logger().e('Failed to perform workout: ${response.errorMessage}');
      activeStartIndices.remove(index);
      isTimerRunning.value = false;
      isSuccess = false;
    }

    _isLoading = false;
    update();
    return isSuccess;
  }

  Future<bool> markExerciseAsCompleated(
    String performedExerciseId,
    int index,
  ) async {
    _isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().patchRequest(
      url: Urls.markExerciseAsCompleated(performedExerciseId),
      body: {},
    );

    if (response.isSuccess) {
      // Don't show success message here, it will be shown after timer ends
      isSuccess = true;
    } else {
      activeStartIndices.remove(index);
      isTimerRunning.value = false;
      EasyLoading.showError(
        "Failed to mark exercise as completed",
      );
      Logger().e('Failed to mark exercise as completed: ${response.errorMessage}');
    }

    _isLoading = false;
    update();
    return isSuccess;
  }

  void onTimerCompleted() {
    isTimerRunning.value = false;

    if (showSuccessAfterTimer.value) {
      workoutCompleted.value = true;
      showSuccessAfterTimer.value = false;

      // Refresh exercise analysis data after successful workout completion
      _refreshExerciseAnalysis();

      EasyLoading.showSuccess(
        "Exercise completed successfully! Great job!",
      );
    }
  }

  /// Refresh exercise analysis data after successful workout
  Future<void> _refreshExerciseAnalysis() async {
    try {
      final exerciseAnalysisController = Get.find<ExerciseAnalysisController>();
      final workoutController = Get.find<GetWorkoutByIdController>();

      final workoutId = workoutController.workout?.id;
      if (workoutId != null && workoutId.isNotEmpty) {
        await exerciseAnalysisController.fetchExerciseAnalysis(
          exerciseId: workoutId,
          timeSpan:
              '7_days', // Default to weekly data, could be made configurable
        );
      }
    } catch (e) {
      // Handle error silently as this is a background refresh
      AppLoggerHelper.error('Error refreshing exercise analysis', e);
    }
  }
}
