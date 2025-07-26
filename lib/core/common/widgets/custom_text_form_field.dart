import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';

class ObscureController extends GetxController {
  var isObscured = true;

  void toggleObscured() {
    isObscured = !isObscured;
    update();
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.textEditingController,
    this.validator,
    this.hintText,
    this.prefixSvgPath,
    this.isPassword = false,
    this.isDisabled = false,
  });

  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? prefixSvgPath;
  final bool isPassword;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final ObscureController obscureController = Get.put(ObscureController());

    return GetBuilder<ObscureController>(
      builder: (controller) {
        return TextFormField(
          style: AppTextStyle.f16W400().copyWith(),
          obscureText: isPassword ? controller.isObscured : false,
          controller: textEditingController,
          validator: validator,
          enabled: !isDisabled,
          decoration: InputDecoration(
            hintText: hintText ?? '',
            prefixIcon:
                prefixSvgPath != null
                    ? Transform.scale(
                      scale: 0.5,
                      child: SvgPicture.asset(
                        prefixSvgPath!,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFADADAF),
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                    : null,
            suffixIcon:
                isPassword
                    ? GestureDetector(
                      onTap: obscureController.toggleObscured,
                      child: Icon(
                        obscureController.isObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFADADAF),
                      ),
                    )
                    : null,
          ),
        );
      },
    );
  }
}
