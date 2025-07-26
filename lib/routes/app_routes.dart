import 'package:get/get.dart';
import 'package:barbell/features/auth/view/create_account_screen.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/auth/view/new_password_screen.dart';
import 'package:barbell/features/auth/view/otp_verification_screen.dart';
import 'package:barbell/features/auth/view/password_changed_screen.dart';
import 'package:barbell/features/auth/view/send_otp_to_your_email_screen.dart';
import 'package:barbell/features/food_logging/view/food_logging_screen.dart';
import 'package:barbell/features/main_layout/view/main_layout.dart';
import 'package:barbell/features/onbording_screen/views/onboardin_screen3.dart';
import 'package:barbell/features/onbording_screen/views/onboarding_screen2.dart';
import 'package:barbell/features/onbording_screen/views/onboarding_screen4.dart';
import 'package:barbell/features/onbording_screen/views/onbording_screen1.dart';
import 'package:barbell/features/splash/view/splash_screen.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_1.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_2.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_3.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_4.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_5.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_6.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_7.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_8.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_9.dart';
import 'package:barbell/features/workout%20setup/view/start_building_your_body.dart';

import '../features/notification/screen/notification_screen.dart'
    show NotificationScreen;

import '../features/profile/view/privacy_policy_screen.dart' show PrivacyPolicyScreen;

class AppRoute {
  // static String splashScreen = "/splashScreen";
  static String splashScreen = "/splashScreen";

  // static String onboardingScreen = "/onboardingScreen";
  static String onboardingScreen1 = "/onbordingScreen1";
  static String onboardingScreen2 = "/onbordingScreen2";
  static String onboardingScreen3 = "/onbordingScreen3";
  static String onboardingScreen4 = "/onbordingScreen4";

  // static String loginScreen = "/loginScreen";
  // static String customBottomNavbar = "/customBottomNavbar";
  static String mainLayout = "/mainLayout";
  static String loginScreen = "/loginScreen";
  static String createaccuntScreen = "/createaccuntScreen";
  static String forgetPasswordScreen = "/forgetPasswordScreen";
  static String forgetPasswordotpScreen = "/forgetPasswordotpScreen";
  static String newPasswordScreen = "/newPasswordScreen";
  static String passwordchangedScreen = "/passwordchangedScreen";
  static String notificationScreen = "/notificationScreen";
  static String privacyPolicy = "/privacyPolicy";
  static String adminPrivacyPolicy = "/adminPrivacyPolicy";
  // static String workoutSetupScreen = "/workoutSetupScreen";
  static String appSetupScreen1 = "/appSetupScreen1";
  static String appSetupScreen2 = "/appSetupScreen2";
  static String appSetupScreen3 = "/appSetupScreen3";
  static String appSetupScreen4 = "/appSetupScreen4";
  static String appSetupScreen5 = "/appSetupScreen5";
  static String appSetupScreen6 = "/appSetupScreen6";
  static String appSetupScreen7 = "/appSetupScreen7";
  static String appSetupScreen8 = "/appSetupScreen8";
  static String appSetupScreen9 = "/appSetupScreen9";
  static String appSetupScreen10 = "/appSetupScreen10";

  /////////////////////////////////////////////////////////////////////////////////////////////////////

  // static String getSplashScree() => splashScreen;
  static String foodLogging = "/food-logging";
  // static String getLoginScreen() => loginScreen;
  static String getSplashScreen() => splashScreen;

  // static String getOnboardingScreen() => onboardingScreen;
  static String getOnBoardingScreen1() => onboardingScreen1;
  static String getOnBoardingScreen2() => onboardingScreen2;
  static String getOnBoardingScreen3() => onboardingScreen3;
  static String getOnBoardingScreen4() => onboardingScreen4;

  // static String getLoginScreen() => loginScreen;
  // static String getCustomBottomNavbar() => customBottomNavbar;
  static String getMainLayout() => mainLayout;
  static String getLoginScreen() => loginScreen;
  static String getCreateAccountScreen() => createaccuntScreen;
  static String getForgetPasswordScreen() => forgetPasswordScreen;
  static String getForgetPasswordOtpScreen() => forgetPasswordotpScreen;
  static String getNewPasswordScreen() => newPasswordScreen;
  static String getPasswordChangedScreen() => passwordchangedScreen;
  static String getNotificationScreen() => notificationScreen;
  static String getPrivacyPolicy() => privacyPolicy;
  static String getAdminPrivacyPolicy() => adminPrivacyPolicy;
  static String getFoodLoggingScreen() => foodLogging;

  // static String getWorkOutSetupScreen() => workoutappSetupScreen;
  static String getAppSetupScreen1() => appSetupScreen1;
  static String getAppSetupScreen2() => appSetupScreen2;
  static String getAppSetupScreen3() => appSetupScreen3;
  static String getAppSetupScreen4() => appSetupScreen4;
  static String getAppSetupScreen5() => appSetupScreen5;
  static String getAppSetupScreen6() => appSetupScreen6;
  static String getAppSetupScreen7() => appSetupScreen7;
  static String getAppSetupScreen8() => appSetupScreen8;
  static String getAppSetupScreen9() => appSetupScreen9;
  static String getAppSetupScreen10() => appSetupScreen10;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  static List<GetPage> routes = [
    // ...BarbellLLMRoutes.routes,
    // GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    // ------------------------ Onboarding ------------------------
    // GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: onboardingScreen1, page: () => OnboardingScreen1()),
    GetPage(name: onboardingScreen2, page: () => OnboardingScreen2()),
    GetPage(name: onboardingScreen3, page: () => OnboardingScreen3()),
    GetPage(name: onboardingScreen4, page: () => OnboardingScreen4()),

    // ------------------------ Auth ------------------------
    // GetPage(name: loginScreen, page: () => const LoginScreen())
    // GetPage(name: customBottomNavbar, page: () => CustomBottomNavBar()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: createaccuntScreen, page: () => CreateAccountScreen()),
    GetPage(name: forgetPasswordScreen, page: () => SendOtpToYourEmailScreen()),
    GetPage(
      name: forgetPasswordotpScreen,
      page: () => OtpVerificationScreen(email: ""),
    ),
    GetPage(name: newPasswordScreen, page: () => NewPasswordScreen()),
    GetPage(name: passwordchangedScreen, page: () => PasswordChangedScreen()),

    // ------------------------ Main Layout ------------------------
    // GetPage(name: mainLayout, page: () => const MainLayout()),
    GetPage(name: mainLayout, page: () => MainLayout()),
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(name: privacyPolicy, page: () => PrivacyPolicyScreen()),
    
    // GetPage(name: workoutappSetupScreen, page: () => const WorkOutAppSetupScreen()),
    GetPage(name: appSetupScreen1, page: () => AppSetupScreen1()),
    GetPage(name: appSetupScreen2, page: () => AppSetupScreen2()),
    GetPage(name: appSetupScreen3, page: () => AppSetupScreen3()),
    GetPage(name: appSetupScreen4, page: () => AppSetupScreen4()),
    GetPage(name: appSetupScreen5, page: () => AppSetupScreen5()),
    GetPage(name: appSetupScreen6, page: () => AppSetupScreen6()),
    GetPage(name: appSetupScreen7, page: () => AppSetupScreen7()),
    GetPage(name: appSetupScreen8, page: () => AppSetupScreen8()),
    GetPage(name: appSetupScreen9, page: () => SleepQualityScreen()),
    GetPage(name: appSetupScreen10, page: () => StartBuildingYourBody()),
    GetPage(name: foodLogging, page: () => const FoodLoggingScreen()),
  ];
}
