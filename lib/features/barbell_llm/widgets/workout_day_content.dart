import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/barbell_llm/widgets/exercise_card.dart';

/// Workout day content widget that shows focus area and exercises
class WorkoutDayContent extends StatelessWidget {
  final WorkoutDay workoutDay;

  const WorkoutDayContent({super.key, required this.workoutDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Focus area header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary.withValues(alpha: 0.1),
                AppColors.accent.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.track_changes,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Focus Area',
                      style: getTextStyleWorkSans(
                        color: AppColors.textDescription,
                        fontSize: 14,
                        lineHeight: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      workoutDay.focus,
                      style: getTextStyleWorkSans(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Exercises list
        ...workoutDay.exercises.asMap().entries.map((entry) {
          return ExerciseCard(exercise: entry.value, index: entry.key);
        }),
      ],
    );
  }
}
