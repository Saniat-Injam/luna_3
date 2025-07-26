class UserModel {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? password;
  bool? aggriedToTerms;
  String? role;
  bool? allowPasswordChange;
  bool? OTPverified;
  bool? isDeleted;
  bool? isBlocked;
  bool? isLoggedIn;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? sentOTP;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.aggriedToTerms,
    this.role,
    this.allowPasswordChange,
    this.OTPverified,
    this.isDeleted,
    this.isBlocked,
    this.isLoggedIn,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.sentOTP,
  });

  // from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      aggriedToTerms: json['aggriedToTerms'],
      role: json['role'],
      allowPasswordChange: json['allowPasswordChange'],
      OTPverified: json['OTPverified'],
      isDeleted: json['isDeleted'],
      isBlocked: json['isBlocked'],
      isLoggedIn: json['isLoggedIn'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      sentOTP: json['sentOTP'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['aggriedToTerms'] = aggriedToTerms;
    data['role'] = role;
    data['allowPasswordChange'] = allowPasswordChange;
    data['OTPverified'] = OTPverified;
    data['isDeleted'] = isDeleted;
    data['isBlocked'] = isBlocked;
    data['isLoggedIn'] = isLoggedIn;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['sentOTP'] = sentOTP;
    return data;
  }
}

/// Workout plan models for Barbell LLM feature
class WorkoutPlanResponse {
  final bool success;
  final String message;
  final WorkoutPlanData? data;

  const WorkoutPlanResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WorkoutPlanResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? WorkoutPlanData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class WorkoutPlanData {
  final WorkoutPlan? workoutPlan;

  const WorkoutPlanData({this.workoutPlan});

  factory WorkoutPlanData.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanData(
      workoutPlan:
          json['workout_plan'] != null
              ? WorkoutPlan.fromJson(json['workout_plan'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'workout_plan': workoutPlan?.toJson()};
  }
}

class WorkoutPlan {
  final List<WorkoutDay> plan;

  const WorkoutPlan({required this.plan});

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      plan:
          (json['plan'] as List<dynamic>?)
              ?.map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'plan': plan.map((e) => e.toJson()).toList()};
  }
}

class WorkoutDay {
  final String day;
  final String focus;
  final List<Exercise> exercises;

  const WorkoutDay({
    required this.day,
    required this.focus,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      day: json['day'] ?? '',
      focus: json['focus'] ?? '',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'focus': focus,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class Exercise {
  final String name;
  final String sets;
  final String reps;
  final String restPeriodMinutes;

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restPeriodMinutes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      sets: json['sets'] ?? '',
      reps: json['reps'] ?? '',
      restPeriodMinutes: json['rest_period_minutes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest_period_minutes': restPeriodMinutes,
    };
  }
}

/// Update workout plan response model with different structure
class UpdateWorkoutPlanResponse {
  final bool success;
  final String message;
  final UpdateWorkoutData? data;

  const UpdateWorkoutPlanResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdateWorkoutPlanResponse.fromJson(Map<String, dynamic> json) {
    return UpdateWorkoutPlanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? UpdateWorkoutData.fromJson(json['data'])
              : null,
    );
  }
}

class UpdateWorkoutData {
  final List<WorkoutDay> plan;

  const UpdateWorkoutData({required this.plan});

  factory UpdateWorkoutData.fromJson(Map<String, dynamic> json) {
    return UpdateWorkoutData(
      plan:
          (json['plan'] as List<dynamic>?)
              ?.map((e) => WorkoutDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

