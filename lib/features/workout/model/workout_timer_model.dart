class WorkoutTimerModel {
  bool? success;
  String? message;
  Data? data;

  WorkoutTimerModel({this.success, this.message, this.data});

  WorkoutTimerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? exerciseId;
  String? userId;
  int? set;
  int? weightLifted;
  int? reps;
  int? restTime;
  bool? isCompleted;
  int? totalCaloryBurn;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.exerciseId,
    this.userId,
    this.set,
    this.weightLifted,
    this.reps,
    this.restTime,
    this.isCompleted,
    this.totalCaloryBurn,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    exerciseId = json['exercise_id'];
    userId = json['user_id'];
    set = json['set'];
    weightLifted = json['weightLifted'];
    reps = json['reps'];
    restTime = json['restTime'];
    isCompleted = json['isCompleted'];
    totalCaloryBurn = json['totalCaloryBurn'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exercise_id'] = exerciseId;
    data['user_id'] = userId;
    data['set'] = set;
    data['weightLifted'] = weightLifted;
    data['reps'] = reps;
    data['restTime'] = restTime;
    data['isCompleted'] = isCompleted;
    data['totalCaloryBurn'] = totalCaloryBurn;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
