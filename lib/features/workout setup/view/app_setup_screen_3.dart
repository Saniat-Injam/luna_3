import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout%20setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_4.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/sliding_button.dart';
import 'package:barbell/features/workout%20setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/widgets/weight_slider.dart';

class AppSetupScreen3 extends StatelessWidget {
  const AppSetupScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            TopProgress(),
            const SizedBox(height: 30),
            Text(
              AppText.appsetup3Screentitle,
              style: getTextStyle1(
                fontSize: 28,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                //  lineHeight: 38 ,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 30),

            // Kilogram or Pound button
            SlidingButton(),

            SizedBox(height: Sizer.hp(10)),

            // Weight slider
            WeightSlider(),

            const Spacer(),

            // Continue button
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
                    Get.to(AppSetupScreen4());
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
