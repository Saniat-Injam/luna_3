import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

/// Widget for selecting time range for nutrition analysis
/// Allows users to choose between 7 days, 30 days, and yearly view
class TimeRangeSelectorWidget extends StatelessWidget {
  const TimeRangeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
      builder:
          (controller) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time Period',
                style: getTextStyleInter(
                  color: AppColors.textTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  children: [
                    _buildTimeRangeButton(controller, '7D', 'Last 7 Days', 7),
                    const SizedBox(width: 8),
                    _buildTimeRangeButton(
                      controller,
                      '30D',
                      'Last 30 Days',
                      30,
                    ),
                    const SizedBox(width: 8),
                    _buildTimeRangeButton(controller, '1Y', 'Last Year', 365),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  /// Build individual time range selection button
  Widget _buildTimeRangeButton(
    ProgressController controller,
    String label,
    String fullLabel,
    int days,
  ) {
    final bool isSelected = controller.selectedTimeRange.value == days;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTimeRange(days),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: getTextStyleInter(
                  color: isSelected ? AppColors.background : AppColors.textSub,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fullLabel,
                style: getTextStyleInter(
                  color: isSelected ? AppColors.background : AppColors.textSub,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
