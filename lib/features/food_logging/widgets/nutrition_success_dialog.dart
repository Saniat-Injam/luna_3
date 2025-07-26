import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class NutritionSuccessDialog extends StatelessWidget {
  final Map<String, dynamic> nutritionData;
  final String consumedAs;
  final int servings;

  const NutritionSuccessDialog({
    super.key,
    required this.nutritionData,
    required this.consumedAs,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    final nutrition = nutritionData['nutritionPerServing'] ?? {};

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with success icon
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: AppColors.background,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Food Added Successfully!',
                    style: TextStyle(
                      color: AppColors.textTitle,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Added to ${consumedAs.capitalize}',
                    style: TextStyle(
                      color: AppColors.textDescription,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Nutrition Information
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    'Nutrition Information',
                    style: TextStyle(
                      color: AppColors.textTitle,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Servings
                  _buildNutritionRow(
                    icon: Icons.restaurant,
                    label: 'Servings',
                    value: servings.toString(),
                    unit: '',
                    color: AppColors.secondary,
                  ),

                  // Calories
                  _buildNutritionRow(
                    icon: Icons.local_fire_department,
                    label: 'Calories',
                    value: (nutrition['calories'] ?? 0).toString(),
                    unit: 'kcal',
                    color: Colors.orange,
                  ),

                  // Protein
                  _buildNutritionRow(
                    icon: Icons.fitness_center,
                    label: 'Protein',
                    value: (nutrition['protein'] ?? 0).toString(),
                    unit: 'g',
                    color: Colors.red,
                  ),

                  // Carbs
                  _buildNutritionRow(
                    icon: Icons.grain,
                    label: 'Carbs',
                    value: (nutrition['carbs'] ?? 0).toString(),
                    unit: 'g',
                    color: Colors.blue,
                  ),

                  // Fats
                  _buildNutritionRow(
                    icon: Icons.opacity,
                    label: 'Fats',
                    value: (nutrition['fats'] ?? 0).toString(),
                    unit: 'g',
                    color: Colors.purple,
                  ),

                  // Fiber
                  _buildNutritionRow(
                    icon: Icons.eco,
                    label: 'Fiber',
                    value: (nutrition['fiber'] ?? 0).toString(),
                    unit: 'g',
                    color: Colors.green,
                  ),

                  SizedBox(height: 20.h),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.background,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),

          SizedBox(width: 12.w),

          // Label
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textTitle,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Value
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              '$value $unit',
              style: TextStyle(
                color: AppColors.textTitle,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
