import 'meals_model.dart';

/// Model class for daily food analysis data
/// Contains daily nutritional information and meal breakdown
class DailyFoodAnalysisModel {
  final String date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final MealsModel consumedMeals;

  const DailyFoodAnalysisModel({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.consumedMeals,
  });

  /// Create DailyFoodAnalysisModel from JSON data
  factory DailyFoodAnalysisModel.fromJson(Map<String, dynamic> json) {
    return DailyFoodAnalysisModel(
      date: json['date'] ?? '',
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProtein: (json['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
      consumedMeals: MealsModel.fromJson(json['consumedMeals'] ?? {}),
    );
  }

  /// Convert DailyFoodAnalysisModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
      'consumedMeals': consumedMeals.toJson(),
    };
  }

  /// Create empty DailyFoodAnalysisModel
  factory DailyFoodAnalysisModel.empty() {
    return DailyFoodAnalysisModel(
      date: '',
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFats: 0,
      consumedMeals: MealsModel.empty(),
    );
  }

  /// Get day name from date string
  String get dayName {
    try {
      final dateTime = DateTime.parse(date);
      final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return days[dateTime.weekday % 7];
    } catch (e) {
      return '';
    }
  }

  /// Get formatted date for display
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}';
    } catch (e) {
      return date;
    }
  }
}
