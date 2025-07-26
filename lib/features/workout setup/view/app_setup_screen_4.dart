import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/workout setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout setup/widgets/button.dart';
import 'package:barbell/features/workout setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_5.dart';
import 'package:barbell/features/workout%20setup/widgets/age_arc_slider.dart';

class AppSetupScreen4 extends StatelessWidget {
  const AppSetupScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutController = Get.find<WorkoutSetupController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with back button and progress bar
            TopProgress(),
            const SizedBox(height: 30),

            // Title
            Text(
              AppText.appsetup4Screentitle,
              style: getTextStyle1(
                fontSize: 28,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                //  lineHeight: 38 ,
                letterSpacing: -0.3,
              ),
            ),

            // Main content area with slider
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Drag to adjust text
                  Positioned(
                    left: 20,
                    bottom: Sizer.hp(380),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          SvgPath.questionMarkSvg,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Drag to adjust',
                          style: getTextStyleWorkSans(
                            fontSize: 16,
                            color: Color(0xffD7D8D9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //---------------------- Age number ----------------------
                  Obx(() {
                    return Positioned(
                      right: 20,
                      bottom: 100,
                      child: Text(
                        workoutController.age.value.toString(),
                        // selectedAge.toInt().toString(),
                        style: getTextStyleWorkSans(
                          fontSize: 120,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w800,
                          lineHeight: 300,
                        ),
                      ),
                    );
                  }),

                  //---------------------- Your age is text ----------------------
                  Positioned(
                    right: 30,
                    bottom: 50,
                    child: Text(
                      'your age is',
                      style: getTextStyleWorkSans(
                        fontSize: 20,
                        color: Color(0xffD7D8D9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Arc Slider
                  Obx(() {
                    return Positioned(
                      left: -screenWidth * 0.05,
                      right: screenWidth * 0.08,
                      bottom: -screenHeight * 0.04,
                      top: screenHeight * 0.05,
                      child: AgeArcSlider(
                        initialAge: workoutController.age.value.toDouble(),
                        onChanged: (age) {
                          workoutController.age.value = age.toInt();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    final setupController = Get.find<TopProgressController>();
                    setupController.goToNextStep(); // Increase progress
                    Get.to(() => AppSetupScreen5());
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
