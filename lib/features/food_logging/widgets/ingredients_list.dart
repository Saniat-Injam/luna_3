import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class IngredientsList extends StatelessWidget {
  const IngredientsList({super.key, required this.ingredients});
  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: getTextStyleWorkSans(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        _buildIngredientsList(),
      ],
    );
  }

  Widget _buildIngredientsList() {
    // final ingredients = [
    //   '900 g chicken legs',
    //   '240 g tomatoes',
    //   '75 g black olives, pitted',
    //   '2 tablespoon olive oil',
    //   '9 garlic cloves, sliced',
    //   '1 tablespoon dried oregano',
    //   '4 cups lettuce',
    //   '0.25 lemon, the zest',
    //   '0.5 cup mayonnaise',
    //   '1 teaspoon paprika powder',
    //   '0 salt and pepper',
    // ];

    return Column(
      children:
          ingredients.map((ingredient) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    ingredient,
                    style: getTextStyleWorkSans(
                      color: AppColors.textWhite,
                      lineHeight: 12.5,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
