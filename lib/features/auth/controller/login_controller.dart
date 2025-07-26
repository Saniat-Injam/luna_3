import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/controllers/get_all_data_controller.dart';
import 'package:barbell/core/services/app_service.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/auth/models/LoginResponseModel.dart';
import 'package:barbell/features/auth/models/login_model.dart';
import 'package:barbell/features/auth/view/send_otp_to_your_email_screen.dart';
import 'package:barbell/features/main_layout/view/main_layout.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/workout%20setup/controller/get_workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_1.dart';

class LoginController extends GetxController {
  late final ProfileController profileController;

  var loginModel =
      LoginModel(
        splashIcon: IconPath.splashicon,
        emailIcon: IconPath.emailicon,
        passwordIcon: IconPath.passwordicon,
        eyeIcon: 'assets/icons/Solid eye.png',
        loginTitle: AppText.loginScreentitle,
        loginSubtitle: AppText.loginScreensubtitle,
        emailLabel: AppText.loginScreenemail,
        passwordLabel: AppText.loginScreenpassword,
        forgotPassword: AppText.loginForgetpassword,
      ).obs;

  late GlobalKey<FormState> formKey;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Get the already initialized ProfileController from bindings
    profileController = Get.find<ProfileController>();
    formKey = GlobalKey<FormState>();
  }

  //* --------------- login with email and password ----------------
  Future<void> onClickSignIn() async {
    if (formKey.currentState?.validate() ?? false) {
      EasyLoading.show(status: 'Signing in...');

      Map<String, dynamic> requestBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      final response = await Get.find<NetworkCaller>().postRequest(
        url: Urls.login,
        body: requestBody,
        needToken: false,
      );

      if (response.isSuccess) {
        final data = LoginResponseModel.fromJson(response.responseData);

        if (data.approvalToken != null && data.refreshToken != null) {
          await StorageService.saveAccessToken(data.approvalToken ?? '');
          await StorageService.saveRefreshToken(data.refreshToken ?? '');
        }
        if (data.user?.role != null) {
          await StorageService.saveRole(data.user!.role!);
        }

        // check is user email verified
        if (data.user?.OTPverified != true) {
          await StorageService.saveIsEmailVerified(false);
          EasyLoading.showError('Please verify your email to login');
          Get.to(
            () => SendOtpToYourEmailScreen(
              email: emailController.text,
              approvalToken: data.approvalToken,
            ),
          );
        } else {
          await StorageService.saveIsEmailVerified(true);
          await profileController.getProfileData();
          // final isWorkoutSetup =
          //     await Get.find<GetWorkoutSetupController>().getWorkoutSetup();
          EasyLoading.showSuccess('Login successful');

          // Professional way: Handle FCM token after successful login
          await AppService.onUserLogin(data.approvalToken!);

          if (profileController.profileModel?.workoutSetup != null) {
            await StorageService.saveIsWorkoutSettedup(true);
            Get.offAll(() => MainLayout());
          } else {
            await StorageService.saveIsWorkoutSettedup(false);
            Get.offAll(() => AppSetupScreen1());
            EasyLoading.showSuccess('Please complete your workout setup');
          }
        }
      } else {
        EasyLoading.showError('Login failed');
      }
    }

    EasyLoading.dismiss();
  }

  //! --------------- login with social media ----------------
  Future<bool> socialAuthentication({
    required String email,
    required String method,
  }) async {
    if (email.isEmpty) {
      EasyLoading.showError('Email is required for authentication');
      return false;
    }
    bool isSuccess = false;

    EasyLoading.show(status: 'Signing in with $method...');
    Map<String, dynamic> requestBody = {"email": email, "method": method};

    final response = await Get.find<NetworkCaller>().postRequest(
      url: Urls.login,
      body: requestBody,
      needToken: false,
    );

    if (response.isSuccess) {
      isSuccess = true;
      update();
      final data = LoginResponseModel.fromJson(response.responseData);
      // save token and refresh token to shared preferences
      if (data.approvalToken != null && data.refreshToken != null) {
        await StorageService.saveAccessToken(data.approvalToken!);
        await StorageService.saveRefreshToken(data.refreshToken!);
      }
      // save user role to shared preferences
      if (data.user?.role != null) {
        await StorageService.saveRole(data.user!.role!);
      }
      if (data.user?.OTPverified != true) {
        EasyLoading.showError('Please verify your email to login');
        Get.to(
          () => SendOtpToYourEmailScreen(
            email: email, // Use the parameter instead of emailController.text
            approvalToken: data.approvalToken,
          ),
        );
      } else {
        EasyLoading.showSuccess('Login successful');

        // Professional way: Handle FCM token after successful social login
        await AppService.onUserLogin(data.approvalToken!);

        final bool isSuccess =
            await Get.find<GetWorkoutSetupController>().getWorkoutSetup();
        if (isSuccess) {
          Get.offAll(() => const MainLayout());
          Get.put(GetAllDataController()).fetchAllDataOneceAfterLoggedIn();
        } else {
          Get.offAll(() => const AppSetupScreen1());
        }
      }
    } else {
      EasyLoading.showError('Something went wrong try again');
      isSuccess = false;
    }

    EasyLoading.dismiss();
    update();
    return isSuccess;
  }
}
