import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class CustomHabitButton extends StatelessWidget {
  const CustomHabitButton({
    super.key,
    required this.onPressed,
    required this.showButton,
    this.buttonText = 'Next',
  });

  final VoidCallback onPressed;
  final RxBool showButton;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!showButton.value) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: getTextStyle1(
                  color: AppColors.textfieldBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
