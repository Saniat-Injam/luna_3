import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/food_logging/models/food_analysis_summary_model.dart';
import 'package:barbell/features/food_logging/widgets/nutrition_progress_bar.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';
import 'package:barbell/features/home/widgets/custom_circular_progress.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key, this.analysisSummary});

  final FoodAnalysisSummary? analysisSummary;

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final targetGoal = profileController.profileModel?.workoutSetup;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 4, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - Nutrition information
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNutritionRow(
                  analysisSummary?.totalCalories
                          .toStringAsFixed(1)
                          .toString() ??
                      '0',
                  targetGoal?.calorieGoal.toStringAsFixed(1).toString() ?? '0',
                  'Calories',
                  // 1.0,
                  _getPercent(
                    analysisSummary?.totalCalories,
                    targetGoal?.calorieGoal,
                  ),
                ),

                const SizedBox(height: 16),
                _buildNutritionRow(
                  analysisSummary?.totalFats.toStringAsFixed(1) ?? '0',
                  targetGoal?.fatsGoal.toStringAsFixed(1) ?? '0',
                  'Fats',
                  _getPercent(analysisSummary?.totalFats, targetGoal?.fatsGoal),
                ),

                const SizedBox(height: 16),
                _buildNutritionRow(
                  analysisSummary?.totalProtein.toStringAsFixed(1) ?? '0',
                  targetGoal?.proteinGoal.toInt().toStringAsFixed(1) ?? '0',
                  'Proteins',
                  _getPercent(
                    analysisSummary?.totalProtein,
                    targetGoal?.proteinGoal,
                  ),
                ),

                const SizedBox(height: 16),
                _buildNutritionRow(
                  analysisSummary?.totalCarbs.toStringAsFixed(1) ?? '0',
                  targetGoal?.carbsGoal.toInt().toStringAsFixed(1) ?? '0',
                  'Carbs',
                  _getPercent(
                    analysisSummary?.totalCarbs,
                    targetGoal?.carbsGoal,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Right side - Circular progress
          Flexible(
            flex: 2,
            child: CustomCircularProgress(
              percentage:
                  _getPercent(
                    analysisSummary?.totalCarbs,
                    targetGoal?.carbsGoal,
                  ) *
                  100,
              animation: Get.find<HomeController>().progressAnimation,
              size: 150,
              textSize: 10,
              percentageSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(
    String value,
    String maxValue,
    String label,
    double progress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '$value / $maxValue',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        NutritionProgressBar(value: progress, color: AppColors.secondary),
      ],
    );
  }

  double _getPercent(num? current, num? target) {
    if (current == null || target == null || target == 0) return 0.0;
    final percent = current / target;
    if (percent.isNaN || percent.isInfinite) return 0.0;
    if (percent < 0 || percent.isInfinite) return 0.0;
    if (percent > 100) return 100;
    AppLoggerHelper.debug("========> $percent");
    return percent.clamp(0.0, 1.0).toDouble();
  }
}
