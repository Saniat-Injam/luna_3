import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';
import 'package:barbell/features/barbell_llm/widgets/update_plan_dialog.dart';

/// Action buttons widget for save and update plan functionality
class WorkoutPlanActionButtons extends StatelessWidget {
  final BarbellLLMController controller;

  const WorkoutPlanActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action buttons row
            Row(
              children: [
                // Save Plan Button
                Expanded(child: _buildSaveButton()),
                const SizedBox(width: 16),
                // Update Plan Button
                Expanded(child: _buildUpdateButton()),
              ],
            ),
            const SizedBox(height: 12),

            // Help text
            Text(
              'Save your plan to access it anytime or update with new preferences',
              textAlign: TextAlign.center,
              style: getTextStyleWorkSans(
                color: AppColors.textDescription,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                lineHeight: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.secondary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value ? null : controller.saveWorkoutPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child:
              controller.isLoading.value
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Plan',
                        style: getTextStyleWorkSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary, width: 1.5),
      ),
      child: OutlinedButton(
        onPressed:
            () => Get.dialog(ShowUpdatePlanDialog(controller: controller)),
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Update Plan',
              style: getTextStyleWorkSans(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
