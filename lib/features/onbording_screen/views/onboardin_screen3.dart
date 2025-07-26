import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/utils/constants/responsive_helper.dart';
import 'package:barbell/features/onbording_screen/views/onboarding_screen4.dart';
import '../controller/onboarding_controller.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import '../widgets/continue_button.dart';


class OnboardingScreen3 extends StatelessWidget {
  OnboardingScreen3({super.key});

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
                      controller.onboarding3.value.imagePath,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: r.fromSmallMediumLarge(
                    small: size.height * 0.7,
                    medium: size.height * 0.65,
                    large: size.height * 0.6,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xE5000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: r.fromSmallMediumLarge(
                    small: size.height * 0.05,
                    medium: size.height * 0.05,
                    large: size.height * 0.03,
                  ),
                  right: r.fromSmallMediumLarge(
                    small: size.width * 0.05,
                    medium: size.width * 0.05,
                    large: size.width * 0.03,
                  ),
                  child: Obx(() => InkWell(
                        onTap: () => Get.to(() => OnboardingScreen4()),
                        child: Text(
                          controller.onboarding3.value.skipText,
                          style: GoogleFonts.workSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      )),
                ),
                Positioned(
                  bottom: r.fromSmallMediumLarge(
                    small: size.height / 5.6,
                    medium: size.height / 4.3,
                    large: size.height / 6.5,
                  ),
                  left: r.fromSmallMediumLarge(
                    small: size.width / 13,
                    medium: size.width / 8,
                    large: size.width / 12,
                  ),
                  child: Obx(() => Text(
                        controller.onboarding3.value.title,
                        style: GoogleFonts.workSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      )),
                ),
                Positioned(
                  bottom: r.fromSmallMediumLarge(
                    small: size.height / 7.8,
                    medium: size.height / 5.3,
                    large: size.height / 7,
                  ),
                  left: r.fromSmallMediumLarge(
                    small: size.width / 20,
                    medium: size.width / 10,
                    large: size.width / 14,
                  ),
                  child: Obx(() {
                    final subtitle = controller.onboarding3.value.subtitle;
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
                Positioned(
                  bottom: r.fromSmallMediumLarge(
                    small: size.height / 25,
                    medium: size.height / 18,
                    large: size.height / 18,
                  ),
                  right: r.fromSmallMediumLarge(
                    small: size.width / 25,
                    medium: size.width / 20,
                    large: size.width / 18,
                  ),
                  child: ContinueButton(
                    onPressed: () => Get.to(() => OnboardingScreen4()),
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
