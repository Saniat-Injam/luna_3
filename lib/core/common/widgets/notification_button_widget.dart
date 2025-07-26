import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/controllers/notification_badge_controller.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/notification/screen/notification_screen.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the existing notification badge controller
    final notificationBadgeController = Get.find<NotificationBadgeController>();

    return IconButton(
      onPressed: () async {
        // Mark notifications as read when user taps the button
        await notificationBadgeController.markNotificationsAsRead();

        // Navigate to notification screen
        Get.to(() => NotificationScreen());
      },
      icon: Container(
        width: 34.28,
        height: 34.28,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.notificationBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.notificationBorder),
        ),
        child: Obx(() {
          // Show unread icon if there are unread notifications, otherwise show normal icon
          return SvgPicture.asset(
            notificationBadgeController.hasUnreadNotifications.value
                ? SvgPath.notificationUnread
                : SvgPath.notification,
          );
        }),
      ),
    );
  }
}
