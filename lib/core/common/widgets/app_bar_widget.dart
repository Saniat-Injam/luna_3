import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/notification_button_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.centerTitle = false,
    this.showBackButton = true,
    this.title = '',
    this.showNotification = false,
    this.actions,
    this.onClickBackButton,
  });

  final bool showBackButton;
  final void Function()? onClickBackButton;
  final bool centerTitle;
  final String title;
  final bool showNotification;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: Sizer.wp(20),
      title: Row(
        spacing: 10,
        children: [
          if (showBackButton)
            IconButton(
              onPressed:
                  onClickBackButton ??
                  () {
                    Get.back();
                  },
              icon: SvgPicture.asset(
                SvgPath.backArrowSvg,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.textTitle,
                  BlendMode.srcIn,
                ),
              ),
            ),

          Expanded(
            child: Text(
              title,
              style: AppTextStyle.f18W400().copyWith(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),

      actions: [
        if (actions != null) ...actions!,
        if (showNotification) NotificationButtonWidget(),
        SizedBox(width: Sizer.wp(16)),
      ],
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
