import 'package:barbell/features/notification/model/notification_model.dart';

class NotificationsModel {
  final String id;
  final String userId;
  final String profileId;
  final String createdAt;
  final int newNotification;
  final List<NotificationModel> notificationList;
  final int oldNotificationCount;
  final int seenNotificationCount;
  final String updatedAt;

  NotificationsModel({
    required this.id,
    required this.userId,
    required this.profileId,
    required this.createdAt,
    required this.newNotification,
    required this.notificationList,
    required this.oldNotificationCount,
    required this.seenNotificationCount,
    required this.updatedAt,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json['_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      profileId: json['Profile_id'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      newNotification: json['newNotification'] as int? ?? 0,
      notificationList:
          (json['notificationList'] as List<dynamic>? ?? [])
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      oldNotificationCount: json['oldNotificationCount'] as int? ?? 0,
      seenNotificationCount: json['seenNotificationCount'] as int? ?? 0,
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'Profile_id': profileId,
      'createdAt': createdAt,
      'newNotification': newNotification,
      'notificationList': notificationList.map((e) => e.toJson()).toList(),
      'oldNotificationCount': oldNotificationCount,
      'seenNotificationCount': seenNotificationCount,
      'updatedAt': updatedAt,
    };
  }
}
