/// Model for nutrition macro (calories, protein, carbs, fats, fiber)
/// Represents goal, actual, remaining values and progress percentage
class NutritionMacro {
  final double goal;
  final double actual;
  final double remaining;
  final double progress;

  const NutritionMacro({
    required this.goal,
    required this.actual,
    required this.remaining,
    required this.progress,
  });

  /// Create NutritionMacro from JSON
  factory NutritionMacro.fromJson(Map<String, dynamic> json) {
    return NutritionMacro(
      goal: (json['goal'] ?? 0).toDouble(),
      actual: (json['actual'] ?? 0).toDouble(),
      remaining: (json['remaining'] ?? 0).toDouble(),
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'actual': actual,
      'remaining': remaining,
      'progress': progress,
    };
  }

  /// Calculate progress percentage (0-100)
  double get progressPercentage => progress * 100;

  /// Check if goal is met
  bool get isGoalMet => actual >= goal;

  /// Get formatted progress text
  String get progressText => '${actual.toInt()}/${goal.toInt()}';

  @override
  String toString() {
    return 'NutritionMacro(goal: $goal, actual: $actual, remaining: $remaining, progress: $progress)';
  }
}
