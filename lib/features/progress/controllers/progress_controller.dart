import 'package:barbell/core/utils/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/features/progress/models/food_analysis_summary_model.dart';
import 'package:barbell/features/progress/services/progress_service.dart';

class ProgressController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController progressAnimation;
  late Animation<double> progressBarAnimation;

  final RxDouble carbPercentage = 10.0.obs;
  final RxInt calories = 780.obs;
  final RxInt fats = 250.obs;
  final RxInt proteins = 39.obs;
  final RxInt carbs = 5.obs;

  // Weekly data for the chart
  final RxList<Map<String, dynamic>> weeklyData =
      <Map<String, dynamic>>[
        {'day': 'SUN', 'value': 0.6},
        {'day': 'MON', 'value': 0.9},
        {'day': 'TUE', 'value': 0.5},
        {'day': 'WED', 'value': 0.3},
        {'day': 'THU', 'value': 0.7},
        {'day': 'FRI', 'value': 0.8},
        {'day': 'SAT', 'value': 0.4},
      ].obs;

  // Food Analysis Summary Data
  final RxBool isLoadingFoodSummary = false.obs;
  final Rx<FoodAnalysisSummaryModel> foodAnalysisSummary =
      FoodAnalysisSummaryModel.empty().obs;
  final RxString errorMessage = ''.obs;

  // Time range selection (7 days, 30 days, 365 days)
  final RxInt selectedTimeRange = 7.obs;
  final RxList<String> selectedFilters =
      <String>['calories', 'protein', 'carbs', 'fats'].obs;

  // Chart and UI state
  final RxString selectedNutrient = 'calories'.obs;
  final RxInt selectedChartType =
      0.obs; // 0: Line Chart, 1: Bar Chart, 2: Pie Chart

  // Network service instance
  final ProgressService _progressService = ProgressService();

  @override
  void onInit() {
    super.onInit();
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

    // Initialize food analysis data
    loadFoodAnalysisSummary();
  }

  @override
  void onClose() {
    progressAnimation.dispose();
    super.onClose();
  }

  void updateProgress(double percentage) {
    carbPercentage.value = percentage;
    progressAnimation.reset();
    progressAnimation.forward();
  }

  /// Load food analysis summary from API
  /// [timeRange] - Number of days to analyze (7, 30, 365)
  /// [filters] - List of nutrients to include in analysis
  Future<void> loadFoodAnalysisSummary({
    int? timeRange,
    List<String>? filters,
    bool isRefresh = false,
  }) async {
    try {
      // Set loading state
      isLoadingFoodSummary.value = true;
      errorMessage.value = '';

      // Use provided parameters or defaults
      final int range = timeRange ?? selectedTimeRange.value;
      final List<String> filterList = filters ?? selectedFilters.toList();

      // Make API call using service
      final summaryModel = await _progressService.getFoodAnalysisSummary(
        timeRange: range,
        filters: filterList,
      );

      // Update the data
      foodAnalysisSummary.value = summaryModel;

      // Update selected time range if successful
      selectedTimeRange.value = range;
      selectedFilters.assignAll(filterList);

      errorMessage.value = '';
    } catch (e) {
      // Handle unexpected errors
      errorMessage.value = 'An unexpected error occurre';
      AppLoggerHelper.error('Failed to load food analysis summary: $e');
      if (!isRefresh) {
        foodAnalysisSummary.value = FoodAnalysisSummaryModel.empty();
      }
    } finally {
      isLoadingFoodSummary.value = false;
    }
  }

  /// Change time range and reload data
  /// [range] - Number of days (7, 30, 365)
  void changeTimeRange(int range) {
    if (selectedTimeRange.value != range) {
      selectedTimeRange.value = range;
      loadFoodAnalysisSummary(timeRange: range);
    }
  }

  /// Toggle nutrient filter and reload data
  /// [nutrient] - Nutrient type to toggle
  void toggleNutrientFilter(String nutrient) {
    if (selectedFilters.contains(nutrient)) {
      selectedFilters.remove(nutrient);
    } else {
      selectedFilters.add(nutrient);
    }

    // Reload data with new filters
    if (selectedFilters.isNotEmpty) {
      loadFoodAnalysisSummary(filters: selectedFilters.toList());
    }
  }

  /// Change selected nutrient for chart display
  /// [nutrient] - Nutrient type to display
  void changeSelectedNutrient(String nutrient) {
    selectedNutrient.value = nutrient;
  }

  /// Change chart type (0: Line, 1: Bar, 2: Pie)
  /// [type] - Chart type index
  void changeChartType(int type) {
    selectedChartType.value = type;
  }

  /// Refresh all progress data including food analysis
  Future<void> refreshAllData() async {
    await Future.wait([
      loadFoodAnalysisSummary(isRefresh: true),
      // Add other data refresh calls here if needed
    ]);
  }

  /// Get chart data for the selected nutrient
  List<Map<String, dynamic>> getChartData() {
    return foodAnalysisSummary.value.getChartData(selectedNutrient.value);
  }

  /// Get meal breakdown data for pie chart
  List<Map<String, dynamic>> getMealBreakdownData() {
    return foodAnalysisSummary.value.getMealBreakdownData(
      selectedNutrient.value,
    );
  }

  /// Get time range display text
  String get timeRangeText {
    switch (selectedTimeRange.value) {
      case 7:
        return 'Last 7 Days';
      case 30:
        return 'Last 30 Days';
      case 365:
        return 'Last Year';
      default:
        return 'Custom Range';
    }
  }

  /// Get nutrient unit for display
  String getNutrientUnit(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'calories':
        return 'kcal';
      case 'protein':
      case 'carbs':
      case 'fats':
        return 'g';
      default:
        return '';
    }
  }
}
