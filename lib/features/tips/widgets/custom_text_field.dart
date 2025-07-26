import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/tips/widgets/custom_gradian_border.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.maxLines,
    this.hintText,
    this.controller,
    this.validator,
    this.willValidate = true,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.onChange,
  });

  final int? maxLines;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? willValidate;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChange,
        controller: controller,
        validator:
            willValidate != false
                ? validator ??
                    (value) {
                      if (value == null || value.isEmpty) {
                        return hintText ?? 'Please enter some text';
                      }
                      return null;
                    }
                : null,
        style: AppTextStyle.f14W400(),

        // decoration: InputDecoration(
        //   hintText: hintText ?? "Hint Text",
        //   suffixIcon: suffixIcon,
        // ),
        decoration: InputDecoration(
          hintText: hintText ?? "Hint Text",
          suffixIcon: suffixIcon,
          errorMaxLines: 3,
          hintStyle: AppTextStyle.f14W400().copyWith(color: Color(0XFF8B8B8B)),
          filled: false,
          // fillColor: Color(0xff121400),
          border: CustomGradientOutlineInputBorder(
            gradient: LinearGradient(
              colors: [Color(0xff1D3828), Color(0xff13251A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderSideWidth: 0.86,
            borderRadiusValue: 5.0,
          ),
          enabledBorder: CustomGradientOutlineInputBorder(
            gradient: LinearGradient(
              colors: [Color(0xff1D3828), Color(0xff13251A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderSideWidth: 0.86,
            borderRadiusValue: 5.0,
          ),
          focusedBorder: CustomGradientOutlineInputBorder(
            gradient: LinearGradient(
              colors: [Color(0xff1D3828), Color(0xff13251A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderSideWidth: 0.86,
            borderRadiusValue: 5.0,
          ),

          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: AppColors.error),
          ),
        ),

        maxLines: maxLines ?? 1,
      ),
    );
  }
}
