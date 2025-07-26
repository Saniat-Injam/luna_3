import 'package:flutter/material.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class NutritionStatCard extends StatelessWidget {
  final int value;
  final String label;
  final String unit;

  const NutritionStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$value${unit.isNotEmpty ? unit : ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
