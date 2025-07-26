import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class WeeklyHabitsHeader extends StatelessWidget {
  const WeeklyHabitsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Want a nudge?',
          style: getTextStyleWorkSans(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'New habits can be hard. We can help with a daily reminder.',
          style: getTextStyleWorkSans(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            lineHeight: 12,
          ),
        ),
      ],
    );
  }
}
