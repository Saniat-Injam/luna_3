import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class NutritionStats extends StatelessWidget {
  final String value;
  final String label;
  final Color textColor;

  const NutritionStats({
    super.key,
    required this.value,
    required this.label,
    this.textColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: .52),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: getTextStyle(
              color: AppColors.textSub,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
