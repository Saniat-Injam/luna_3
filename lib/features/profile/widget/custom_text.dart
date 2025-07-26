import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitleText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomTitleText({
    super.key,
    required this.text,
    this.color = const Color(0xFFDBDCD9),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
