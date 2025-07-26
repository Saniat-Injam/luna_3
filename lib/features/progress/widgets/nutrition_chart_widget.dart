import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/progress/widgets/charts/line_chart_widget.dart';
import 'package:barbell/features/progress/widgets/charts/bar_chart_widget.dart';
import 'package:barbell/features/progress/widgets/charts/pie_chart_widget.dart';

/// Main nutrition chart widget that displays different chart types
/// Switches between line, bar, and pie charts based on user selection
class NutritionChartWidget extends StatelessWidget {
  const NutritionChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ProgressController>();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(controller),
            const SizedBox(height: 16),
            _buildChartContent(controller),
          ],
        ),
      );
    });
  }

  /// Build chart header with title and nutrient info
  Widget _buildChartHeader(ProgressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${controller.selectedNutrient.value.capitalize} Chart',
              style: getTextStyleInter(
                color: AppColors.textTitle,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.getNutrientUnit(controller.selectedNutrient.value),
                style: getTextStyleInter(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _getChartDescription(controller),
          style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
        ),
      ],
    );
  }

  /// Build chart content based on selected chart type
  Widget _buildChartContent(ProgressController controller) {
    // Show loading state
    if (controller.isLoadingFoodSummary.value) {
      return _buildLoadingChart();
    }

    // Show error state
    if (controller.errorMessage.value.isNotEmpty) {
      return _buildErrorChart(controller);
    }

    // Show empty state if no data
    if (!controller.foodAnalysisSummary.value.hasData) {
      return _buildEmptyChart();
    }

    // Show appropriate chart based on selection
    switch (controller.selectedChartType.value) {
      case 0:
        return const NutritionLineChartWidget();
      case 1:
        return const NutritionBarChartWidget();
      case 2:
        return const NutritionPieChartWidget();
      default:
        return const NutritionLineChartWidget();
    }
  }

  /// Build loading state for chart
  Widget _buildLoadingChart() {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.secondary, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(
            'Loading chart data...',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build error state for chart
  Widget _buildErrorChart(ProgressController controller) {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            'Unable to load chart',
            style: getTextStyleInter(
              color: AppColors.textTitle,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to retry',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
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
    );
  }

  /// Build empty state for chart
  Widget _buildEmptyChart() {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart_outlined, color: AppColors.textSub, size: 48),
          const SizedBox(height: 16),
          Text(
            'No Data Available',
            style: getTextStyleInter(
              color: AppColors.textTitle,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging meals to see your nutrition trends',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Get chart description based on type and nutrient
  String _getChartDescription(ProgressController controller) {
    final chartTypeNames = ['Line Chart', 'Bar Chart', 'Pie Chart'];
    final chartTypeName = chartTypeNames[controller.selectedChartType.value];
    final nutrient = controller.selectedNutrient.value;
    final timeRange = controller.timeRangeText.toLowerCase();

    if (controller.selectedChartType.value == 2) {
      return '$chartTypeName showing $nutrient distribution by meal type over $timeRange';
    } else {
      return '$chartTypeName showing daily $nutrient intake over $timeRange';
    }
  }
}
