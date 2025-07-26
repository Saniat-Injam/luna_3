import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/notification/controller/delete_notification_controller.dart';
import 'package:barbell/features/notification/controller/get_all_notification_controller.dart';
import 'package:barbell/features/notification/controller/notification_controller.dart';
import 'package:barbell/features/notification/screen/notification_details_screen.dart';

class SwipeTile extends StatelessWidget {
  const SwipeTile({
    required this.index,
    super.key,
    required this.getAllNotificationController,
  });

  final int index;
  final GetAllNotificationController getAllNotificationController;
  @override
  Widget build(BuildContext context) {
    final notification =
        getAllNotificationController
            .notificationsModel
            ?.notificationList[index];
    final NotificationController controller = Get.find();

    // Ensure offset is initialized after the current build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.ensureSwipeOffsetsLength(index + 1);
    });

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        double currentOffset =
            controller.getOffsetAndEnsure(index) + details.delta.dx;
        if (currentOffset <= 0 && currentOffset >= -37) {
          controller.updateOffset(index, currentOffset);
        }
      },
      onHorizontalDragEnd: (details) {
        double offset = controller.getOffsetAndEnsure(index);
        if (offset < -20) {
          controller.revealDelete(index);
        } else {
          controller.resetOffset(index);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              return AnimatedOpacity(
                opacity: controller.getOffset(index) <= -37 ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: Color(0xFFF97316),
                    ),
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: GestureDetector(
                        onTap: () async {
                          final bool isDeleted =
                              await Get.find<DeleteNotificationController>()
                                  .deleteNotification(notification?.id ?? '');
                          if (isDeleted) {
                            await getAllNotificationController
                                .getAllNotifications();
                          } else {
                            EasyLoading.showError(
                              'Failed to delete notification',
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                        child: Image.asset(
                          IconPath.removed,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Obx(() {
            return Transform.translate(
              offset: Offset(controller.getOffset(index), 0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (notification != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => NotificationDetailsScreen(
                                notificationType: notification.notificationType,
                                notificationDetail:
                                    notification.notificationDetail,
                                createdAt: DateFormat(
                                  'dd MMM yy, hh:mm a',
                                ).format(
                                  DateTime.parse(notification.createdAt),
                                ),
                              ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF1C2227),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              notification != null
                                  ? DateFormat.jm().format(
                                    DateTime.parse(notification.createdAt),
                                  )
                                  : '',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFF97316),
                              ),
                            ),
                            Text(
                              notification != null
                                  ? DateFormat('dd MMM yy').format(
                                    DateTime.parse(notification.createdAt),
                                  )
                                  : '',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFF97316),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                notification?.notificationType ?? '',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                notification?.notificationDetail != null
                                    ? notification!.notificationDetail.length >
                                            50
                                        ? notification.notificationDetail
                                            .substring(0, 50)
                                        : notification.notificationDetail
                                    : '',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF8C8C8C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
