import 'consumed_meal_model.dart';

/// Model class for meals data containing all meal types
/// Includes breakfast, lunch, dinner and snack information
class MealsModel {
  final ConsumedMealModel breakfast;
  final ConsumedMealModel lunch;
  final ConsumedMealModel dinner;
  final ConsumedMealModel snack;

  const MealsModel({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snack,
  });

  /// Create MealsModel from JSON data
  factory MealsModel.fromJson(Map<String, dynamic> json) {
    return MealsModel(
      breakfast: ConsumedMealModel.fromJson(json['breakfast'] ?? {}),
      lunch: ConsumedMealModel.fromJson(json['lunch'] ?? {}),
      dinner: ConsumedMealModel.fromJson(json['dinner'] ?? {}),
      snack: ConsumedMealModel.fromJson(json['snack'] ?? {}),
    );
  }

  /// Convert MealsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
      'snack': snack.toJson(),
    };
  }

  /// Create empty MealsModel
  factory MealsModel.empty() {
    return MealsModel(
      breakfast: ConsumedMealModel.empty(),
      lunch: ConsumedMealModel.empty(),
      dinner: ConsumedMealModel.empty(),
      snack: ConsumedMealModel.empty(),
    );
  }
}
