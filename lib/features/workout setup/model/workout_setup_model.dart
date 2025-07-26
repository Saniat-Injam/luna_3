/*
{
  "proteinGoal": 0,
  "carbsGoal": 0,
  "fatsGoal": 0,
  "fiberGoal": 0,
  "_id": "68593d00ae46426ed849f8b1",
  "user_id": {
      "_id": "684563990c0b9410346f1f5c",
      "name": "Admin",
      "email": "admin@gmail.com"
  },
  "goal": "lose_weight",
  "gender": "male",
  "weight": 75,
  "age": 30,
  "height": 175,
  "dietaryPreference": "plant_based",
  "exercisePreference": "yoga",
  "calorieGoal": 2000,
  "sleepQuality": {
      "quality": "normal",
      "lowerLimit": 5,
      "upperLimit": 6,
      "_id": "68593d00ae46426ed849f8b2"
  }
*/

import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/workout%20setup/model/sleep_quality_model.dart';

class WorkoutSetupModel {
  final String id;
  final double proteinGoal;
  final double carbsGoal;
  final double fatsGoal;
  final double fiberGoal;
  final String userId;
  final String goal;
  final String gender;
  final double weight;
  final int age;
  final int height;
  final String dietaryPreference;
  final String exercisePreference;
  final double calorieGoal;
  final SleepQualityModel sleepQuality;

  WorkoutSetupModel({
    required this.id,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatsGoal,
    required this.fiberGoal,
    required this.userId,
    required this.goal,
    required this.gender,
    required this.weight,
    required this.age,
    required this.height,
    required this.dietaryPreference,
    required this.exercisePreference,
    required this.calorieGoal,
    required this.sleepQuality,
  });

  factory WorkoutSetupModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetupModel(
      id: json['_id'],
      proteinGoal: (json['proteinGoal'] as num).toDouble(),
      carbsGoal: (json['carbsGoal'] as num).toDouble(),
      fatsGoal: (json['fatsGoal'] as num).toDouble(),
      fiberGoal: (json['fiberGoal'] as num).toDouble(),
      userId: json['user_id'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user_id']).id ?? ''
          : json['user_id'] ?? '',
      goal: json['goal'],
      gender: json['gender'],
      weight: (json['weight'] as num).toDouble(),
      age: json['age'],
      height: json['height'],
      dietaryPreference: json['dietaryPreference'],
      exercisePreference: json['exercisePreference'],
      calorieGoal: (json['calorieGoal'] as num).toDouble(),
      sleepQuality: SleepQualityModel.fromJson(json['sleepQuality']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['proteinGoal'] = proteinGoal;
    data['carbsGoal'] = carbsGoal;
    data['fatsGoal'] = fatsGoal;
    data['fiberGoal'] = fiberGoal;
    data['user_id'] = userId;
    data['goal'] = goal;
    data['gender'] = gender;
    data['weight'] = weight; // already double
    data['age'] = age;
    data['height'] = height;
    data['dietaryPreference'] = dietaryPreference;
    data['exercisePreference'] = exercisePreference;
    data['calorieGoal'] = calorieGoal;
    data['sleepQuality'] = sleepQuality.toJson();
    return data;
  }
}
