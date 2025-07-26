import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/controllers/notification_badge_controller.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/notification/controller/get_all_notification_controller.dart';
import 'package:barbell/features/notification/widget/notification_swipe_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    // Mark notifications as read when user enters this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final notificationBadgeController =
            Get.find<NotificationBadgeController>();
        notificationBadgeController.markNotificationsAsRead();
      } catch (e) {
        // Controller might not be initialized, that's okay
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getAllNotificationController =
        Get.find<GetAllNotificationController>();

    getAllNotificationController.getAllNotifications();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: "Notifications"),
      body: GetBuilder<GetAllNotificationController>(
        builder:
            (controller) => Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: RefreshIndicator(
                onRefresh: () async {
                  await getAllNotificationController.getAllNotifications();
                  // Also refresh notification badge status from server
                  try {
                    final notificationBadgeController =
                        Get.find<NotificationBadgeController>();
                    await notificationBadgeController
                        .refreshNotificationStatus();
                  } catch (e) {
                    // Handle error silently
                  }
                },
                child: ListView.builder(
                  itemCount:
                      getAllNotificationController
                          .notificationsModel
                          ?.notificationList
                          .length,
                  itemBuilder:
                      (context, index) => SwipeTile(
                        index: index,
                        getAllNotificationController:
                            getAllNotificationController,
                      ),
                ),
              ),
            ),
      ),
    );
  }
}
