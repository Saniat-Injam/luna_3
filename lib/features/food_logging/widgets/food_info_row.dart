import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';

class FoodInfoRow extends StatelessWidget {
  const FoodInfoRow({super.key, required this.foodItem});
  final FoodCaloriesModel foodItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildInfoItem('Servings: ${foodItem.servings ?? 0}'),
        const SizedBox(width: 16),
        _buildInfoItem('Time: ${foodItem.preparationTime ?? 0} Min'),
        const SizedBox(width: 16),
        _buildInfoItem(
          '${foodItem.nutritionPerServing?.calories?.toInt() ?? 0} Cal',
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.textWhite.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: getTextStyleWorkSans(color: AppColors.textWhite, fontSize: 14),
        ),
      ),
    );
  }
}
