import 'package:barbell/features/barbell_llm/models/exercise_model.dart';

/// Workout day model representing a single day's workout
class WorkoutDayModel {
  final String day;
  final String focus;
  final List<ExerciseModel> exercises;

  const WorkoutDayModel({
    required this.day,
    required this.focus,
    required this.exercises,
  });

  /// Create WorkoutDay from JSON
  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      day: json['day'] ?? '',
      focus: json['focus'] ?? '',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert WorkoutDay to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'focus': focus,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  /// Check if this is a rest day (no exercises)
  bool get isRestDay => exercises.isEmpty;

  /// Get total number of exercises for this day
  int get totalExercises => exercises.length;

  @override
  String toString() {
    return 'WorkoutDayModel(day: $day, focus: $focus, exercises: ${exercises.length})';
  }
}
