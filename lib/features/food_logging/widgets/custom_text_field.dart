import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextDirection? textDirection;
  final bool isRtl;
  final bool isDisabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.controller,
    this.onChanged,
    this.textDirection,
    this.isRtl = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: textDirection,
      controller: controller,
      onChanged: onChanged,
      readOnly: isDisabled,
      style: getTextStyleWorkSans(
        color: AppColors.textWhite,
        fontSize: 14,
        lineHeight: 12,
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextStyleWorkSans(
          color: AppColors.textWhite.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        hintTextDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
