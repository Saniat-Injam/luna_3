import 'package:barbell/features/barbell_llm/models/workout_plan_model.dart';

/// Saved workout plan data model
class SavedWorkoutPlanData {
  final String id;
  final String userId;
  final WorkoutPlanModel workoutPlan;
  final String createdAt;
  final String updatedAt;

  const SavedWorkoutPlanData({
    required this.id,
    required this.userId,
    required this.workoutPlan,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create SavedWorkoutPlanData from JSON
  factory SavedWorkoutPlanData.fromJson(Map<String, dynamic> json) {
    return SavedWorkoutPlanData(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      workoutPlan: WorkoutPlanModel.fromJson(json['workout_plan'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Convert SavedWorkoutPlanData to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'workout_plan': workoutPlan.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'SavedWorkoutPlanData(id: $id, userId: $userId, createdAt: $createdAt)';
  }
}

/// API response model for saved workout plan
class SavedWorkoutPlanResponse {
  final bool success;
  final String message;
  final SavedWorkoutPlanData data;

  const SavedWorkoutPlanResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Create SavedWorkoutPlanResponse from JSON
  factory SavedWorkoutPlanResponse.fromJson(Map<String, dynamic> json) {
    return SavedWorkoutPlanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SavedWorkoutPlanData.fromJson(json['data'] ?? {}),
    );
  }

  /// Convert SavedWorkoutPlanResponse to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  String toString() {
    return 'SavedWorkoutPlanResponse(success: $success, message: $message)';
  }
}
