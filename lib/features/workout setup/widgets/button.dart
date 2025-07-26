import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class Button extends StatelessWidget {
  final String text; // Only required parameter

  // Optional styling
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final BorderRadiusGeometry? borderRadius;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.alignment,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.selectedTextColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSetupController>();

    return Obx(() {
      final isSelected = controller.isSelectedFitnessGoal(text);

      final bgColor =
          isSelected
              ? (selectedColor ?? Colors.yellow)
              : (backgroundColor ?? AppColors.backgroundDark);
      final txtColor =
          isSelected
              ? (selectedTextColor ?? Colors.black)
              : (textColor ?? Colors.white);

      return GestureDetector(
        onTap: () {
          // controller.selectFitnessGoal(text);
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height ?? Get.height / 15,
          width: width ?? Get.width / 1.1,
          alignment: alignment ?? Alignment.centerLeft,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize ?? 18,
              fontWeight: fontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
