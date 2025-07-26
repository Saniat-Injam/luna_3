import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/auth/controller/otp_verify_controller.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_countdown/slide_countdown.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.isResetPassword = false,
  });

  final String email;
  final bool isResetPassword;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerifyController());
    final model = controller.otpModel.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(child: Image.asset(model.splashIcon)),
              const SizedBox(height: 15),
              Text(
                isResetPassword == true ? "Forgot Password?" : "Verify Email",
                style: getTextStyle1(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: AppColors.backgroundLight,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                model.subtitle,
                style: getTextStyle1(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSub,
                ),
              ),
              Text(
                email,
                style: getTextStyle1(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSub,
                ),
              ),
              const SizedBox(height: 30),

              // OTP Input Field
              Pinput(
                length: 6,
                autofocus: true,
                controller: controller.otpController,
                defaultPinTheme: PinTheme(
                  width: 55,
                  height: 55,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SubmitButton(
                text: "Verify",
                onPressed:
                    () =>
                        controller.verifyOtp(isResetPassword: isResetPassword),
              ).paddingOnly(right: 5),

              const SizedBox(height: 20),

              // Resend Code Timer
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.canResend.value != true
                        ? const Text(
                          "Send code again in ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                        : GestureDetector(
                          onTap: () {
                            controller.onClickedResendOtp();
                          },
                          child: const Text(
                            "Resend code ",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                    SlideCountdown(
                      key: controller.countdownKey.value,
                      duration: Duration(
                        seconds: controller.resendDuration.value,
                      ),
                      onDone: () {
                        controller.canResend.value = true;
                      },
                      separator: ":",
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
