// lib/features/workout setup/models/app_setup_model.dart

import 'package:barbell/core/utils/constants/app_texts.dart';

class AppSetup1Model {
  final String screenTitle;
  final String point1;
  final String point2;
  final String point3;
  final String point4;
  final String point5;
  final String continueButtonText;

  const AppSetup1Model({
    required this.screenTitle,
    required this.point1,
    required this.point2,
    required this.point3,
    required this.point4,
    required this.point5,
    required this.continueButtonText,
  });
}

// Constant instance using AppText
const appSetupModel = AppSetup1Model(
  screenTitle: AppText.appsetup1Screentitle,
  point1: AppText.appsetup1Screenpoin1,
  point2: AppText.appsetup1Screenpoin2,
  point3: AppText.appsetup1Screenpoin3,
  point4: AppText.appsetup1Screenpoin4,
  point5: AppText.appsetup1Screenpoin5,
  continueButtonText: AppText.appsetup1Screenpoin6,
);
