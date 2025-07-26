import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_8.dart';
import 'package:barbell/features/workout%20setup/widgets/exercise_card.dart';

class AppSetupScreen7 extends StatelessWidget {
  const AppSetupScreen7({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutSetupController = Get.find<WorkoutSetupController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopProgress(),
                SizedBox(height: Sizer.hp(20)),

                _buildTitleText(),
                SizedBox(height: Sizer.hp(20)),

                ..._buildCardRows(),

                // SizedBox(height: Sizer.hp(20)),
                Spacer(),

                _buildContinueButton(workoutSetupController),
                SizedBox(height: Sizer.hp(20)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueButton(WorkoutSetupController workoutSetupController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.appbar),
          foregroundColor: WidgetStatePropertyAll(AppColors.textWhite),

          fixedSize: WidgetStatePropertyAll(
            Size(double.maxFinite, Sizer.hp(8)),
          ),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onHover: (hovering) {
          if (hovering) {
            // Add hover effect if needed
          }
        },
        onFocusChange: (focused) {
          if (focused) {
            // Add focus effect if needed
          }
        },
        onLongPress: () {
          // Add long press effect if needed
        },
        onPressed: () {
          final setupController = Get.find<TopProgressController>();
          setupController.goToNextStep();
          Get.to(() => AppSetupScreen8());
        },
        child: Text(
          'Continue',
          style: AppTextStyle.f21W500().copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      AppText.appsetup7Screentitle,
      textAlign: TextAlign.center,
      style: AppTextStyle.f14W400().copyWith(
        fontSize: 24,
        color: AppColors.textWhite,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    );
  }

  List<Widget> _buildCardRows() {
    final workoutSetupController = Get.find<WorkoutSetupController>();
    List<Map<String, String>> data =
        workoutSetupController.exercisePreferenceData;
    if (workoutSetupController.rows.isEmpty) {
      for (int i = 0; i < data.length; i += 3) {
        workoutSetupController.rows.add(
          Row(
            children: [
              for (int j = 0; j < 3 && i + j < data.length; j++) ...[
                ExerciseCard(
                  index: i + j,
                  title: data[i + j]['title']!,
                  iconPath: data[i + j]['icon']!,
                ),
                if (j != 2 && i + j + 1 < data.length)
                  const SizedBox(width: 10),
              ],
            ],
          ).paddingOnly(left: 20, top: 10),
        );
      }
    }
    return workoutSetupController.rows;
  }
}
