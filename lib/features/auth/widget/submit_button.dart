import 'package:flutter/material.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              AppColors.secondary, // Replace with AppColors.secondary if needed
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
