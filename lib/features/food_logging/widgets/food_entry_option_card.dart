import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class FoodEntryOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final String buttonText;
  final VoidCallback onTap;
  final bool isManualEntry;

  const FoodEntryOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.buttonText,
    required this.onTap,
    this.isManualEntry = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(width: 0.7, color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isManualEntry ? 12 : 10,
              vertical: isManualEntry ? 10 : 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.05),
              border: Border.all(width: 0.7, color: const Color(0xFF434B04)),
              borderRadius: BorderRadius.circular(28),
            ),
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
          // Title
          const SizedBox(height: 14),
          Text(
            title,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite.withValues(alpha: 0.6),
              fontSize: 14,
              lineHeight: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE2FF3B),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: getTextStyleWorkSans(
                  color: AppColors.appbar,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
