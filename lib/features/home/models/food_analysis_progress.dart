import 'nutrition_macro.dart';

/// Model for food analysis progress response
/// Contains nutrition data for calories, protein, carbs, fats, and fiber
class FoodAnalysisProgress {
  final NutritionMacro calories;
  final NutritionMacro protein;
  final NutritionMacro carbs;
  final NutritionMacro fats;
  final NutritionMacro fiber;

  const FoodAnalysisProgress({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
  });

  /// Create FoodAnalysisProgress from API response JSON
  factory FoodAnalysisProgress.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return FoodAnalysisProgress(
      calories: NutritionMacro.fromJson(data['calories'] ?? {}),
      protein: NutritionMacro.fromJson(data['protein'] ?? {}),
      carbs: NutritionMacro.fromJson(data['carbs'] ?? {}),
      fats: NutritionMacro.fromJson(data['fats'] ?? {}),
      fiber: NutritionMacro.fromJson(data['fiber'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'calories': calories.toJson(),
        'protein': protein.toJson(),
        'carbs': carbs.toJson(),
        'fats': fats.toJson(),
        'fiber': fiber.toJson(),
      },
    };
  }

  /// Get total calories consumed today
  double get totalCalories => calories.actual;

  /// Get total calories remaining
  double get remainingCalories => calories.remaining;

  /// Check if all goals are met
  bool get allGoalsMet =>
      calories.isGoalMet &&
      protein.isGoalMet &&
      carbs.isGoalMet &&
      fats.isGoalMet &&
      fiber.isGoalMet;

  /// Get overall progress percentage (average of all macros)
  double get overallProgress {
    final totalProgress =
        calories.progress +
        protein.progress +
        carbs.progress +
        fats.progress +
        fiber.progress;
    return (totalProgress / 5) * 100;
  }

  @override
  String toString() {
    return 'FoodAnalysisProgress(calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, fiber: $fiber)';
  }
}
