import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/barbell_llm/widgets/exercise_metric.dart';

/// Exercise card widget that displays individual exercise details
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int index;

  const ExerciseCard({super.key, required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: getTextStyleWorkSans(
                      color: AppColors.accent,
                      fontSize: 14,
                      lineHeight: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exercise.name,
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    lineHeight: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Exercise metrics
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ExerciseMetric(
                  icon: Icons.repeat,
                  label: 'Sets',
                  value: exercise.sets,
                  color: AppColors.secondary,
                ),
                ExerciseMetric(
                  icon: Icons.fitness_center,
                  label: 'Reps',
                  value: exercise.reps,
                  color: const Color.fromARGB(255, 102, 159, 233),
                ),
                ExerciseMetric(
                  icon: Icons.timer,
                  label: 'Rest',
                  value: '${exercise.restPeriodMinutes}m',
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
