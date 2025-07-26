import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/auth/models/forgot_password_model.dart';
import 'package:barbell/features/auth/view/otp_verification_screen.dart';
import 'package:logger/logger.dart';

class SendOtpController extends GetxController {
  var sendOtpModel =
      ForgotPasswordModel(
        splashIcon: IconPath.splashicon,
        emailIcon: IconPath.emailicon,
        title: AppText.forgotpassScreentitle,
        subtitle: AppText.forgotpassScreensubtitle,
        emailLabel: AppText.loginScreenemail,
      ).obs;

  TextEditingController emailController = TextEditingController();

  Future<void> onClickSendOtp({bool isForgotPassword = false}) async {
    EasyLoading.show(status: 'loading...');
    Map<String, dynamic> requestBody = {};
    if (isForgotPassword) {
      requestBody['email'] = emailController.text;
    }
    if (emailController.text.isNotEmpty) {
      final response = await Get.find<NetworkCaller>().postRequest(
        url: isForgotPassword ? Urls.forgetPassword : Urls.sendOtp,
        body: requestBody,
        needToken: isForgotPassword ? false : true,
      );
      if (response.isSuccess) {
        await StorageService.saveAccessToken(
          response.responseData['body']['token'],
        );
        EasyLoading.showSuccess('${response.responseData['message']}');
        Get.to(
          () => OtpVerificationScreen(
            email: emailController.text,
            isResetPassword: isForgotPassword,
          ),
        );
      } else {
        EasyLoading.showError('Something went wrong try again');
        Logger().e('Error: ${response.errorMessage}');
      }
    }

    EasyLoading.dismiss();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
