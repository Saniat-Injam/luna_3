import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/workout setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout setup/widgets/button.dart';
import 'package:barbell/features/workout setup/widgets/diet_card.dart';
import 'package:barbell/features/workout setup/widgets/top_progress.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_7.dart';

class AppSetupScreen6 extends StatelessWidget {
  const AppSetupScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutSetupController = Get.put(WorkoutSetupController());
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            TopProgress(),
            SizedBox(height: MediaQuery.of(context).size.height / 25),
            Text(
              AppText.appsetup6Screentitle,
              style: getTextStyle1(
                fontSize: 28,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                DietCard(
                  title: 'Plant-Based',
                  value: 'plant_based',
                  subtitle: 'Vegan',
                  iconPath: IconPath.leaf,
                ),
                const SizedBox(width: 10),
                DietCard(
                  title: 'Carbo Diet',
                  value: 'carbo_diet',
                  subtitle: 'Bread, etc',
                  iconPath: IconPath.carbo,
                ),
              ],
            ).paddingOnly(left: MediaQuery.of(context).size.height / 25),
            const SizedBox(height: 10),
            Row(
              children: [
                DietCard(
                  title: 'Specialized',
                  value: 'specialized',
                  subtitle: 'Paleo, keto, etc',
                  iconPath: IconPath.specialized,
                ),
                const SizedBox(width: 10),
                DietCard(
                  title: 'Traditional',
                  value: 'traditional',
                  subtitle: 'Fruit diet',
                  iconPath: IconPath.fruit,
                ),
              ],
            ).paddingOnly(left: MediaQuery.of(context).size.height / 25),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed:
                        workoutSetupController.isAnySelected
                            ? () {
                              final setupController =
                                  Get.find<TopProgressController>();
                              setupController.goToNextStep();
                              Get.to(() => AppSetupScreen7());
                            }
                            : null,
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
            ),
          ],
        ),
      ),
    );
  }
}
