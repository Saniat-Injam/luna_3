import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class HeightTextfield extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller; // New
  final Function(String) onChanged;       // New

  const HeightTextfield({
    super.key,
    required this.labelText,
    this.hintText = '5.8',
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 16,
      width: MediaQuery.of(context).size.width / 2.3,
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              labelText,
              style: getTextStyle1(
                fontSize: 20,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            )
            .paddingOnly(left: 5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: getTextStyle1(
                fontSize: 32,
                color: AppColors.surfaceLight,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: getTextStyle1(
                  fontSize: 32,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}