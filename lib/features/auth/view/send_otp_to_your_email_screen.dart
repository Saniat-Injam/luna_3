import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_text_form_field.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/controller/send_otp_controller.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';

class SendOtpToYourEmailScreen extends StatelessWidget {
  // Initialize controller using GetX

  const SendOtpToYourEmailScreen({
    super.key,
    this.email,
    this.approvalToken,
    this.isForgotPassword = false,
  });

  final String? email;
  final bool isForgotPassword;
  final String? approvalToken;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SendOtpController());
    // Initialize responsive helper
    final model =
        controller.sendOtpModel.value; // Access model data from controller

    if (email != null) {
      controller.emailController.text = email!;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark, // Set dark background
      body: SafeArea(
        child: SingleChildScrollView(
          // Make screen scrollable to avoid overflow on small screens
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: Sizer.hp(20)),

                // App splash icon (e.g., lock image or logo)
                Center(child: Image.asset(model.splashIcon)),
                SizedBox(height: Sizer.hp(20)),

                isForgotPassword == true
                    ? Text("Forgot password?", style: AppTextStyle.f30W500())
                    : Text("Send OTP", style: AppTextStyle.f30W500()),
                SizedBox(height: Sizer.hp(8)),

                isForgotPassword == true
                    ? Text(
                      "Don’t worry! It happens. Please enter the email associated with your account.",
                      style: AppTextStyle.f16W400(),
                    )
                    : Text(
                      "Otp will be sent to this email.",
                      style: AppTextStyle.f16W400(),
                      textAlign: TextAlign.center,
                    ),
                SizedBox(height: Sizer.hp(32)),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email Address", style: AppTextStyle.f18W400()),
                ),
                SizedBox(height: Sizer.hp(16)),

                CustomTextFormField(
                  textEditingController: controller.emailController,
                  hintText: 'Enter your Email',
                  prefixSvgPath: 'assets/svg/mail.svg',
                  isDisabled: !isForgotPassword,
                ),

                SizedBox(height: Sizer.hp(30)),

                SubmitButton(
                  text: "Send Code",
                  onPressed:
                      () => controller.onClickSendOtp(
                        isForgotPassword: isForgotPassword,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
