/// Exercise model for individual exercises in workout plans
class ExerciseModel {
  final String name;
  final String sets;
  final String reps;
  final String restPeriodMinutes;

  const ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restPeriodMinutes,
  });

  /// Create Exercise from JSON
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] ?? '',
      sets: json['sets'] ?? '',
      reps: json['reps'] ?? '',
      restPeriodMinutes: json['rest_period_minutes'] ?? '',
    );
  }

  /// Convert Exercise to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest_period_minutes': restPeriodMinutes,
    };
  }

  @override
  String toString() {
    return 'ExerciseModel(name: $name, sets: $sets, reps: $reps, restPeriodMinutes: $restPeriodMinutes)';
  }
}
