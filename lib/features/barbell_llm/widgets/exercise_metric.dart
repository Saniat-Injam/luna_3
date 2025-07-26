import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Exercise metric widget that shows sets, reps, and rest time
class ExerciseMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const ExerciseMetric({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getTextStyleWorkSans(
              color: AppColors.textDescription,
              fontSize: 11,
              lineHeight: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
