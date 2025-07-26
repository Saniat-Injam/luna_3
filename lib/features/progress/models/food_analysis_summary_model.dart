import 'daily_food_analysis_model.dart';
import 'total_food_analysis_model.dart';

/// Main model class for food analysis summary response
/// Contains daily breakdown and total summary data
class FoodAnalysisSummaryModel {
  final bool success;
  final List<DailyFoodAnalysisModel> daily;
  final TotalFoodAnalysisModel total;
  final String? message;

  const FoodAnalysisSummaryModel({
    required this.success,
    required this.daily,
    required this.total,
    this.message,
  });

  /// Create FoodAnalysisSummaryModel from JSON data
  factory FoodAnalysisSummaryModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] ?? {};

    return FoodAnalysisSummaryModel(
      success: json['success'] ?? false,
      daily:
          (dataJson['daily'] as List<dynamic>?)
              ?.map((item) => DailyFoodAnalysisModel.fromJson(item))
              .toList() ??
          [],
      total: TotalFoodAnalysisModel.fromJson(dataJson['total'] ?? {}),
      message: json['message'],
    );
  }

  /// Convert FoodAnalysisSummaryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': {
        'daily': daily.map((item) => item.toJson()).toList(),
        'total': total.toJson(),
      },
      if (message != null) 'message': message,
    };
  }

  /// Create empty FoodAnalysisSummaryModel
  factory FoodAnalysisSummaryModel.empty() {
    return FoodAnalysisSummaryModel(
      success: false,
      daily: [],
      total: TotalFoodAnalysisModel.empty(),
    );
  }

  /// Get data for chart visualization based on nutrient type
  List<Map<String, dynamic>> getChartData(String nutrientType) {
    return daily.map((dayData) {
      double value = 0;
      switch (nutrientType.toLowerCase()) {
        case 'calories':
          value = dayData.totalCalories;
          break;
        case 'protein':
          value = dayData.totalProtein;
          break;
        case 'carbs':
          value = dayData.totalCarbs;
          break;
        case 'fats':
          value = dayData.totalFats;
          break;
      }

      return {
        'day': dayData.dayName,
        'date': dayData.formattedDate,
        'value': value,
        'fullDate': dayData.date,
      };
    }).toList();
  }

  /// Get meal breakdown data for pie chart
  List<Map<String, dynamic>> getMealBreakdownData(String nutrientType) {
    // Calculate totals for each meal type across all days
    double breakfastTotal = 0;
    double lunchTotal = 0;
    double dinnerTotal = 0;
    double snackTotal = 0;

    for (final dayData in daily) {
      switch (nutrientType.toLowerCase()) {
        case 'calories':
          breakfastTotal += dayData.consumedMeals.breakfast.totalCalories;
          lunchTotal += dayData.consumedMeals.lunch.totalCalories;
          dinnerTotal += dayData.consumedMeals.dinner.totalCalories;
          snackTotal += dayData.consumedMeals.snack.totalCalories;
          break;
        case 'protein':
          breakfastTotal += dayData.consumedMeals.breakfast.totalProtein;
          lunchTotal += dayData.consumedMeals.lunch.totalProtein;
          dinnerTotal += dayData.consumedMeals.dinner.totalProtein;
          snackTotal += dayData.consumedMeals.snack.totalProtein;
          break;
        case 'carbs':
          breakfastTotal += dayData.consumedMeals.breakfast.totalCarbs;
          lunchTotal += dayData.consumedMeals.lunch.totalCarbs;
          dinnerTotal += dayData.consumedMeals.dinner.totalCarbs;
          snackTotal += dayData.consumedMeals.snack.totalCarbs;
          break;
        case 'fats':
          breakfastTotal += dayData.consumedMeals.breakfast.totalFats;
          lunchTotal += dayData.consumedMeals.lunch.totalFats;
          dinnerTotal += dayData.consumedMeals.dinner.totalFats;
          snackTotal += dayData.consumedMeals.snack.totalFats;
          break;
      }
    }

    return [
      {'meal': 'Breakfast', 'value': breakfastTotal, 'color': 0xFF4CAF50},
      {'meal': 'Lunch', 'value': lunchTotal, 'color': 0xFF2196F3},
      {'meal': 'Dinner', 'value': dinnerTotal, 'color': 0xFFFF9800},
      {'meal': 'Snack', 'value': snackTotal, 'color': 0xFF9C27B0},
    ];
  }

  /// Check if data is available for the time period
  bool get hasData =>
      daily.isNotEmpty &&
      daily.any(
        (day) =>
            day.totalCalories > 0 ||
            day.totalProtein > 0 ||
            day.totalCarbs > 0 ||
            day.totalFats > 0,
      );
}
