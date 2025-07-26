import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/barbell_llm/widgets/rest_day_content.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_day_content.dart';

/// Day card widget with expandable content for workout or rest days
class DayCard extends StatelessWidget {
  final String dayName;
  final WorkoutDay? workoutDay;
  final bool isRestDay;

  const DayCard({
    super.key,
    required this.dayName,
    required this.workoutDay,
    required this.isRestDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isRestDay
                  ? AppColors.textDescription.withValues(alpha: 0.2)
                  : AppColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.all(20),
          backgroundColor: AppColors.cardBackground,
          collapsedBackgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: _buildDayTitle(),
          children: [
            if (isRestDay)
              const RestDayContent()
            else
              WorkoutDayContent(workoutDay: workoutDay!),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTitle() {
    return Row(
      children: [
        // Day icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient:
                isRestDay
                    ? LinearGradient(
                      colors: [
                        AppColors.textDescription.withValues(alpha: 0.2),
                        AppColors.textDescription.withValues(alpha: 0.1),
                      ],
                    )
                    : LinearGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.3),
                        AppColors.accent.withValues(alpha: 0.2),
                      ],
                    ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isRestDay ? Icons.spa : Icons.fitness_center,
            color: isRestDay ? AppColors.textDescription : AppColors.secondary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),

        // Day info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayName,
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isRestDay ? 'Rest & Recovery Day' : workoutDay!.focus,
                style: getTextStyleWorkSans(
                  color: AppColors.textDescription,
                  fontSize: 11,
                  lineHeight: 12,
                ),
              ),
            ],
          ),
        ),

        // Exercise count or rest indicator
        if (!isRestDay)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${workoutDay!.exercises.length} exercises',
              style: getTextStyleWorkSans(
                color: AppColors.secondary,
                fontSize: 11,
                lineHeight: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
