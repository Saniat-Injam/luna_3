import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBarThemes {
  CustomAppBarThemes._();

  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    backgroundColor: Color(0xff121400),
    iconTheme: IconThemeData(
      color: Colors.white,
    ), // Changed to white for dark background
    titleTextStyle: TextStyle(
      color: Colors.white, // Changed to white for dark background
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(color: Colors.white), // Changed to white
    centerTitle: true,
    systemOverlayStyle:
        SystemUiOverlayStyle.light, // Changed to light for dark background
  );

  static final AppBarTheme darkAppBarTheme = AppBarTheme(
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    backgroundColor: Colors.grey[900],
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: Colors.white),
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
