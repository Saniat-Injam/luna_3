/*
{
            "_id": "685bdfd553db8751e4967636",
            "user_id": "684563990c0b9410346f1f5c",
            "habit_id": "685b7307f75904b27c1e0676",
            "isPushNotification": false,
            "reminderTime": "2025-06-08T09:00:00.000Z",
            "reminderInterval": 60,
            "reminderDays": [
                "Monday",
                "Wednesday",
                "Friday"
            ],
            "__v": 0
        }
*/

class MyHabitModel {
  const MyHabitModel({
    required this.id,
    required this.userId,
    required this.habitId,
    required this.isPushNotification,
    required this.reminderTime,
    required this.reminderInterval,
    required this.reminderDays,
  });

  final String id;
  final String userId;
  final String habitId;
  final bool isPushNotification;
  final String reminderTime;
  final int reminderInterval;
  final List<String> reminderDays;

  factory MyHabitModel.fromJson(Map<String, dynamic> json) {
    return MyHabitModel(
      id: json['_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      habitId: json['habit_id'] as String? ?? '',
      isPushNotification: json['isPushNotification'] as bool? ?? false,
      reminderTime: json['reminderTime'] as String? ?? '',
      reminderInterval: (json['reminderInterval'] as num?)?.toInt() ?? 0,
      reminderDays: json['reminderDays'] != null 
          ? List<String>.from((json['reminderDays'] as List).map((item) => item.toString())) 
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'habit_id': habitId,
      'isPushNotification': isPushNotification,
      'reminderTime': reminderTime,
      'reminderInterval': reminderInterval,
      'reminderDays': reminderDays,
    };
  }
}
