import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/workout%20setup/controller/top_progress_controller.dart';

class TopProgress extends StatelessWidget {
  const TopProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final setupController = Get.find<TopProgressController>();

    return Row(
      children: [
        // Back Button
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary, size: 30),
          onPressed: () {
            Get.back(); // Go to previous screen
            setupController.goToPreviousStep(); // Decrease step count
          },
        ),

        const SizedBox(width: 8),

        // Progress Bar
        Expanded(
          child: SizedBox(
            height: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () => LinearProgressBar(
                  maxSteps: 7, // or total number of screens
                  currentStep: setupController.currentStep.value,
                  progressType: LinearProgressBar.progressTypeLinear,
                  progressColor: AppColors.secondary,
                  backgroundColor: AppColors.progressbar,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Logout button
        TextButton(
          onPressed: () {
            StorageService.clearAllDataFromStorage();
            Get.offAll(() => const LoginScreen());
          },
          child: Icon(Icons.logout, size: 30, color: AppColors.secondary),
        ).paddingOnly(right: 8),
      ],
    );
  }
}
