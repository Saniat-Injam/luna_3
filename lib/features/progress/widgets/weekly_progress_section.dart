import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/progress/widgets/weekly_progress_chart.dart';

class WeeklyProgressSection extends StatelessWidget {
  final ProgressController controller;

  const WeeklyProgressSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2A2F37),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CALORIES',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'WEEKLY VIEW',
                style: getTextStyleWorkSans(
                  color: const Color(0xffA2A6AB),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final chartData = controller.weeklyData.toList();
              return WeeklyProgressChart(data: chartData);
            }),
          ),
        ],
      ),
    );
  }
}
