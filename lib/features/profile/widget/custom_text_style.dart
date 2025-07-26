import 'package:flutter/material.dart' show Colors, StatelessWidget;
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';

class CustomText extends StatelessWidget {
  final String text;
  const CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: GoogleFonts.workSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: getTextStyle1(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                lineHeight: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
