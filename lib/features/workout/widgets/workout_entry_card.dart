import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class WorkoutEntryCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath; // Path to the asset image (e.g., 'assets/images/icon.png')
  final String buttonText;
  final VoidCallback onTap;
  final bool isManualEntry;

  const WorkoutEntryCard({
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
    return Column(
      children: [Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(left: 42, right: 42, top: 20, bottom: 20),
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
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain, // Ensure the image fits within the bounds
              ),
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
        
          ],
        ),
      ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              backgroundColor: const Color(0xFFE2FF3B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: getTextStyleWorkSans(
                color: AppColors.appbar,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ]
    );
    
  }
}