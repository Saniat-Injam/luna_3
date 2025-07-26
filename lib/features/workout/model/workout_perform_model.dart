/*
{
    "success": true,
    "message": "Exercise performed successfully.",
    "data": {
        "exercise_id": "6851386ff393e163acacaf6a",
        "user_id": "684563990c0b9410346f1f5c",
        "set": 3,
        "weightLifted": 0,
        "reps": 12,
        "resetTime": 60,
        "isCompleted": false,
        "totalCaloryBurn": 0,
        "_id": "68660073e5364d4ec7b738da",
        "createdAt": "2025-07-03T04:00:51.136Z",
        "updatedAt": "2025-07-03T04:00:51.136Z",
        "__v": 0
    }
}
*/

import 'dart:convert';

// Helper function to decode JSON string to ExerciseModel
PerformExerciseModel exerciseModelFromJson(String str) =>
    PerformExerciseModel.fromJson(json.decode(str));

// Helper function to encode ExerciseModel to JSON string
String exerciseModelToJson(PerformExerciseModel data) =>
    json.encode(data.toJson());

class PerformExerciseModel {
  final String exerciseId;
  final String userId;
  final int set;
  int? weightLifted;
  final int reps;
  final int resetTime;
  final bool isCompleted;
  final int totalCaloryBurn;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  PerformExerciseModel({
    required this.exerciseId,
    required this.userId,
    required this.set,
    this.weightLifted,
    required this.reps,
    required this.resetTime,
    required this.isCompleted,
    required this.totalCaloryBurn,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PerformExerciseModel.fromJson(Map<String, dynamic> json) =>
      PerformExerciseModel(
        exerciseId: json["exercise_id"],
        userId: json["user_id"],
        set: json["set"],
        weightLifted: json["weightLifted"] ?? 0,
        reps: json["reps"],
        resetTime: json["resetTime"],
        isCompleted: json["isCompleted"],
        totalCaloryBurn: json["totalCaloryBurn"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "exercise_id": exerciseId,
    "user_id": userId,
    "set": set,
    "weightLifted": weightLifted,
    "reps": reps,
    "resetTime": resetTime,
    "isCompleted": isCompleted,
    "totalCaloryBurn": totalCaloryBurn,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
