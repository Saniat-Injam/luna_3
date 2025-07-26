import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';

class SleepButton extends StatelessWidget {
  final String text;
  final Widget? iconWidget; // This will be Image.asset or Icon
  final String additionalText;

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

  const SleepButton({
    super.key,
    required this.text,
    required this.iconWidget,
    required this.additionalText,
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
      final isSelected = controller.isSelectedSleepQuality(text);

      final bgColor =
          isSelected
              ? (selectedColor ?? AppColors.secondary)
              : (backgroundColor ?? AppColors.appbar);
      final txtColor =
          isSelected
              ? (selectedTextColor ?? Colors.black)
              : (textColor ?? Colors.white);

      return GestureDetector(
        onTap: () {
          controller.selectSleepQuality(text);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Main Text
              Text(
                text,
                style: getTextStyle1(
                  color: txtColor,
                  fontSize: fontSize ?? 18,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),

              // Right side: Icon + Additional Text
              Row(
                children: [
                  // Consistent-sized icon with dynamic color
                  SizedBox(
                    width: 17,
                    height: 17,
                    child:
                        iconWidget != null
                            ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                txtColor,
                                BlendMode.srcIn,
                              ),
                              child: iconWidget!,
                            )
                            : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    additionalText,
                    style: getTextStyle1(
                      color: txtColor,
                      fontSize: fontSize ?? 14,
                      fontWeight: fontWeight ?? FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
