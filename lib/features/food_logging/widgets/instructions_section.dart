import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/widgets/custom_text_field.dart';

class InstructionsSection extends StatelessWidget {
  final TextEditingController? controller;
  final bool isDisabled;
  final void Function(String)? onChanged;

  const InstructionsSection({
    super.key,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions',
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              isDisabled: isDisabled,
              hintText: 'Write step-by-step instructions here',
              maxLines: 6,
              controller: controller,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
