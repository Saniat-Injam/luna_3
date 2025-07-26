import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class WorkoutSetupButton extends StatelessWidget {
  const WorkoutSetupButton({
    super.key,
    required this.workoutSetupController,
    required this.title,
    required this.value,
  });

  final WorkoutSetupController workoutSetupController;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ElevatedButton(
        onPressed: () {
          workoutSetupController.selectFitnessGoal(value);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              workoutSetupController.selectedFitnessGoal.value == value
                  ? AppColors.secondary
                  : AppColors.appbar,
          foregroundColor:
              workoutSetupController.selectedFitnessGoal.value == value
                  ? AppColors.surfaceDark
                  : AppColors.textWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          fixedSize: Size.fromWidth(double.maxFinite),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: getTextStyle1(
              fontSize: Sizer.wp(16),
              color:
                  workoutSetupController.selectedFitnessGoal.value == value
                      ? AppColors.surfaceDark
                      : AppColors.textWhite,
              fontWeight: FontWeight.w500,
              height: 1.27,
              letterSpacing: 1,
            ),
          ),
        ),
      );
    });
  }
}
