import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/home/widgets/nutrition_stats.dart';

class NutritionStatsGrid extends StatelessWidget {
  final ProgressController controller;

  const NutritionStatsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => NutritionStats(
            value: '${controller.calories.value}',
            label: 'CALORIES',
          ),
        ),
        Obx(
          () =>
              NutritionStats(value: '${controller.fats.value}g', label: 'FATS'),
        ),
        Obx(
          () => NutritionStats(
            value: '${controller.proteins.value}g',
            label: 'PROTEINS',
          ),
        ),
        Obx(
          () => NutritionStats(
            value: '${controller.carbs.value}g',
            label: 'CARBS',
          ),
        ),
      ],
    );
  }
}
