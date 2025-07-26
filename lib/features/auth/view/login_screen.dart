// lib/features/auth/view/login_screen.dart (remains the same as previous)
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_text_form_field.dart';
import 'package:barbell/core/services/firebase_auth_service.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/controller/login_controller.dart';
import 'package:barbell/features/auth/view/create_account_screen.dart';
import 'package:barbell/features/auth/view/send_otp_to_your_email_screen.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    final RxBool isGoogleLoading = false.obs;

    return Scaffold(
      body: Obx(() {
        final model = loginController.loginModel.value;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: Sizer.hp(68)),

                Center(child: Image.asset(model.splashIcon)),

                SizedBox(height: Sizer.hp(16)),
                Text(model.loginTitle, style: AppTextStyle.f30W500()),
                SizedBox(height: Sizer.hp(8)),
                Text(model.loginSubtitle, style: AppTextStyle.f16W400()),
                SizedBox(height: Sizer.hp(32)),
                Form(
                  key: loginController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.emailLabel, style: AppTextStyle.f18W400()),
                      SizedBox(height: Sizer.hp(16)),
                      CustomTextFormField(
                        textEditingController: loginController.emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                        hintText: 'Enter your Email',
                        prefixSvgPath: 'assets/svg/mail.svg',
                      ),

                      SizedBox(height: Sizer.hp(16)),
                      Text(model.passwordLabel, style: AppTextStyle.f18W400()),
                      SizedBox(height: Sizer.hp(16)),
                      CustomTextFormField(
                        textEditingController:
                            loginController.passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        hintText: 'Password',
                        prefixSvgPath: 'assets/svg/lock.svg',
                        isPassword: true,
                      ),

                      SizedBox(height: Sizer.hp(16)),

                      // forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => SendOtpToYourEmailScreen(
                                isForgotPassword: true,
                              ),
                            );
                          },
                          child: Text(
                            model.forgotPassword,
                            style: AppTextStyle.f16W400(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.hp(16)),
                SubmitButton(
                  text: "Sign In",
                  onPressed: () => loginController.onClickSignIn(),
                ),
                SizedBox(height: Sizer.hp(50)),
                Center(
                  child: Obx(
                    () => GestureDetector(
                      onTap:
                          isGoogleLoading.value
                              ? null
                              : () async {
                                isGoogleLoading.value = true;
                                try {
                                  await FirebaseAuthService()
                                      .signInWithGoogleAndNavigate();
                                } finally {
                                  isGoogleLoading.value = false;
                                }
                              },
                      child: Container(
                        height: 50,
                        // width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              isGoogleLoading.value
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                        ),
                        child:
                            isGoogleLoading.value
                                ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue,
                                      ),
                                    ),
                                  ),
                                )
                                : SvgPicture.asset(
                                  'assets/svg/android_dark_rd_ctn.svg',
                                  height: 50,
                                ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Sizer.hp(38)),
                Text.rich(
                  TextSpan(
                    text: "Don’t have an account? ",
                    style: getTextStyle(
                      color: const Color(0xFF9EA0A5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up.",
                        style: AppTextStyle.f14W500().copyWith(
                          color: const Color(0xFFF97316),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => CreateAccountScreen());
                              },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.hp(54)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
