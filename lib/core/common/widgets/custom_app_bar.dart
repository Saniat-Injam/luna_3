import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/notification/screen/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showNotification;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final List<Widget>? actions;
  final bool showCalendarIcon;
  final VoidCallback? onCalendarPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showNotification = false,
    this.onBackPressed,
    this.onNotificationPressed,
    this.actions,
    this.showCalendarIcon = false,
    this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,

      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: SvgPicture.asset(
                height: 24,
                width: 24,
                SvgPath.backArrowSvg,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actions != null) ...actions!,
          if (showNotification)
            GestureDetector(
              onTap:
                  onNotificationPressed ??
                  () {
                    Get.to(() => NotificationScreen());
                  },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff303502)),
                  color: const Color(0xff1F2301),
                ),
                child: Image.asset(
                  IconPath.notificationicon,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          if (showCalendarIcon)
            GestureDetector(
              onTap: onCalendarPressed ?? () {},
              child: SvgPicture.asset(
                height: 34,
                width: 34,
                SvgPath.calendarSvg,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
