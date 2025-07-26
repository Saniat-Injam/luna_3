import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class DietCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String iconPath;

  const DietCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSetupController>();
    return Obx(() {
      final isSelected = controller.isSelectedDiet(value);
      return GestureDetector(
        onTap: () => controller.selectDiet(value),
        child: Container(
          height: MediaQuery.of(context).size.height / 4.6,
          width: MediaQuery.of(context).size.width / 2.4,
          decoration: BoxDecoration(
            color: AppColors.appbar,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle1(
                  fontSize: 15.53,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: getTextStyle1(
                  fontSize: 16,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Image.asset(
                iconPath,
                height: MediaQuery.of(context).size.height / 16,
                width: MediaQuery.of(context).size.width / 16,
              ).paddingOnly(
                left: MediaQuery.of(context).size.width / 3.5,
                top: MediaQuery.of(context).size.height / 14,
              ),
            ],
          ).paddingOnly(
            left: MediaQuery.of(context).size.width / 30,
            top: MediaQuery.of(context).size.height / 40,
          ),
        ),
      );
    });
  }
}
