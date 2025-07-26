import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_text_form_field.dart';
import 'package:barbell/core/services/firebase_auth_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/controller/create_account_controller.dart';
import 'package:barbell/features/auth/models/create_account_model.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/auth/widget/profile_avatar.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';

class CreateAccountScreen extends StatelessWidget {
  final controller = Get.put(CreateAccountController());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = controller.createAccountModel.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.wp(20),
            ), // Responsive horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: Sizer.hp(40)),
                // Title
                Center(
                  child: Text("Create Account", style: AppTextStyle.f21W500()),
                ),
                SizedBox(height: Sizer.hp(4)),

                // Subtitle
                Center(
                  child: Text(
                    "Create an account to get started",
                    style: AppTextStyle.f16W400(),
                  ),
                ),
                SizedBox(height: Sizer.hp(30)),

                // ----------------- Choose image -----------------
                Center(child: ProfileAvatar()),
                SizedBox(height: Sizer.hp(16)),

                // Form Fields
                _buildFormFields(model),

                // Submit Button
                Align(
                  alignment: Alignment.centerRight,
                  child: SubmitButton(
                    text: "Sign Up",
                    onPressed: () => controller.onClickSignUp(null),
                    // onPressed:
                    //     () => Get.to(
                    //       () => OtpVerificationScreen(
                    //         email: controller.emailController.text,
                    //       ),
                    //     ),
                  ),
                ),

                SizedBox(height: Sizer.hp(30)),

                // Social Media Login (centered with some horizontal padding)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap:
                          () async =>
                              await FirebaseAuthService()
                                  .signInWithGoogleAndNavigate(),
                      child: SvgPicture.asset(
                        'assets/svg/android_dark_rd_ctn.svg',
                        height: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizer.hp(16)),

                // Already have account
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: model.alreadyHaveAccount,
                      style: AppTextStyle.f14W500().copyWith(
                        color: const Color(0xFF9EA0A5),
                      ),
                      children: [
                        TextSpan(
                          text: " Sign In",
                          style: AppTextStyle.f14W500()
                              .copyWith(color: const Color(0xFFF97316))
                              .copyWith(decoration: TextDecoration.underline),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => LoginScreen());
                                },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Sizer.hp(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(CreateAccountModel model) {
    return Form(
      key: controller.formKey ?? GlobalKey<FormState>(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username Label
          Text(model.usernameLabel, style: AppTextStyle.f16W400()),
          SizedBox(height: Sizer.hp(16)),

          // Username TextField
          CustomTextFormField(
            textEditingController: controller.usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Username is required';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              if (value.length > 200) {
                return 'Username must be less than 200 characters';
              }
              return null;
            },
            hintText: 'User Name',
          ),
          SizedBox(height: Sizer.hp(30)),

          // Email Label
          Text(model.emailLabel, style: AppTextStyle.f16W400()),
          SizedBox(height: Sizer.hp(16)),

          // Email TextField
          CustomTextFormField(
            textEditingController: controller.emailController,
            validator: (value) {
              if (!GetUtils.isEmail(value!)) {
                return 'Please enter a valid email';
              }
              if (value.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
            hintText: 'Your email',
          ),
          SizedBox(height: Sizer.hp(30)),

          // Password Label
          Text(model.passwordLabel, style: AppTextStyle.f16W400()),
          SizedBox(height: Sizer.hp(16)),

          // Password TextField
          CustomTextFormField(
            textEditingController: controller.passwordController,
            validator: (value) {
              if (value!.length < 8) {
                return 'Password must be at least 8 characters';
              }
              // if (!value.contains(RegExp(r'[A-Z]'))) {
              //   return 'Password must contain at least one uppercase letter.';
              // }
              // if (!value.contains(RegExp(r'[0-9]'))) {
              //   return 'Password must contain at least one number.';
              // }
              // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
              //   return 'Password must contain at least one special character.';
              // }
              return null;
            },
            hintText: 'Must be 8 characters',
            isPassword: true,
          ),
          SizedBox(height: Sizer.hp(30)),

          // Confirm Password Label
          Text(model.confirmPasswordLabel, style: AppTextStyle.f16W400()),
          SizedBox(height: Sizer.hp(16)),

          // Confirm Password TextField
          CustomTextFormField(
            textEditingController: controller.confirmPasswordController,
            validator: (value) {
              if (value != controller.passwordController.text) {
                return 'Password does not match';
              }
              return null;
            },
            hintText: 'Enter Password',
            isPassword: true,
          ),
          SizedBox(height: Sizer.hp(30)),
        ],
      ),
    );
  }
}
