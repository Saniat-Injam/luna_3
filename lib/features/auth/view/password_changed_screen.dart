import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/auth/widget/submit_button.dart';
import 'package:barbell/routes/app_routes.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Center(child: Image.asset(IconPath.successicon)),
            SizedBox(height: 15),
            Text(
              AppText.passwordchangedScreentitle,
              style: getTextStyle1(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: AppColors.backgroundLight,
              ),
            ),

            SizedBox(height: 10),
            Text(
              AppText.passwordchangedScreensubtitle,
              style: getTextStyle1(
                fontSize: 16,

                fontWeight: FontWeight.w400,
                color: AppColors.backgroundLight,
              ),
            ),

            const SizedBox(height: 40),
            SubmitButton(
              text: "Back to login",
              onPressed: () {
                Get.offAllNamed(AppRoute.loginScreen);
              },
            ).paddingOnly(right: 05),
          ],
        ),
      ),
    );
  }
}
