import 'package:barbell/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/home/models/food_analysis_progress.dart';
import 'package:barbell/features/home/models/food_analysis_progress_response.dart';
import 'package:barbell/features/home/models/nutrition_macro.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> progressAnimation;

  // API related observables
  final Rx<FoodAnalysisProgressResponse?> foodAnalysisProgress =
      Rx<FoodAnalysisProgressResponse?>(null);
  final RxBool isLoadingFoodProgress = false.obs;
  final RxString errorMessage = ''.obs;

  static const bool useDemoData = false;

  ///----------------------Get food analysis progress from API------------------------///
  /// Updates nutrition data displayed in the home screen
  Future<void> getFoodAnalysisProgress() async {
    try {
      isLoadingFoodProgress.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkCaller>().getRequest(
        url: Urls.getFoodAnalysisProgress(1),
      );

      if (response.isSuccess && response.responseData != null) {
        foodAnalysisProgress.value = FoodAnalysisProgressResponse.fromJson(
          response.responseData!,
        );
      } else {
        errorMessage.value = 'Failed to load food progress';
      }
    } catch (e) {
      errorMessage.value = 'Error loading food progress: $e';
    } finally {
      isLoadingFoodProgress.value = false;
    }
  }

  /// Refresh food analysis progress data
  /// Can be called manually to update nutrition data
  Future<void> refreshFoodProgress() async {
    if (useDemoData) {
      // Use demo data for testing
      isLoadingFoodProgress.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      loadDemoData();
      isLoadingFoodProgress.value = false;
    } else {
      // Use real API call
      await getFoodAnalysisProgress();
    }
  }

  /// Get formatted calories text for display
  String get caloriesText {
    if (foodAnalysisProgress.value?.isSuccessful == true) {
      final data = foodAnalysisProgress.value!.data!.calories;
      return '${data.actual.toInt()}/${data.goal.toInt()}';
    }
    return '0/0';
  }

  /// Get formatted protein text for display
  String get proteinText {
    if (foodAnalysisProgress.value?.isSuccessful == true) {
      final data = foodAnalysisProgress.value!.data!.protein;
      return '${data.actual.toInt()}g/${data.goal.toInt()}g';
    }
    return '0g/0g';
  }

  /// Get formatted carbs text for display
  String get carbsText {
    if (foodAnalysisProgress.value?.isSuccessful == true) {
      final data = foodAnalysisProgress.value!.data!.carbs;
      return '${data.actual.toInt()}g/${data.goal.toInt()}g';
    }
    return '0g/0g';
  }

  /// Get formatted fats text for display
  String get fatsText {
    if (foodAnalysisProgress.value?.isSuccessful == true) {
      final data = foodAnalysisProgress.value!.data!.fats;
      return '${data.actual.toInt()}g/${data.goal.toInt()}g';
    }
    return '0g/0g';
  }

  // Overall loading state for home screen
  final RxBool isLoadingHomeData = false.obs;

  /// Load all home screen data
  /// Coordinates loading of nutrition, habits, and profile data
  Future<void> loadHomeData() async {
    try {
      isLoadingHomeData.value = true;

      if (useDemoData) {
        // Simulate loading delay for realistic experience
        await Future.delayed(const Duration(milliseconds: 800));
        loadDemoData();
      } else {
        // Load real API data
        await getFoodAnalysisProgress();
      }

      // You can add other data loading here:
      // await loadHabits();
      // await loadProfile();
    } catch (e) {
      errorMessage.value = 'Error loading home data: $e';
    } finally {
      isLoadingHomeData.value = false;
    }
  }

  // Load demo data for UI testing and visualization
  void loadDemoData() {
    // Create demo nutrition data with realistic values
    final demoData = FoodAnalysisProgress(
      calories: NutritionMacro(
        goal: 2000.0,
        actual: 1520.0,
        remaining: 480.0,
        progress: 0.76,
      ),
      protein: NutritionMacro(
        goal: 150.0,
        actual: 89.0,
        remaining: 61.0,
        progress: 0.59,
      ),
      carbs: NutritionMacro(
        goal: 250.0,
        actual: 180.0,
        remaining: 70.0,
        progress: 0.72,
      ),
      fats: NutritionMacro(
        goal: 65.0,
        actual: 45.0,
        remaining: 20.0,
        progress: 0.69,
      ),
      fiber: NutritionMacro(
        goal: 25.0,
        actual: 18.0,
        remaining: 7.0,
        progress: 0.72,
      ),
    );

    // Create demo response wrapper
    final demoResponse = FoodAnalysisProgressResponse(
      success: true,
      message: 'Demo data loaded successfully',
      data: demoData,
    );

    // Set the demo data
    foodAnalysisProgress.value = demoResponse;
    errorMessage.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    progressAnimation = CurvedAnimation(
      parent: progressController,
      curve: Curves.easeInOut,
    );

    // Load all home screen data
    if (StorageService.accessToken != null &&
        StorageService.accessToken!.isNotEmpty) {
      loadHomeData();
    }

    // Start the animation when the screen loads
    progressController.forward();
  }

  @override
  void onClose() {
    progressController.dispose();
    super.onClose();
  }
}
