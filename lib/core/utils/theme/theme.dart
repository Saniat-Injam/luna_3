import 'package:flutter/material.dart';
import 'package:barbell/core/utils/theme/custom_themes/app_bar_theme.dart';

import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // fontFamily: 'Poppins'
    brightness: Brightness.light,
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Color(0xff121400),
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: CustomAppBarThemes.lightAppBarTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color(0xff121400),
    // fontFamily: 'Poppins'
    brightness: Brightness.dark,
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Color(0xff121400),
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: CustomAppBarThemes.darkAppBarTheme,
    // inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
  );
}
