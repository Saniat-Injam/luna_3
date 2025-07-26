import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_text_form_field.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/controller/new_password_controller.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPasswordController());
    final model = controller.newPasswordModel.value; // Access model values

    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: Sizer.hp(36)),

                  // Centered splash icon (e.g., password icon)
                  Center(child: Image.asset(model.splashIcon)),
                  SizedBox(height: Sizer.hp(18)),

                  Text("New Password", style: AppTextStyle.f30W500()),
                  SizedBox(height: Sizer.hp(8)),

                  // Subtitle text
                  Text(
                    "Please type something you’ll remember",
                    style: AppTextStyle.f16W400(),
                  ),
                  SizedBox(height: Sizer.hp(30)),

                  // Password label (aligned left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create a password",
                      style: AppTextStyle.f18W400(),
                    ),
                  ),
                  SizedBox(height: Sizer.hp(16)),

                  CustomTextFormField(
                    textEditingController: controller.passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    hintText: 'Must be 8 characters',
                    isPassword: true,
                  ),

                  // Spacing before confirm password label
                  SizedBox(height: Sizer.hp(24)),

                  // Confirm Password label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: AppTextStyle.f18W400(),
                    ),
                  ),
                  SizedBox(height: Sizer.hp(16)),

                  // Confirm Password input field
                  CustomTextFormField(
                    textEditingController: controller.confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != controller.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    hintText: 'Enter Password',
                    isPassword: true,
                  ),
                  // Spacing before confirm button
                  SizedBox(height: Sizer.hp(30)),

                  // Confirm Submit button
                  SubmitButton(
                    text: "Confirm",
                    onPressed: () => controller.onClickedConfirm(),
                    // onPressed: () {
                    //   Get.to(() => PasswordChangedScreen());
                    // },
                  ),

                  // Bottom spacing
                  SizedBox(height: Sizer.hp(30)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
