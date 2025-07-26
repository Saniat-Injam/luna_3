/// Model class for total food analysis summary
/// Contains overall nutritional totals for the selected time period
class TotalFoodAnalysisModel {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;

  const TotalFoodAnalysisModel({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
  });

  /// Create TotalFoodAnalysisModel from JSON data
  factory TotalFoodAnalysisModel.fromJson(Map<String, dynamic> json) {
    return TotalFoodAnalysisModel(
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProtein: (json['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
    );
  }

  /// Convert TotalFoodAnalysisModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }

  /// Create empty TotalFoodAnalysisModel
  factory TotalFoodAnalysisModel.empty() {
    return const TotalFoodAnalysisModel(
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFats: 0,
    );
  }

  /// Get average daily calories for the time period
  double getAverageDailyCalories(int days) {
    return days > 0 ? totalCalories / days : 0;
  }

  /// Get average daily protein for the time period
  double getAverageDailyProtein(int days) {
    return days > 0 ? totalProtein / days : 0;
  }

  /// Get average daily carbs for the time period
  double getAverageDailyCarbs(int days) {
    return days > 0 ? totalCarbs / days : 0;
  }

  /// Get average daily fats for the time period
  double getAverageDailyFats(int days) {
    return days > 0 ? totalFats / days : 0;
  }
}
