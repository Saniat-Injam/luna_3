import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout%20setup/controller/top_progress_controller.dart';
import 'package:barbell/features/workout%20setup/view/start_building_your_body.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/sleep_button.dart';
import 'package:barbell/features/workout%20setup/widgets/top_progress.dart';

class SleepQualityScreen extends StatelessWidget {
  const SleepQualityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            TopProgress(),
            SizedBox(height: MediaQuery.of(context).size.height / 30),
            Text(
              AppText.appsetup9Screentitle,
              style: getTextStyle1(
                fontSize: 28,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                //  lineHeight: 38 ,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 30),
            SleepButton(
              text: "excellent", //excellent, great, normal, bad
              iconWidget: Image.asset("assets/icons/time clock.png"),
              additionalText: ">8 hours",
            ),
            SizedBox(height: 20),
            SleepButton(
              text: "great", //excellent, great, normal, bad
              iconWidget: Image.asset("assets/icons/time clock.png"),
              additionalText: "7-8 hours",
            ),
            SizedBox(height: 20),
            SleepButton(
              text: "normal",
              iconWidget: Image.asset("assets/icons/time clock.png"),
              additionalText: "6-7 hours",
            ),
            SizedBox(height: 20),
            SleepButton(
              text: "bad", //excellent, great, normal, bad
              iconWidget: Image.asset("assets/icons/time clock.png"),
              additionalText: "3-4 hours",
            ),
            // SizedBox(height: 20),
            // SleepButton(
            //   text: "Insomniac",
            //   iconWidget: Image.asset("assets/icons/time clock.png"),
            //   additionalText: "<2 hours",
            // ),

            // SizedBox(height: MediaQuery.of(context).size.height / 600),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: () {
                    final setupController = Get.find<TopProgressController>();
                    setupController.goToNextStep(); // Increase progress
                    Get.to(StartBuildingYourBody());
                  },
                  text: AppText.appsetup1Screenpoin6,
                  fontSize: 20,
                  alignment: Alignment.center,
                  fontWeight: FontWeight.w500,
                  backgroundColor: AppColors.appbar,
                  textColor: AppColors.textWhite,
                  selectedColor: AppColors.appbar,
                  selectedTextColor: AppColors.textWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
