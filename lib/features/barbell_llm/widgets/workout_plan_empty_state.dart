import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Empty state widget shown when no workout plan is available
class WorkoutPlanEmptyState extends StatelessWidget {
  const WorkoutPlanEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.fitness_center,
              size: 40,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Workout Plan Available',
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 20,
              lineHeight: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Generate your personalized workout plan to get started with your fitness journey.',
            textAlign: TextAlign.center,
            style: getTextStyleWorkSans(
              color: AppColors.textDescription,
              fontSize: 14,
              lineHeight: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Generate Plan',
              style: getTextStyleWorkSans(
                color: Colors.black,
                fontSize: 16,
                lineHeight: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
