import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodLoggingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ------------------- Consumed As -------------------
  String consumedAs = "";
  // Animation controller for the progress circle
  late AnimationController progressAnimation;
  late Animation<double> progressBarAnimation;

  // Maximum nutrition values
  final int maxCalories = 2411;
  final double maxFats = 250.0;
  final double maxProteins = 10.0;
  final double maxCarbs = 38.0;

  // Nutrition values (example values - replace with actual logic)
  final RxInt calories = 0.obs;
  final RxDouble fats = 0.0.obs;
  final RxDouble proteins = 0.0.obs;
  final RxDouble carbs = 0.0.obs;

  // Calculate carb percentage for the progress circle
  double get carbPercentage =>
      (carbs.value / maxCarbs * 100).clamp(0, 100).toDouble();

  // Calculate progress ratios for progress bars
  double get caloriesProgress => (calories.value / maxCalories).clamp(0.0, 1.0);
  double get fatsProgress => (fats.value / maxFats).clamp(0.0, 1.0);
  double get proteinsProgress => (proteins.value / maxProteins).clamp(0.0, 1.0);
  double get carbsProgress => (carbs.value / maxCarbs).clamp(0.0, 1.0);

  @override
  void onInit() {
    super.onInit();
    // Initialize with some example values
    _initializeValues();

    // Set up animation controller
    progressAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    progressBarAnimation = CurvedAnimation(
      parent: progressAnimation,
      curve: Curves.easeInOut,
    );

    // Start the animation
    progressAnimation.forward();
  }

  @override
  void onClose() {
    progressAnimation.dispose();
    super.onClose();
  }

  // Example method to update nutrition values
  void updateNutrition({
    int? calories,
    double? fats,
    double? proteins,
    double? carbs,
  }) {
    if (calories != null) this.calories.value = calories;
    if (fats != null) this.fats.value = fats;
    if (proteins != null) this.proteins.value = proteins;
    if (carbs != null) this.carbs.value = carbs;

    // Update animation when values change
    progressAnimation.reset();
    progressAnimation.forward();
  }

  void _initializeValues() {
    // Initialize with some example values
    calories.value = 800;
    fats.value = 100.0;
    proteins.value = 10.0;
    carbs.value = 32.0;
  }
}
