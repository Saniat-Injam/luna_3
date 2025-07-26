import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

/// Dynamic workout day card that displays workout data from API response
class WorkoutDayCardDynamic extends StatelessWidget {
  final WorkoutDay workoutDay;

  const WorkoutDayCardDynamic({super.key, required this.workoutDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with day and focus
          Row(
            children: [
              SvgPicture.asset(
                SvgPath.calendarbuttonSvg,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutDay.day,
                      style: getTextStyleWorkSans(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      workoutDay.focus,
                      style: getTextStyleWorkSans(
                        color: AppColors.textDescription,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Exercise list - show all exercises
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    workoutDay.exercises.map((exercise) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.5),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Exercise name
                            Text(
                              exercise.name,
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Exercise details
                            Row(
                              children: [
                                // Sets
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sets',
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textDescription,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        exercise.sets,
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Reps
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reps',
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textDescription,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        exercise.reps,
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // Rest
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rest',
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textDescription,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${exercise.restPeriodMinutes}m',
                                        style: getTextStyleWorkSans(
                                          color: AppColors.textWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          // Exercise count at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${workoutDay.exercises.length} exercises',
              style: getTextStyleWorkSans(
                color: AppColors.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
