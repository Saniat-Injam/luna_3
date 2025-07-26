import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/models/food_item.dart';

class FoodScanDetailsScreen extends StatelessWidget {
  static const routeName = '/food-scan-details';
  final FoodItem foodItem;

  const FoodScanDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Scanned Food',
                showBackButton: true,
                showNotification: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Name and Brand Field
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.appbar,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              foodItem.name,
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 18,
                              ),
                            ),
                            if (foodItem.brand.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Brand',
                                style: getTextStyleWorkSans(
                                  color: AppColors.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                foodItem.brand,
                                style: getTextStyleWorkSans(
                                  color: AppColors.textWhite,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quantity and Serving Size Row
                      Row(
                        children: [
                          // Quantity
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.appbar,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: getTextStyleWorkSans(
                                      color: AppColors.textWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '1',
                                    style: getTextStyleWorkSans(
                                      color: AppColors.textWhite,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Serving Size
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.appbar,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Serving size',
                                    style: getTextStyleWorkSans(
                                      color: AppColors.textWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${foodItem.servingSize} ${foodItem.servingUnit} (${(foodItem.servingSize * 0.035274).toStringAsFixed(2)} oz)',
                                    style: getTextStyleWorkSans(
                                      color: AppColors.textWhite,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Nutrition Information
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.appbar,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutrition Information',
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Per ${foodItem.servingSize} ${foodItem.servingUnit}',
                              style: getTextStyleWorkSans(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildNutrientRow(
                              'Energy',
                              '${foodItem.calories.toStringAsFixed(0)} Cal',
                            ),
                            _buildNutrientRow(
                              'Carbs',
                              '${foodItem.carbs.toStringAsFixed(1)} g',
                            ),
                            _buildNutrientRow(
                              'Protein',
                              '${foodItem.protein.toStringAsFixed(1)} g',
                            ),
                            _buildNutrientRow(
                              'Fat',
                              '${foodItem.fat.toStringAsFixed(1)} g',
                            ),
                            _buildNutrientRow(
                              'Fiber',
                              '${foodItem.fiber.toStringAsFixed(1)} g',
                            ),
                            _buildNutrientRow(
                              'Net carbs',
                              '${(foodItem.carbs - foodItem.fiber).toStringAsFixed(1)} g',
                            ),
                          ],
                        ),
                      ),

                      if (foodItem.ingredients.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        // Ingredients
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.appbar,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredients',
                                style: getTextStyleWorkSans(
                                  color: AppColors.textWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                foodItem.ingredients,
                                style: getTextStyleWorkSans(
                                  color: AppColors.textWhite,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Track Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(result: foodItem);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Track',
                    style: getTextStyleWorkSans(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
