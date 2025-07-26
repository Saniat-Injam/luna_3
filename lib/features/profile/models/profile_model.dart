/*
{
    "success": true,
    "message": "your position retrived",
    "data": {
        "habits": [],
        "favoriteFood": [],
        "_id": "6847edf9e20c705b82be9e54",
        "name": "Mukarrom",
        "phone": "015xxxxxxxx",
        "email": "mukarrom@yopmail.com",
        "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750226394/files-1750226392877-298582142.png.png",
        "emailNotification": false,
        "user_id": {
            "_id": "6847edf9e20c705b82be9e52",
            "name": "Mukarrom",
            "phone": "015xxxxxxxx",
            "email": "mukarrom@yopmail.com",
            "password": "$2b$10$dHlA2zRFQ3hmkDBWFcmTUulkY9qiR1qA5AYoHlmYbMnBjIlOwYXQe",
            "aggriedToTerms": true,
            "role": "user",
            "allowPasswordChange": false,
            "OTPverified": true,
            "isDeleted": false,
            "isBlocked": false,
            "isLoggedIn": true,
            "createdAt": "2025-06-10T08:34:01.290Z",
            "updatedAt": "2025-06-18T05:57:55.735Z",
            "__v": 0,
            "sentOTP": "255334"
        },
        "lastJobNotificationDate": null,
        "isDeleted": false,
        "createdAt": "2025-06-10T08:34:01.866Z",
        "updatedAt": "2025-06-18T05:59:55.057Z",
        "__v": 0,
        "workoutASetup": {
            "_id": "68522b7448fd7655f9e86f7f",
            "user_id": "6847edf9e20c705b82be9e52",
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
                "_id": "68522b7448fd7655f9e86f80"
            },
            "__v": 0
        }
    }
}
 */

import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/workout%20setup/model/workout_setup_model.dart';

class ProfileModel {
  final List<String>? habits;
  final List<String>? favoriteFood;
  final String id;
  final String name;
  final String? phone;
  final String email;
  final String? img;
  final bool? emailNotification;
  final UserModel userId;
  final String? lastJobNotificationDate;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final WorkoutSetupModel? workoutSetup;

  ProfileModel({
    this.habits,
    this.favoriteFood,
    required this.id,
    required this.name,
    this.phone,
    required this.email,
    this.img,
    this.emailNotification,
    required this.userId,
    this.lastJobNotificationDate,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.workoutSetup,
  });

  // from json
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      habits: List<String>.from(json['habits'] ?? <String>[]),
      favoriteFood: List<String>.from(json['favoriteFood'] ?? <String>[]),
      id: json['_id'],
      name: json['name'],
      phone: json['phone'], // This can be null now
      email: json['email'],
      img: json['img'],
      emailNotification: json['emailNotification'],
      userId: UserModel.fromJson(json['user_id']),
      lastJobNotificationDate: json['lastJobNotificationDate'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      workoutSetup:
          json['workoutASetup'] != null
              ? WorkoutSetupModel.fromJson(json['workoutASetup'])
              : null,
    );
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'habits': habits,
      'favoriteFood': favoriteFood,
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'img': img,
      'emailNotification': emailNotification,
      'user_id': userId.toJson(),
      'lastJobNotificationDate': lastJobNotificationDate,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'workoutASetup':
          workoutSetup?.toJson(), // Changed from workoutSetup to workoutASetup
    };
  }

  // copy with
  ProfileModel copyWith({
    List<String>? habits,
    List<String>? favoriteFood,
    String? id,
    String? name,
    String? phone,
    String? email,
    String? img,
    bool? emailNotification,
    UserModel? userId,
    DateTime? lastJobNotificationDate,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    WorkoutSetupModel? workoutSetup,
  }) {
    return ProfileModel(
      habits: habits ?? this.habits,
      favoriteFood: favoriteFood ?? this.favoriteFood,
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      img: img ?? this.img,
      emailNotification: emailNotification ?? this.emailNotification,
      userId: userId ?? this.userId,
      lastJobNotificationDate: this.lastJobNotificationDate,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      workoutSetup: workoutSetup ?? this.workoutSetup,
    );
  }
}
