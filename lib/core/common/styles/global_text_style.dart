import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  double height = 1.22,
  TextAlign textAlign = TextAlign.center,
  Color color = Colors.black,
}) {
  return GoogleFonts.nunito(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

TextStyle getTextStyle1({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  double height = 1.22,
  double letterSpacing = -0.05,
  TextAlign textAlign = TextAlign.center,
  textDecoration = TextDecoration.underline,
  Color color = Colors.black,
}) {
  return GoogleFonts.workSans(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

TextStyle getTextStyle2({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  double height = 1.22,
  double letterSpacing = -0.05,
  TextAlign textAlign = TextAlign.center,
  textDecoration = TextDecoration.underline,
  Color color = Colors.black,
}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

// text style Inter
TextStyle getTextStyleInter({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 12.0,
  double height = 1.06,
  double letterSpacing = -0.05,
  TextAlign textAlign = TextAlign.center,
  textDecoration = TextDecoration.underline,
  Color color = Colors.black,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

// work sans
TextStyle getTextStyleWorkSans({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 21.0,
  double height = 1.22,
  double letterSpacing = -0.05,
  TextAlign textAlign = TextAlign.center,
  textDecoration = TextDecoration.underline,
  Color color = Colors.black,
}) {
  return GoogleFonts.workSans(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: fontSize.sp / lineHeight.sp,
    color: color,
  );
}

// -------------------------- Text Style --------------------------
class AppTextStyle {
  // singleton
  AppTextStyle._();
  static TextStyle baseTextStyle({
    TextStyle? fontFamily,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final textStyle = fontFamily ?? GoogleFonts.workSans();
    return textStyle.copyWith(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.43,
    );
  }

  // font Size 12 and font weight 400

  // font size 14 and font weight 400
  static TextStyle f14W400({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  // font size 14 and font weight 500
  static TextStyle f14W500({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  // font size 14 and font weight 600
  static TextStyle f14W600({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  // font size 16 and font weight 400
  static TextStyle f16W400({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  // font size 16 and font weight 500
  static TextStyle f16W500({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  // font size 16 and font weight 600
  static TextStyle f16W600({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  // font size 18 and font weight 400
  static TextStyle f18W400({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  // font size 18 and font weight 500
  static TextStyle f18W500({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  // font size 18 and font weight 600
  static TextStyle f18W600({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  // font size 20 and font weight 400
  // font size 20 and font weight 500
  // font size 20 and font weight 600
  // font size 20 and font weight 700
  // font size 21 and font weight 500
  static TextStyle f21W500({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );
  // font size 30 and font weight 500
  static TextStyle f30W500({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );
  // font size 16 and font weight 600
  static TextStyle f36W600({TextStyle? fontFamily}) => baseTextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
  );
}
