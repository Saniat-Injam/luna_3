import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';

class ShowUpdatePlanDialog extends StatelessWidget {
  final BarbellLLMController controller;

  const ShowUpdatePlanDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Update Workout Plan',
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Please provide feedback on how you\'d like to modify your workout plan:',
              style: getTextStyleWorkSans(
                color: AppColors.textDescription,
                fontSize: 14,
                lineHeight: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Text Field
            TextField(
              controller: controller.feedbackController,
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 16,
              ),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., "On Monday I want to perform legs"',
                hintStyle: getTextStyleWorkSans(
                  color: AppColors.textDescription,
                  fontSize: 14,
                  lineHeight: 14,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: getTextStyleWorkSans(
                      color: AppColors.textDescription,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final feedback = controller.feedbackController.text.trim();
                    if (feedback.isNotEmpty) {
                      // Close dialog first
                      Get.back();

                      // Small delay to ensure dialog is closed before starting API call
                      await Future.delayed(const Duration(milliseconds: 100));

                      // Then call the update method
                      controller.updateWorkoutPlan(feedback);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: getTextStyleWorkSans(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
