import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_9.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/calorie_screen.dart';
import 'package:barbell/features/workout%20setup/widgets/macro_goal_slider.dart';
import 'package:barbell/features/workout%20setup/widgets/top_progress.dart';

class AppSetupScreen8 extends StatelessWidget {
  const AppSetupScreen8({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutController = Get.find<WorkoutSetupController>();
    final double itemWidth =
        (MediaQuery.of(context).size.width - 48) /
        2; // 16 padding on each side, 16 spacing

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView to prevent overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopProgress(),
                const SizedBox(height: 24),
                Text(
                  AppText.appsetup8Screentitle,
                  textAlign: TextAlign.center,
                  style: getTextStyle1(
                    fontSize: 24, // smaller
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                CalorieScreen(),
                const SizedBox(height: 24),
                // Macro goal sliders in a Wrap
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    MacroGoalSlider(
                      width: itemWidth,
                      label: 'Protein',
                      valueRx: workoutController.proteinGoal,
                      min: workoutController.minProtein,
                      max: workoutController.maxProtein,
                      barColor: AppColors.primary,
                      onChanged: workoutController.updateProtein,
                    ),
                    MacroGoalSlider(
                      width: itemWidth,
                      label: 'Carbs',
                      valueRx: workoutController.carbsGoal,
                      min: workoutController.minCarbs,
                      max: workoutController.maxCarbs,
                      barColor: AppColors.secondary,
                      onChanged: workoutController.updateCarbs,
                    ),
                    MacroGoalSlider(
                      width: itemWidth,
                      label: 'Fats',
                      valueRx: workoutController.fatsGoal,
                      min: workoutController.minFats,
                      max: workoutController.maxFats,
                      barColor: Colors.yellowAccent,
                      onChanged: workoutController.updateFats,
                    ),
                    MacroGoalSlider(
                      width: itemWidth,
                      label: 'Fiber',
                      valueRx: workoutController.fiberGoal,
                      min: workoutController.minFiber,
                      max: workoutController.maxFiber,
                      barColor: Colors.greenAccent,
                      onChanged: workoutController.updateFiber,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ), // Added spacing to avoid tight layout
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20, // reduced padding
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Button(
                      onPressed: () {
                        final setupController =
                            Get.find<TopProgressController>();
                        setupController.goToNextStep(); // Increase progress
                        Get.to(() => SleepQualityScreen());
                      },
                      text: AppText.appsetup1Screenpoin6,
                      fontSize: 18, // smaller
                      alignment: Alignment.center,
                      fontWeight: FontWeight.w500,
                      backgroundColor: AppColors.appbar,
                      textColor: AppColors.textWhite,
                      selectedColor: AppColors.appbar,
                      selectedTextColor: AppColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
