import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.width = double.infinity,
    this.height = 120,
  });

  // final Recipe recipe;
  final FoodCaloriesModel recipe;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.appbar,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Recipe Image
              Image.network(recipe.img ?? '', fit: BoxFit.cover),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Recipe Name in Center
              Center(
                child: Text(
                  recipe.name ?? '',
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Calories in Bottom Right
              Positioned(
                right: 10,
                bottom: 10,
                child: Text(
                  '${recipe.nutritionPerServing?.calories} Cal',
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
