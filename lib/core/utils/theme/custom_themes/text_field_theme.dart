import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
        errorMaxLines: 3,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyle.f14W400().copyWith(color: Color(0XFF8B8B8B)),
        // errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        // floatingLabelStyle: TextStyle(color: const Color(0xCC000000)),
        filled: true,
        fillColor: const Color(0xFF1C2227),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.orange),
        ),
      );

  // static const InputDecorationTheme darkInputDecorationTheme =
  //     InputDecorationTheme(
  //       errorMaxLines: 3,
  //       prefixIconColor: Colors.grey,
  //       suffixIconColor: Colors.grey,
  //       labelStyle: TextStyle(fontSize: 14, color: Colors.white),
  //       hintStyle: TextStyle(fontSize: 14, color: Colors.white70),
  //       errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
  //       floatingLabelStyle: TextStyle(color: Colors.white70),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(14)),
  //         borderSide: BorderSide(color: Colors.grey),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(14)),
  //         borderSide: BorderSide(color: Colors.grey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(14)),
  //         borderSide: BorderSide(
  //           color: Colors.white,
  //         ), // You can replace with a specific color
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(14)),
  //         borderSide: BorderSide(color: Colors.redAccent),
  //       ),
  //       focusedErrorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(14)),
  //         borderSide: BorderSide(color: Colors.orangeAccent),
  //       ),
  //     );
}
