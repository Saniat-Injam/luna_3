import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

/// Professional workout plan header that combines schedule overview with user instructions
class WorkoutPlanHeader extends StatelessWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutPlanHeader({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          // Header section with workout overview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(
                  SvgPath.calendarSvg,
                  colorFilter: ColorFilter.mode(
                    AppColors.secondary,
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Weekly Schedule',
                        style: getTextStyleWorkSans(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          lineHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${workoutPlan.plan.length} workout days • ${7 - workoutPlan.plan.length} rest days',
                        style: getTextStyleWorkSans(
                          color: AppColors.textDescription,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          lineHeight: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.0),
                  AppColors.secondary.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Instructions section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap on any day to view exercises and workout details',
                    style: getTextStyleWorkSans(
                      color: AppColors.secondary.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      lineHeight: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
