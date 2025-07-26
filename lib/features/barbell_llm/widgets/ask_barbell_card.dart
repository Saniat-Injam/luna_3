import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

class AskBarbellCard extends StatelessWidget {
  final VoidCallback onTap;

  const AskBarbellCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SvgPath.barbellSvg),

            Text(
              'Ask Barbell',
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            SvgPicture.asset(SvgPath.divider, width: 100, height: 10),
          ],
        ),
      ),
    );
  }
}
