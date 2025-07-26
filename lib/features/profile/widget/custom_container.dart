import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';

class CustomContiner extends StatelessWidget {
  final String? titleText;
  final TextEditingController? controller;
  final bool readOnly;
  final Function(String)? onChanged;

  const CustomContiner({
    super.key,
    this.controller,
    this.titleText,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color.fromARGB(26, 123, 241, 211)),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            readOnly: readOnly,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: getTextStyle2(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              fillColor: Colors.transparent,
              isCollapsed: true,
              isDense: true,
              suffixStyle: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
          // Text(
          //   hight ?? "N/A",
          //   style: getTextStyle2(
          //     color: Colors.white,
          //     fontSize: 20,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          SizedBox(height: 10),
          Text(
            titleText ?? "N/A",
            style: getTextStyle2(
              color: Color(0xFFA2A6AB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
