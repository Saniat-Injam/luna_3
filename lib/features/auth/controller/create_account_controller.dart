import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/auth/models/create_account_model.dart';
import 'package:barbell/features/auth/view/otp_verification_screen.dart';

class CreateAccountController extends GetxController {
  var createAccountModel =
      CreateAccountModel(
        splashIcon: IconPath.splashicon,
        emailIcon: IconPath.emailicon,
        passwordIcon: IconPath.passwordicon,
        eyeIcon: 'assets/icons/Solid eye.png',
        title: AppText.createaccountScreentitle,
        subtitle: AppText.createaccountScreensubtitle,
        usernameLabel: AppText.createaccountScreenuser,
        emailLabel: AppText.createaccountScreenemail,
        passwordLabel: AppText.createaccountScreenpassword,
        confirmPasswordLabel: AppText.createaccountconfirmpassword,
        alreadyHaveAccount: AppText.createaccountalreadyhaveaccount,
        signInText: AppText.createaccountsignin,
      ).obs;

  // Profile Image
  final pickedImage = Rx<File?>(null);

  // Controllers for each field
  GlobalKey<FormState>? formKey;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void handlePickedImage(File imageFile) async {
    pickedImage.value = imageFile;
  }

  RxBool isLoading = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);

  // Separate password visibility states
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // Toggle functions for each
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  //? ----------------------------------------------------
  // * Function to handle sign up
  //? ----------------------------------------------------
  Future<bool> onClickSignUp(Map<String, dynamic>? body) async {
    bool isSuccess = false;

    // If body is provided (from Google sign-in), skip form validation
    // Otherwise, validate the form if formKey is initialized
    bool shouldProceed = body != null;
    if (body == null && formKey?.currentState != null) {
      shouldProceed = formKey!.currentState!.validate();
    }

    if (shouldProceed) {
      EasyLoading.show(status: 'loading...');
      isLoading.value = true;

      Map<String, dynamic> requestBody = {
        "name": usernameController.text,
        "password": passwordController.text,
        "confirmPassword": confirmPasswordController.text,
        "email": emailController.text,
        "aggriedToTerms": true,
      };

      final response = await Get.find<NetworkCaller>().multipart(
        url: "https://luna3server.onrender.com/api/v1/users/createUser",
        // fieldName: "data",
        fieldsData: body ?? requestBody,
        file: pickedImage.value != null ? XFile(pickedImage.value!.path) : null,
        type: MultipartRequestType.POST,
      );

      if (response.isSuccess) {
        if (response.responseData['data']['token'] != null) {
          await StorageService.saveAccessToken(
            response.responseData['data']['token'],
          );
          EasyLoading.showSuccess('Login successful');
          isSuccess = true;
          update();
          if (body == null) {
            // Navigate to OTP verification screen if not called from Google sign-in
            Get.to(() => OtpVerificationScreen(email: emailController.text));
          } else {
            // For Google sign-in, extract email from body
            final email = body['email'] as String? ?? emailController.text;
            Get.to(() => OtpVerificationScreen(email: email));
          }
        } else {
          EasyLoading.showError("An unexpected error occurred.");
        }
      } else {
        EasyLoading.showError("An unexpected error occurred.");
      }
    }

    EasyLoading.dismiss();
    return isSuccess;
  }

  // Dispose controllers when not needed
  @override
  void onInit() {
    // Initialize formKey if it doesn't exist
    formKey ??= GlobalKey<FormState>();
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
