import 'package:barbell/features/barbell_llm/models/workout_day_model.dart';

/// Workout plan model containing all workout days
class WorkoutPlanModel {
  final List<WorkoutDayModel> plan;

  const WorkoutPlanModel({required this.plan});

  /// Create WorkoutPlan from JSON
  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      plan:
          (json['plan'] as List<dynamic>?)
              ?.map((e) => WorkoutDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert WorkoutPlan to JSON
  Map<String, dynamic> toJson() {
    return {'plan': plan.map((e) => e.toJson()).toList()};
  }

  /// Get total number of workout days (excluding rest days)
  int get totalWorkoutDays => plan.where((day) => !day.isRestDay).length;

  /// Get total number of exercises across all days
  int get totalExercises =>
      plan.fold(0, (sum, day) => sum + day.totalExercises);

  /// Get workout days only (excluding rest days)
  List<WorkoutDayModel> get workoutDays =>
      plan.where((day) => !day.isRestDay).toList();

  /// Get rest days only
  List<WorkoutDayModel> get restDays =>
      plan.where((day) => day.isRestDay).toList();

  @override
  String toString() {
    return 'WorkoutPlanModel(totalDays: ${plan.length}, workoutDays: $totalWorkoutDays, totalExercises: $totalExercises)';
  }
}
