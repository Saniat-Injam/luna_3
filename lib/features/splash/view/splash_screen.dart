import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/splash/controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height / 10,
              width: Get.width / 10,
              child: Image.asset(IconPath.splashicon),
            ),
            SizedBox(width: 10),

            Text(
              AppText.splashTitle,
              style: GoogleFonts.nunito(
                fontSize: 37.838,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w800,
                color: AppColors.secondary,
              ),
            ),
            Text(
              AppText.splashTitle2,
              style: GoogleFonts.nunito(
                fontSize: 37.838,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
