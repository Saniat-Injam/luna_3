import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

InputDecoration searchTextfeildDecoration() {
  return InputDecoration(
    hintText: 'Search',
    hintStyle: getTextStyleWorkSans(color: Color(0x99949494), fontSize: 16),
    filled: true,
    fillColor: AppColors.appbar,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
      gapPadding: 0,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
      gapPadding: 0,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
      gapPadding: 0,
    ),
    suffixIcon: Icon(Icons.search, color: Color(0x99949494), size: 24),
  );
}