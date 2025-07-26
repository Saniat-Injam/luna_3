/// Model class for consumed meals data
/// Contains nutritional information for different meal types
class ConsumedMealModel {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;

  const ConsumedMealModel({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
  });

  /// Create ConsumedMealModel from JSON data
  factory ConsumedMealModel.fromJson(Map<String, dynamic> json) {
    return ConsumedMealModel(
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProtein: (json['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
    );
  }

  /// Convert ConsumedMealModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }

  /// Create empty ConsumedMealModel
  factory ConsumedMealModel.empty() {
    return const ConsumedMealModel(
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFats: 0,
    );
  }
}
