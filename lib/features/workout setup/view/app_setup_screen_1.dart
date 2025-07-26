import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout setup/widgets/button.dart';
import 'package:barbell/features/workout setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/model/app_setup_model1.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_2.dart';
import 'package:barbell/features/workout%20setup/widgets/workout_setup_button.dart';

class AppSetupScreen1 extends StatelessWidget {
  const AppSetupScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutSetupController = Get.find<WorkoutSetupController>();
    final progressController = Get.put(TopProgressController());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizer.wp(20),
            vertical: Sizer.hp(12),
          ),
          child: Column(
            children: [
              const TopProgress(),
              const Spacer(flex: 48),
              _buildTitle(context),
              const Spacer(flex: 32),
              _buildGoalOptions(workoutSetupController),
              const Spacer(flex: 100),
              _buildContinueButton(context, progressController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      appSetupModel.screenTitle,
      style: getTextStyle1(
        fontSize: Sizer.wp(26),
        color: AppColors.textWhite,
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: -0.30,
      ),
    );
  }

  Widget _buildGoalOptions(WorkoutSetupController controller) {
    return Column(
      children: List.generate(
        controller.fitnessGoals.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: Sizer.hp(20)),
          child: WorkoutSetupButton(
            workoutSetupController: controller,
            title: controller.fitnessGoals.values.elementAt(index),
            value: controller.fitnessGoals.keys.elementAt(index),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(
    BuildContext context,
    TopProgressController controller,
  ) {
    return Button(
      text: appSetupModel.continueButtonText,
      fontSize: Sizer.wp(18),
      alignment: Alignment.center,
      fontWeight: FontWeight.w500,
      backgroundColor: AppColors.appbar,
      textColor: AppColors.textWhite,
      selectedColor: AppColors.appbar,
      selectedTextColor: AppColors.textWhite,
      onPressed: () {
        controller.goToNextStep();
        Get.to(() => AppSetupScreen2());
      },
    );
  }
}
