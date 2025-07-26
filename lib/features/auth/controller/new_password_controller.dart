import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/auth/models/new_password_model.dart';
import 'package:barbell/features/auth/view/password_changed_screen.dart';

class NewPasswordController extends GetxController {
  var newPasswordModel =
      NewPasswordModel(
        splashIcon: IconPath.splashicon,
        eyeIcon: IconPath.passwordeye,
        title: AppText.newpasswordScreentitle,
        subtitle: AppText.newpasswordScreensubtitle,
        passwordLabel: AppText.createaccountScreenpassword,
        confirmPasswordLabel: AppText.createaccountconfirmpassword,
      ).obs;

  // Controllers for both fields
  late GlobalKey<FormState> formKey;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> onClickedConfirm() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'loading...');
      final response = await Get.find<NetworkCaller>().postRequest(
        url: Urls.resetPassword,
        body: {
          "token": StorageService.accessToken,
          "newPassword": passwordController.text,
        },
      );

      if (response.isSuccess) {
        EasyLoading.showSuccess('${response.responseData['message']}');
        Get.to(() => PasswordChangedScreen());
      } else {
        EasyLoading.showError('Something went wrong try again');
      }
      EasyLoading.dismiss();
    }
  }
}
