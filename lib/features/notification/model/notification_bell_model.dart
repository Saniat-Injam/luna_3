class NotificationBellModel {
  final String id;
  final int newNotification;
  final int oldNotificationCount;
  final int seenNotificationCount;

  NotificationBellModel({
    required this.id,
    required this.newNotification,
    required this.oldNotificationCount,
    required this.seenNotificationCount,
  });

  factory NotificationBellModel.fromJson(Map<String, dynamic> json) {
    return NotificationBellModel(
      id: json['_id'] as String? ?? '',
      newNotification: json['newNotification'] as int? ?? 0,
      oldNotificationCount: json['oldNotificationCount'] as int? ?? 0,
      seenNotificationCount: json['seenNotificationCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'newNotification': newNotification,
      'oldNotificationCount': oldNotificationCount,
      'seenNotificationCount': seenNotificationCount,
    };
  }
}


/*
{
    "success": true,
    "message": "Notification for bell",
    "data": {
        "_id": "686b9fbbaaea47fd8255b936",
        "newNotification": 0,
        "oldNotificationCount": 5,
        "seenNotificationCount": 5
    }
}
*/