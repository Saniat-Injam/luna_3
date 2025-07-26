import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/workout%20setup/model/workout_setup_model.dart';

class WorkoutSetupController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  RxBool isUpdate = false.obs;

  TextEditingController feetController = TextEditingController();
  TextEditingController cmController = TextEditingController();

  RxString selectedFitnessGoal = ''.obs;
  RxString selectedGender = ''.obs;
  RxDouble weightInKg = 66.0.obs; // Weight is always stored internally in KG
  RxInt age = 18.obs; // in years
  // height value is stored in cmController.text
  RxString selectedDiet = ''.obs;
  RxString exercisePreference = ''.obs;
  RxDouble calories = 1550.0.obs; // Observed variable for calories

  // Macro goals (grams per day)
  RxDouble proteinGoal = 120.0.obs;
  RxDouble carbsGoal = 250.0.obs;
  RxDouble fatsGoal = 70.0.obs;
  RxDouble fiberGoal = 30.0.obs;

  RxString selectedSleepQuality = ''.obs;

  // -------- Workout Setup 1 -------- //
  Map<String, String> fitnessGoals = {
    'lose_weight': "I wanna lose weight",
    'gain_weight': "I want to gain strength",
    'ai_coach': "I wanna try AI Coach",
    'gain_insurance': "I wanna gain endurance",
    'just_tryout_app': "Just trying out the app!",
  };

  void selectFitnessGoal(String goal) {
    selectedFitnessGoal.value = goal;
  }

  bool isSelectedFitnessGoal(String value) {
    return selectedFitnessGoal.value == value;
  }

  // -------- Workout Setup 2 -------- //
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // -------- Workout Setup 3 -------- //
  RxBool isKgSelected = true.obs; // Unit toggle: true = KG, false = LB

  void toggleUnit() {
    isKgSelected.value = !isKgSelected.value;
  }

  String get currentUnit =>
      isKgSelected.value
          ? AppText.appsetup3Screenkg
          : AppText.appsetup3Screenlb;

  double get weightInLbs => weightInKg.value * 2.20462; // weight

  double get displayedWeight =>
      isKgSelected.value ? weightInKg.value : weightInLbs;

  void updateWeight(double value) {
    if (isKgSelected.value) {
      if (value >= 30 && value <= 150) {
        weightInKg.value = value;
      }
    } else {
      final kg = value / 2.20462;
      if (kg >= 30 && kg <= 150) {
        weightInKg.value = kg;
      }
    }
  }

  // -------- Workout Setup 5 -------- //

  void updateHeight(double value, {bool isFeet = false}) {
    if (isFeet) {
      cmController.text = (value * 30.48).toInt().toDouble().floor().toString();
    } else {
      feetController.text = (value / 30.48).toStringAsFixed(1);
    }
  }

  // -------- Workout Setup 6 -------- //

  // final selectedDiet = ''.obs;

  void selectDiet(String dietName) {
    selectedDiet.value = convertToUnderscoreLowercase(dietName);
    // print(selectedDiet.value);
  }

  bool isSelectedDiet(String dietName) => selectedDiet.value == dietName;

  bool get isAnySelected => selectedDiet.value.isNotEmpty;

  // -------- Workout Setup 7 -------- //
  List<Map<String, String>> exercisePreferenceData = [
    {'title': 'Jogging', 'icon': IconPath.jogging},
    {'title': 'Walking', 'icon': IconPath.walking},
    {'title': 'Hiking', 'icon': IconPath.hiking},
    {'title': 'Skating', 'icon': IconPath.skaing},
    {'title': 'Biking', 'icon': IconPath.biking},
    {'title': 'Weight Lift', 'icon': IconPath.lifting},
    {'title': 'Cardio', 'icon': IconPath.cardio},
    {'title': 'Yoga', 'icon': IconPath.yoga},
    {'title': 'Other', 'icon': IconPath.other},
  ];

  List<Widget> rows = [];

  var exercisePreferenceSelectedIndex = RxInt(-1); // -1 means no card selected

  void selectCard(int index) {
    exercisePreferenceSelectedIndex.value = index;
    exercisePreference.value = toCamelCase(
      exercisePreferenceData[index]['title'] ?? '',
    );
  }

  // -------- Workout Setup 8 -------- //

  final double minCalories = 1000; // Minimum calorie value
  final double maxCalories = 3000; // Maximum calorie value

  // Macro min/max values
  final double minProtein = 0;
  final double maxProtein = 300;
  final double minCarbs = 0;
  final double maxCarbs = 500;
  final double minFats = 0;
  final double maxFats = 150;
  final double minFiber = 0;
  final double maxFiber = 100;

  void updateCalories(double newValue) {
    calories.value = newValue;
  }

  // Update methods for macros
  void updateProtein(double value) {
    proteinGoal.value = value;
    _calculateCalories();
  }

  void updateCarbs(double value) {
    carbsGoal.value = value;
    _calculateCalories();
  }

  void updateFats(double value) {
    fatsGoal.value = value;
    _calculateCalories();
  }

  void updateFiber(double value) {
    fiberGoal.value = value;
    _calculateCalories();
  }

  void _calculateCalories() {
    final proteinCalories = proteinGoal.value * 4;
    final carbsCalories = carbsGoal.value * 4;
    final fatsCalories = fatsGoal.value * 9;
    final fiberCalories = fiberGoal.value * 2; // Fiber has calories
    calories.value = proteinCalories + carbsCalories + fatsCalories + fiberCalories;
  }

  // -------- Workout Setup 9 -------- //
  void selectSleepQuality(String sleepQuality) {
    selectedSleepQuality.value = sleepQuality;
    // print(selectedSleepQuality.value);
  }

  bool isSelectedSleepQuality(String buttonKey) {
    return selectedSleepQuality.value == buttonKey;
  }

  String toCamelCase(String input) {
    if (input.isEmpty) return input;

    // Split into words, handle various separators
    final words = input.split(RegExp(r'[_\s-]'));

    // First word in lowercase
    final firstWord = words[0].toLowerCase();

    // Capitalize remaining words
    final restWords = words.skip(1).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });

    return firstWord + restWords.join();
  }

  String convertToUnderscoreLowercase(String input) {
    // Handle empty string
    if (input.isEmpty) return input;

    // Replace hyphens and spaces with underscores
    String withUnderscores = input.replaceAll(RegExp(r'[-\s]'), '_');

    // Convert to lowercase
    return withUnderscores.toLowerCase();
  }

  void updateWorkoutSetup() {
    if (profileController.profileModel?.workoutSetup != null) {
      WorkoutSetupModel workoutSetupModel =
          profileController.profileModel!.workoutSetup!;

      selectedFitnessGoal.value = workoutSetupModel.goal;
      selectedGender.value = workoutSetupModel.gender;
      weightInKg.value = workoutSetupModel.weight.toDouble();
      age.value = workoutSetupModel.age;
      feetController.text = (workoutSetupModel.height / 30.48).toStringAsFixed(
        1,
      );
      cmController.text = workoutSetupModel.height.toString();
      selectedDiet.value = workoutSetupModel.dietaryPreference;
      exercisePreference.value = toCamelCase(
        workoutSetupModel.exercisePreference,
      );
      exercisePreferenceSelectedIndex.value = exercisePreferenceData.indexWhere(
        (element) =>
            element['title']?.toLowerCase() ==
            exercisePreference.value.toLowerCase(),
      );
      calories.value = workoutSetupModel.calorieGoal.toDouble();
      // If backend returns these values
      proteinGoal.value = workoutSetupModel.proteinGoal.toDouble();
      carbsGoal.value = workoutSetupModel.carbsGoal.toDouble();
      fatsGoal.value = workoutSetupModel.fatsGoal.toDouble();
      fiberGoal.value = workoutSetupModel.fiberGoal.toDouble();
      selectedSleepQuality.value = workoutSetupModel.sleepQuality.quality;
      isUpdate.value = true;
    } else {
      isUpdate.value = false;
    }
    update();
  }
}
