class NotificationModel {
  final String id;
  final String userId;
  final String profileId;
  final String notificationType;
  final String notificationDetail;
  final bool isSeen;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.profileId,
    required this.notificationType,
    required this.notificationDetail,
    required this.isSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      profileId: json['Profile_id'] as String? ?? '',
      notificationType: json['notificationType'] as String? ?? '',
      notificationDetail: json['notificationDetail'] as String? ?? '',
      isSeen: json['isSeen'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'Profile_id': profileId,
      'notificationType': notificationType,
      'notificationDetail': notificationDetail,
      'isSeen': isSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/*
{
    "success": true,
    "message": "All Notification",
    "data": {
        "_id": "686b9fbbaaea47fd8255b936",
        "user_id": "684563990c0b9410346f1f5c",
        "Profile_id": "6845639a0c0b9410346f1f5e",
        "__v": 0,
        "createdAt": "2025-07-07T10:21:47.314Z",
        "newNotification": 0,
        "notificationList": [
            {
                "_id": "686ba9f8c4df8d619d93deea",
                "user_id": "684563990c0b9410346f1f5c",
                "Profile_id": "6845639a0c0b9410346f1f5e",
                "notificationType": "admin_notification",
                "notificationDetail": "This is a test message for testing, we can't hold for the final time...!",
                "isSeen": false,
                "createdAt": "2025-07-07T11:05:28.259Z",
                "updatedAt": "2025-07-07T11:05:28.259Z",
                "__v": 0
            },
            {
                "_id": "686ba9f6c4df8d619d93dee2",
                "user_id": "684563990c0b9410346f1f5c",
                "Profile_id": "6845639a0c0b9410346f1f5e",
                "notificationType": "admin_notification",
                "notificationDetail": "This is a test message for testing, we can't hold for the final time...!",
                "isSeen": false,
                "createdAt": "2025-07-07T11:05:26.535Z",
                "updatedAt": "2025-07-07T11:05:26.535Z",
                "__v": 0
            },
            {
                "_id": "686ba9f1c4df8d619d93deda",
                "user_id": "684563990c0b9410346f1f5c",
                "Profile_id": "6845639a0c0b9410346f1f5e",
                "notificationType": "admin_notification",
                "notificationDetail": "This is a test message for testing, we can't hold for the final time...!",
                "isSeen": false,
                "createdAt": "2025-07-07T11:05:21.656Z",
                "updatedAt": "2025-07-07T11:05:21.656Z",
                "__v": 0
            },
            {
                "_id": "686b9fd91255fcd9b933ee26",
                "user_id": "684563990c0b9410346f1f5c",
                "Profile_id": "6845639a0c0b9410346f1f5e",
                "notificationType": "admin_notification",
                "notificationDetail": "this is a test message",
                "isSeen": false,
                "createdAt": "2025-07-07T10:22:17.436Z",
                "updatedAt": "2025-07-07T10:22:17.436Z",
                "__v": 0
            },
            {
                "_id": "686b9fbb1255fcd9b933ee1e",
                "user_id": "684563990c0b9410346f1f5c",
                "Profile_id": "6845639a0c0b9410346f1f5e",
                "notificationType": "admin_notification",
                "notificationDetail": "this is a test message",
                "isSeen": false,
                "createdAt": "2025-07-07T10:21:47.540Z",
                "updatedAt": "2025-07-07T10:21:47.540Z",
                "__v": 0
            }
        ],
        "oldNotificationCount": 5,
        "seenNotificationCount": 5,
        "updatedAt": "2025-07-08T03:23:03.405Z"
    }
}
*/
