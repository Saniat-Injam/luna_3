import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/widgets/custom_text_field.dart';

class IngredientSection extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const IngredientSection({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Ingredient',
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Tooltip(
                  message: 'Add ingredients with comma separated',
                  child: Icon(
                    Icons.info,
                    color: AppColors.textWhite.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(
              color: AppColors.textWhite.withValues(alpha: 0.1),
              thickness: 1,
            ),
            CustomTextField(
              hintText: 'Add ingredients with comma separated',
              controller: controller,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
