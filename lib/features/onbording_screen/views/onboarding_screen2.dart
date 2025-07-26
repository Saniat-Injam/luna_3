import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/responsive_helper.dart';
import 'package:barbell/features/onbording_screen/views/onboardin_screen3.dart';
import 'package:barbell/features/onbording_screen/views/onboarding_screen4.dart';
import '../controller/onboarding_controller.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import '../widgets/continue_button.dart';

class OnboardingScreen2 extends StatelessWidget {
  OnboardingScreen2({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final r = ResponsiveHelper(context);

  return Scaffold(
    body: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Obx(() => Image.asset(
                    controller.onboarding2.value.imagePath,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  )),

              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: r.fromSmallMediumLarge(small: size.height * 0.7, medium: size.height * 0.65, large: size.height * 0.6),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xE5000000),
                      ],
                    ),
                  ),
                ),
              ),

              // Skip Button
              Positioned(
                top: r.fromSmallMediumLarge(small: size.height * 0.05, medium: size.height * 0.06, large: size.height * 0.07),
                right: r.fromSmallMediumLarge(small: size.width * 0.05, medium: size.width * 0.06, large: size.width * 0.07),
                child: Obx(() => InkWell(
                      onTap: () {
                        Get.to(() => OnboardingScreen4());
                      },
                      child: Text(
                        controller.onboarding2.value.skipText,
                        style: getTextStyle1(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    )),
              ),

              // Title
              Positioned(
                bottom: r.fromSmallMediumLarge(small: size.height / 4.9, medium: size.height / 4.3, large: size.height / 6),
                right: r.fromSmallMediumLarge(small: size.width / 120, medium: size.width / 20, large: size.width / 100),
                child: Obx(() => Text(
                      controller.onboarding2.value.title,
                      style: GoogleFonts.workSans(
                        fontSize: 36,
                        height: 1.22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
              ),

              // Subtitle
              Positioned(
                bottom: r.fromSmallMediumLarge(small: size.height / 6.4, medium: size.height / 5.3, large: size.height / 8),
                left: r.fromSmallMediumLarge(small: size.width / 20, medium: size.width /10, large: size.width / 20),
                child: Obx(() {
                  final subtitle = controller.onboarding2.value.subtitle;
                  return subtitle == null
                      ? const SizedBox.shrink()
                      : Text(
                          subtitle,
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        );
                }),
              ),

              // Continue Button
              Positioned(
                bottom: r.fromSmallMediumLarge(small: size.height / 19, medium: size.height / 15, large: size.height / 22),
                right: r.fromSmallMediumLarge(small: size.width / 25, medium: size.width / 20, large: size.width / 18),
                child: ContinueButton(
                  onPressed: () {
                    Get.to(() => OnboardingScreen3());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}