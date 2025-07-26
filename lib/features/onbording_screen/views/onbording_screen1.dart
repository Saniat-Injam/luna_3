import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/onbording_screen/controller/onboarding_controller.dart';
import 'package:barbell/features/onbording_screen/views/onboarding_screen2.dart';
import 'package:barbell/features/onbording_screen/widgets/continue_button.dart';

class OnboardingScreen1 extends StatelessWidget {
  OnboardingScreen1({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, -0.00),
            end: Alignment(0.50, 1.00),
            colors: [
              const Color(0x00111214),
              Color(0xFF111214),
              Color(0xFF111214),
            ],
          ),

          image: DecorationImage(
            image: AssetImage(controller.onboarding1.value.imagePath),
            fit: BoxFit.cover, // Ensure the image covers the entire container
          ),
          color: AppColors.backgroundDark, // Fallback color
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [const Color(0x00111214), const Color(0xFF111214)],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizer.wp(24),
                      vertical: Sizer.hp(42),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => LoginScreen());
                      },
                      child: Text(
                        controller.onboarding1.value.skipText,
                        style: getTextStyle1(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          lineHeight: 15,

                          color: AppColors.backgroundDark,
                        ),
                      ),
                    ),
                  ),
                ),

                Spacer(),

                Text(
                  "Personalized Fitness Plans",
                  style: AppTextStyle.f36W600(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Sizer.hp(12)),
                Text(
                  "Choose your own fitness journey with AI. 🏋️‍♀️",
                  style: AppTextStyle.f16W400().copyWith(
                    fontSize: Sizer.wp(16),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Sizer.hp(30)),
                ContinueButton(
                  onPressed: () {
                    Get.to(() => OnboardingScreen2());
                  },
                ),
                SizedBox(height: Sizer.hp(50)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
