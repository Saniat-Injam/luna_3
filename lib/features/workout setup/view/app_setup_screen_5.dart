import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_6.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/height_textfield.dart';

class AppSetupScreen5 extends StatelessWidget {
  const AppSetupScreen5({super.key});
  @override
  Widget build(BuildContext context) {
    final workoutController = Get.find<WorkoutSetupController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopProgress(),
            const SizedBox(height: 30),
            Text(
              AppText.appsetup5Screentitle,
              style: getTextStyle1(
                fontSize: 28,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 23),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,1
              children: [
                // FEET Field
                Expanded(
                  child: HeightTextfield(
                    labelText: "FEET",
                    hintText: "5.8",
                    controller: workoutController.feetController,
                    onChanged: (value) {
                      workoutController.updateHeight(
                        double.parse(value),
                        isFeet: true,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 20),

                // CM Field
                Expanded(
                  child: HeightTextfield(
                    labelText: "CM",
                    hintText: "166",
                    controller: workoutController.cmController,
                    onChanged: (value) {
                      workoutController.updateHeight(
                        double.parse(value),
                        isFeet: false,
                      );
                    },
                  ),
                ),
              ],
            ).paddingOnly(left: 20, right: 20),

            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    final setupController = Get.find<TopProgressController>();
                    setupController.goToNextStep(); // Increase progress
                    Get.to(() => AppSetupScreen6());
                  },
                  text: AppText.appsetup1Screenpoin6,
                  fontSize: 20,
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
    );
  }
}
