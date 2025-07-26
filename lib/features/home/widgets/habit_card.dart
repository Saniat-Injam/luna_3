import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/image_path.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String backgroundImage;
  final VoidCallback onPressed;

  const HabitCard({
    super.key,
    this.title = 'Choose your next habits',
    this.subtitle = 'Big goals start with small habits.',
    this.buttonText = 'Start habit',
    this.backgroundImage = ImagePath.habbitbackground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(backgroundImage),
        Positioned(
          top: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle1(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: getTextStyle1(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 16,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.textOrange.withValues(alpha: .2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            child: Text(
              buttonText,
              style: getTextStyleWorkSans(
                fontSize: 10,
                color: AppColors.textOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
