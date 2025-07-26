import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Rest day content widget with recovery tips
class RestDayContent extends StatelessWidget {
  const RestDayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          color: AppColors.textDescription.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.textDescription.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.spa,
                  color: AppColors.textDescription,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recovery Time',
                      style: getTextStyleWorkSans(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        lineHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Take a rest and let your muscles recover',
                      style: getTextStyleWorkSans(
                        color: AppColors.textDescription,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        lineHeight: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textDescription.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '💡 Recovery Tips',
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    lineHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Stay hydrated\n• Get quality sleep\n• Light stretching\n• Proper nutrition',
                  style: getTextStyleWorkSans(
                    color: AppColors.textDescription,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    lineHeight: 11,
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
