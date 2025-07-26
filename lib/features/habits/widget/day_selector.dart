import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/weekly_habits_controller.dart';

class DaySelector extends StatelessWidget {
  final WeeklyHabitsController controller;

  const DaySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: AppColors.appbar.withValues(alpha: 0.9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.appbar.withValues(alpha: 0.7),
              AppColors.appbar.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Your Days', style: AppTextStyle.f16W400()),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: controller.days.length,
              itemBuilder:
                  (context, index) =>
                      _buildDayButton(context, controller.days[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(BuildContext context, String day) {
    return Obx(() {
      final isSelected = controller.selectedDays.contains(day);
      return GestureDetector(
        onTap: () => controller.toggleDaySelection(day),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.secondary : Colors.transparent,
            border: Border.all(
              color:
                  isSelected
                      ? AppColors.secondary
                      : AppColors.textWhite.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: getTextStyleInter(
                color: isSelected ? AppColors.background : AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
              child: Text(day.substring(0, 3)),
            ),
          ),
        ),
      );
    });
  }
}
