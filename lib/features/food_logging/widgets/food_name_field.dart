import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/widgets/custom_text_field.dart';

class FoodNameField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const FoodNameField({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              'Name',
              style: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: CustomTextField(
                hintText: 'New recipe name......',
                controller: controller,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
