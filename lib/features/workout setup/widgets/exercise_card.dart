// exercise_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class ExerciseCard extends StatelessWidget {
  final int index;
  final String title;
  final String iconPath;

  ExerciseCard({
    super.key,
    required this.index,
    required this.title,
    required this.iconPath,
  });

  final controller = Get.find<WorkoutSetupController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected =
          controller.exercisePreferenceSelectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.selectCard(index),
        child: Container(
          height: MediaQuery.of(context).size.height / 6.5,
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: BoxDecoration(
            color: AppColors.appbar,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.appbar,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter:
                    isSelected
                        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                        : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.dst,
                        ),
                child: Image.asset(
                  iconPath,
                  height: 46.88,
                  width: 46.88,
                  color: isSelected ? Colors.white : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: getTextStyle1(
                  fontSize: 16,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
