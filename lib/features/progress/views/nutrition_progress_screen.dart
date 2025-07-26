import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/progress/widgets/nutrition_chart_widget.dart';
import 'package:barbell/features/progress/widgets/nutrition_summary_widget.dart';
import 'package:barbell/features/progress/widgets/time_range_selector_widget.dart';

/// Screen to display nutrition progress with charts and analytics
/// Shows food analysis data in various visual formats
class NutritionProgressScreen extends StatelessWidget {
  const NutritionProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ProgressController is initialized
    Get.put(ProgressController());

    return GetBuilder<ProgressController>(
      builder:
          (controller) => Scaffold(
            appBar: AppBarWidget(
              title: "Nutrition Progress",
              showNotification: true,
              showBackButton: false,
              centerTitle: true,
            ),
            body: RefreshIndicator(
              color: AppColors.secondary,
              backgroundColor: AppColors.cardBackground,
              onRefresh: () => controller.refreshAllData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time range selector
                    const TimeRangeSelectorWidget(),
                    const SizedBox(height: 20),

                    // Nutrition summary cards
                    const NutritionSummaryWidget(),
                    const SizedBox(height: 24),

                    // Chart section
                    _buildChartSection(controller),
                    const SizedBox(height: 24),

                    // Nutrient filter section
                    _buildNutrientFilterSection(controller),
                    const SizedBox(height: 24),

                    // Chart type selector
                    _buildChartTypeSelector(controller),
                    const SizedBox(height: 24),

                    // Main chart display
                    const NutritionChartWidget(),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  /// Build chart section header with nutrient selector
  Widget _buildChartSection(ProgressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Progress Chart',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your daily nutrition intake over ${controller.timeRangeText.toLowerCase()}',
          style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
        ),
      ],
    );
  }

  /// Build nutrient filter chips section
  Widget _buildNutrientFilterSection(ProgressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Nutrients',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ['calories', 'protein', 'carbs', 'fats']
                    .map(
                      (nutrient) => _buildNutrientChip(
                        nutrient,
                        controller.selectedNutrient.value == nutrient,
                        () => controller.changeSelectedNutrient(nutrient),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  /// Build individual nutrient filter chip
  Widget _buildNutrientChip(
    String nutrient,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          nutrient.capitalize!,
          style: getTextStyleInter(
            color: isSelected ? Colors.black : AppColors.textSub,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Build chart type selector
  Widget _buildChartTypeSelector(ProgressController controller) {
    final chartTypes = [
      {'icon': Icons.show_chart, 'label': 'Line'},
      {'icon': Icons.bar_chart, 'label': 'Bar'},
      {'icon': Icons.pie_chart, 'label': 'Pie'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chart Type',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            children:
                chartTypes
                    .asMap()
                    .entries
                    .map(
                      (entry) => Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeChartType(entry.key),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: entry.key < chartTypes.length - 1 ? 8 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  controller.selectedChartType.value ==
                                          entry.key
                                      ? AppColors.secondary
                                      : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    controller.selectedChartType.value ==
                                            entry.key
                                        ? AppColors.secondary
                                        : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  entry.value['icon'] as IconData,
                                  color:
                                      controller.selectedChartType.value ==
                                              entry.key
                                          ? Colors.black
                                          : AppColors.textSub,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value['label'] as String,
                                  style: getTextStyleInter(
                                    color:
                                        controller.selectedChartType.value ==
                                                entry.key
                                            ? Colors.black
                                            : AppColors.textSub,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
