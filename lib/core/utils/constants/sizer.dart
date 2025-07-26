import 'package:flutter/material.dart';
import 'package:barbell/core/utils/context/app_context.dart';

class Sizer {
  Sizer._();
  static final size = MediaQuery.sizeOf(AppContext.currentContext);

  static double figmaScreenWidth = 375;
  static double figmaScreenHeight = 812;

  // Width Percentage from Figma
  static double wp(double width) {
    return (width / figmaScreenWidth) * size.width;
  }

  // Height Percentage from Figma
  static double hp(double height) {
    return (height / figmaScreenHeight) * size.height;
  }
}
