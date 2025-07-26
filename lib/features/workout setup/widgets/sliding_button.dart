import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class SlidingButton extends StatelessWidget {
  const SlidingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSetupController>();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      return GestureDetector(
        onTap: controller.toggleUnit,
        child: Container(
          height: height / 19,
          width: width / 1.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: AppColors.appbar,
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: controller.isKgSelected.value ? 5 : width / 3.3,
                top: 3,
                bottom: 3,
                width: width / 3.3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: AppColors.secondary,
                  ),
                  child: Center(
                    child: Text(
                      controller.currentUnit,
                      style: getTextStyle1(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: controller.isKgSelected.value ? 0 : 1,
                        child: Text(
                          AppText.appsetup3Screenkg,
                          style: getTextStyle1(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: controller.isKgSelected.value ? 1 : 0,
                        child: Text(
                          AppText.appsetup3Screenlb,
                          style: getTextStyle1(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
