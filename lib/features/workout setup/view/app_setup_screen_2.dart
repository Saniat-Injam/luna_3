import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/core/utils/constants/image_path.dart';
import 'package:barbell/core/utils/constants/responsive_helper.dart';
import 'package:barbell/features/workout%20setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/widgets/gender_card.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_3.dart';

class AppSetupScreen2 extends StatelessWidget {
  AppSetupScreen2({super.key});

  final progressController = Get.put(TopProgressController());
  final controller = Get.put(WorkoutSetupController());

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: r.fromSmallMediumLarge(
              small: 16,
              medium: 20,
              large: 24,
            ),
          ),
          child: Column(
            children: [
              // 🔝 Top step progress bar
              TopProgress(),

              SizedBox(
                height: r.fromSmallMediumLarge(
                  small: r.size.height / 30,
                  medium: r.size.height * 0.03,
                  large: r.size.height * 0.04,
                ),
              ),

              // 📝 Title
              Text(
                AppText.appsetup2Screentitle,
                style: getTextStyle1(
                  fontSize: r.fromSmallMediumLarge(
                    small: 24,
                    medium: 28,
                    large: 30,
                  ),
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                  letterSpacing: -0.30,
                ),
              ),

              SizedBox(
                height: r.fromSmallMediumLarge(
                  small: r.size.height / 20,
                  medium: r.size.height * 0.025,
                  large: r.size.height * 0.035,
                ),
              ),

              // 👨‍🦰👩 Gender selection cards
              Obx(
                () => Column(
                  children: [
                    GenderCard(
                      iconPath: IconPath.maleicon,
                      text: 'Male',
                      imagePath: ImagePath.malegender,
                      isSelected: controller.selectedGender.value == 'male',
                      onTap: () => controller.selectGender('male'),
                      iconTextRowPadding: EdgeInsets.only(
                        right: r.fromSmallMediumLarge(
                          small: 100,
                          medium: 110,
                          large: 160,
                        ),
                        top: 20,
                      ),
                      checkboxPadding: EdgeInsets.only(
                        top: 55,
                        right: r.fromSmallMediumLarge(
                          small: 100,
                          medium: 160,
                          large: 190,
                        ),
                      ),
                      imagePadding: const EdgeInsets.only(right: 10),
                    ),
                    SizedBox(height: r.size.height * 0.025),
                    GenderCard(
                      iconPath: IconPath.femaleicon,
                      text: 'Female',
                      imagePath: ImagePath.femalegender,
                      isSelected: controller.selectedGender.value == 'female',
                      onTap: () => controller.selectGender('female'),
                      iconTextRowPadding: EdgeInsets.only(
                        right: r.fromSmallMediumLarge(
                          small: 80,
                          medium: 90,
                          large: 140,
                        ),
                        top: 20,
                      ),
                      checkboxPadding: EdgeInsets.only(
                        top: 55,
                        right: r.fromSmallMediumLarge(
                          small: 110,
                          medium: 160,
                          large: 190,
                        ),
                      ),
                      imagePadding: const EdgeInsets.only(right: 10),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ✅ Continue Button with responsive padding
              Padding(
                padding: EdgeInsets.only(
                  bottom: r.fromSmallMediumLarge(
                    small: 20,
                    medium: 30,
                    large: 40,
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => Button(
                      onPressed:
                          controller.selectedGender.value.isEmpty
                              ? null
                              : () {
                                final setupController =
                                    Get.find<TopProgressController>();
                                setupController.goToNextStep();
                                Get.to(AppSetupScreen3());
                              },
                      text: AppText.appsetup1Screenpoin6,
                      fontSize: r.fromSmallMediumLarge(
                        small: 16,
                        medium: 18,
                        large: 20,
                      ),
                      alignment: Alignment.center,
                      fontWeight: FontWeight.w500,
                      backgroundColor: AppColors.appbar,
                      textColor: AppColors.textWhite,
                      selectedColor: AppColors.appbar,
                      selectedTextColor: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
