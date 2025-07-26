import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/image_path.dart';
import 'package:barbell/features/onbording_screen/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  Rx<OnboardingModel> onboarding1 =
      OnboardingModel(
        imagePath: ImagePath.onboardingscreen1,
        //imagePath: ImagePath.chickenProvencal,
        skipText: AppText.skip,
        title: AppText.onbordingScreen1title,
        subtitle: AppText.onbordingScreen1subtitle,
      ).obs;

  Rx<OnboardingModel> onboarding2 =
      OnboardingModel(
        imagePath: ImagePath.onboardingscreen2,
        skipText: AppText.skip,
        title: AppText.onbordingScreen2title,
        subtitle: AppText.onbordingScreen2subtitle,
      ).obs;

  Rx<OnboardingModel> onboarding3 =
      OnboardingModel(
        imagePath: ImagePath.onboardingscreen3,
        skipText: AppText.skip,
        title: AppText.onbordingScreen3title,
        subtitle: AppText.onbordingScreen3subtitle,
      ).obs;

  Rx<OnboardingModel> onboarding4 =
      OnboardingModel(
        imagePath: ImagePath.onboardingscreen4,
       // imagePath: ImagePath.chickenProvencal,
        skipText: AppText.skip,
        title: AppText.onbordingScreen4title,
      ).obs;
}
