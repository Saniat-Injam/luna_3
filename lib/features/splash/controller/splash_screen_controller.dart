import 'package:get/get.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/features/main_layout/view/main_layout.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_1.dart';
import 'package:barbell/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await splashScreenDelay();
  }

  Future<void> splashScreenDelay() async {
    Future.delayed(const Duration(seconds: 2), () async {
      if (await StorageService.isLoggedIn()) {
        if (StorageService.isWorkoutSettedup == true) {
          Get.offAll(() => const MainLayout());
        } else {
          Get.offAll(() => const AppSetupScreen1());
        }
      } else {
        Get.offAllNamed(AppRoute.onboardingScreen1);
      }
    });
  }
}
