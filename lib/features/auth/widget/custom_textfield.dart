import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/responsive_helper.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.context,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.showEyeIcon = false,
    this.eyeIconAsset,
    this.eyeIconSize,
    this.isObscured,
    this.onToggleObscured,
  });

  final BuildContext context;
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool isPassword;
  final bool showEyeIcon;
  final String? eyeIconAsset;
  final double? eyeIconSize;
  final RxBool? isObscured;
  final VoidCallback? onToggleObscured;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);
    final size = MediaQuery.of(context).size;

    final height = r.fromSmallMediumLarge(
      small: size.height / 13,
      medium: size.height / 15,
      large: size.height / 12,
    );

    final width = r.fromSmallMediumLarge(
      small: size.width / 1.15,
      medium: size.width / 1,
      large: size.width / 1.05,
    );

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.textfieldBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: isObscured != null
          ? Obx(() => _buildTextFormField(r))
          : _buildTextFormField(r),
    );
  }

  Widget _buildTextFormField(ResponsiveHelper r) {
    final bool obscured = isPassword && (isObscured?.value ?? true);

    final fontSize = r.fromSmallMediumLarge(
      small: 14,
      medium: 16,
      large: 18,
    );

    final hintFontSize = r.fromSmallMediumLarge(
      small: 13,
      medium: 15,
      large: 16,
    );

    final iconSize = eyeIconSize ??
        r.fromSmallMediumLarge(
          small: 20,
          medium: 24,
          large: 28,
        );

    return TextFormField(
      controller: controller,
      obscureText: obscured,
      style: GoogleFonts.workSans(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: AppColors.textWhite,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.workSans(
          fontSize: hintFontSize,
          fontWeight: FontWeight.w400,
          color: const Color(0x80FFFFFF),
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        suffixIcon: isPassword && showEyeIcon
            ? IconButton(
                onPressed: onToggleObscured,
                icon: eyeIconAsset != null
                    ? SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Image.asset(
                          eyeIconAsset!,
                          color: obscured
                              ? const Color(0x80FFFFFF)
                              : Colors.white,
                        ),
                      )
                    : Icon(
                        obscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: obscured
                            ? const Color(0x80FFFFFF)
                            : Colors.white,
                        size: iconSize,
                      ),
              )
            : null,
      ),
    );
  }
}
