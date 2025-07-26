import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

/// Widget to display nutrition summary cards
/// Shows total and average values for calories, protein, carbs, and fats
class NutritionSummaryWidget extends StatelessWidget {
  const NutritionSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
      builder:
          (controller) => Obx(() {
            // Show loading state
            if (controller.isLoadingFoodSummary.value) {
              return _buildLoadingState();
            }

            // Show error state
            if (controller.errorMessage.value.isNotEmpty) {
              return _buildErrorState(controller);
            }

            // Show data if available
            if (controller.foodAnalysisSummary.value.hasData) {
              return _buildSummaryCards(controller);
            }

            // Show empty state
            return _buildEmptyState();
          }),
    );
  }

  /// Build loading shimmer effect
  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Summary',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: 4,
          itemBuilder:
              (context, index) => Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 2,
                  ),
                ),
              ),
        ),
      ],
    );
  }

  /// Build error state
  Widget _buildErrorState(ProgressController controller) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text(
                'Failed to Load Data',
                style: getTextStyleInter(
                  color: AppColors.textTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: getTextStyleInter(
                  color: AppColors.textSub,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () => controller.loadFoodAnalysisSummary(isRefresh: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.background,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.data_usage_outlined, color: AppColors.textSub, size: 48),
          const SizedBox(height: 16),
          Text(
            'No Nutrition Data',
            style: getTextStyleInter(
              color: AppColors.textTitle,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging your meals to see nutrition insights here',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build nutrition summary cards with data
  Widget _buildSummaryCards(ProgressController controller) {
    final summary = controller.foodAnalysisSummary.value;
    final days = controller.selectedTimeRange.value;

    final nutritionData = [
      {
        'title': 'Calories',
        'total': summary.total.totalCalories,
        'average': summary.total.getAverageDailyCalories(days),
        'unit': 'kcal',
        'color': AppColors.error,
        'icon': Icons.local_fire_department,
      },
      {
        'title': 'Protein',
        'total': summary.total.totalProtein,
        'average': summary.total.getAverageDailyProtein(days),
        'unit': 'g',
        'color': AppColors.accent,
        'icon': Icons.fitness_center,
      },
      {
        'title': 'Carbs',
        'total': summary.total.totalCarbs,
        'average': summary.total.getAverageDailyCarbs(days),
        'unit': 'g',
        'color': AppColors.warning,
        'icon': Icons.grain,
      },
      {
        'title': 'Fats',
        'total': summary.total.totalFats,
        'average': summary.total.getAverageDailyFats(days),
        'unit': 'g',
        'color': AppColors.success,
        'icon': Icons.opacity,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nutrition Summary',
              style: getTextStyleInter(
                color: AppColors.textTitle,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              controller.timeRangeText,
              style: getTextStyleInter(
                color: AppColors.textSub,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: nutritionData.length,
          itemBuilder: (context, index) {
            final data = nutritionData[index];
            return _buildNutritionCard(data);
          },
        ),
      ],
    );
  }

  /// Build individual nutrition card
  Widget _buildNutritionCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (data['color'] as Color).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                data['icon'] as IconData,
                color: data['color'] as Color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data['title'] as String,
                  style: getTextStyleInter(
                    color: AppColors.textSub,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${(data['total'] as double).toStringAsFixed(0)} ${data['unit']}',
            style: getTextStyleInter(
              color: AppColors.textTitle,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Avg: ${(data['average'] as double).toStringAsFixed(1)} ${data['unit']}/day',
            style: getTextStyleInter(
              color: AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
