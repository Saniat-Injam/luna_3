import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/food_logging_controller.dart';

class NutritionProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const NutritionProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.textWhite,
  });

  @override
  Widget build(BuildContext context) {
    final FoodLoggingController controller = Get.find<FoodLoggingController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 6,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(3),
          ),
          child: AnimatedBuilder(
            animation: controller.progressBarAnimation,
            builder: (context, child) {
              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width:
                        (value.clamp(0.0, 1.0)) *
                        constraints.maxWidth *
                        controller.progressBarAnimation.value,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
