import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/notification_button_widget.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/notification/controller/get_all_notification_controller.dart';
import 'package:barbell/features/notification/screen/notification_screen.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';

class HomeHeader extends StatelessWidget {
  // final String image;
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    _getProfileData();
    // Get.find<ProfileController>();
    return SizedBox(
      height: 80, // Set a fixed height to prevent overflow
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetBuilder<ProfileController>(
            builder: (controller) {
              if (controller.isLoading) {
                return Shimmer.fromColors(
                  baseColor: AppColors.primary,
                  highlightColor: Colors.grey,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              }
              return Row(
                children: [
                  // Profile Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl:
                          controller.profileModel?.img ??
                          StorageService.imgUrl ??
                          '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.textWhite,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hello, ${controller.profileModel?.name ?? StorageService.name ?? 'User'}',
                    style: getTextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      lineHeight: 21,
                    ),
                  ),
                ],
              );
            },
          ),

          // Notification Icon
          GestureDetector(
            onTap: () {
              Get.find<GetAllNotificationController>().getAllNotifications();
              Get.to(() => const NotificationScreen());
            },
            child: NotificationButtonWidget(),

            // child: Container(
            //   height: 40,
            //   width: 40,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(color: const Color(0xff303502)),
            //     color: const Color(0xff1F2301),
            //   ),
            //   child: GetBuilder<GetNotificationBellController>(
            //     builder: (ctrl) {
            //       if ((ctrl.notificationBellModel?.newNotification ?? 0) < 1) {
            //         return SvgPicture.asset(
            //           'assets/svg/notification.svg',
            //           width: 20,
            //           height: 20,
            //         );
            //       }
            //       return SvgPicture.asset(
            //         'assets/svg/notification_unread.svg',
            //         width: 20,
            //         height: 20,
            //       ); // Return an empty container if no new notifications
            //     },
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  void _getProfileData() async {
    if (Get.find<ProfileController>().profileModel != null) return;

    await Get.find<ProfileController>().getProfileData();
    EasyLoading.dismiss();

    if (Get.find<ProfileController>().profileModel == null) {
      Logger().e('Profile data is null, navigating to login screen');
      Get.offAll(() => const LoginScreen());
    }
  }
}
