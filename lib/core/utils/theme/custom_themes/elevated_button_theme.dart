import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Disabled text color
            }
            return const Color(0xff24262B); // Default text color
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade300; // Disabled background color
            }
            return AppColors.secondary;
          }),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          ),
          textStyle: WidgetStateProperty.all(
            getTextStyleWorkSans(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      );

  static final ElevatedButtonThemeData
  darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade600; // Disabled text color in dark mode
        }
        return Colors.white; // Default text color
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade800; // Disabled background color in dark mode
        }
        return Colors.blueGrey; // Default dark background color
      }),
      side: WidgetStateProperty.all(const BorderSide(color: Colors.blueGrey)),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 18),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
