import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/app_texts.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout%20setup/controller/carousel_state_controller.dart';
import 'package:barbell/features/workout%20setup/controller/create_workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/widgets/button.dart';
import 'package:barbell/features/workout%20setup/widgets/carousel_screen.dart';

class StartBuildingYourBody extends StatelessWidget {
  StartBuildingYourBody({super.key});

  final CarouselStateController controller = Get.put(
    CarouselStateController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    final createWorkoutSetupController = Get.put(
      CreateWorkoutSetupController(),
    );
    final workoutSetupController = Get.find<WorkoutSetupController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 90),
                  SizedBox(
                    height: Get.height / 13,
                    width: Get.width / 13,
                    child: Image.asset(IconPath.splashicon),
                  ),
                  SizedBox(width: 10),

                  Text(
                    AppText.splashTitle,
                    style: getTextStyle(
                      fontSize: 20.13,
                      // height: 1,
                      //   lineHeight: 150,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    AppText.splashTitle2,
                    style: getTextStyle(
                      fontSize: 20.13,
                      //   height: 1,
                      //  lineHeight: 150,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ).paddingOnly(top: 15),

              Text(
                AppText.appsetup10Screentitle,
                style: getTextStyle1(
                  fontSize: 28,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  //  lineHeight: 38 ,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 90),
              CarouselScreen(),

              SizedBox(height: Sizer.hp(80)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {
                      createWorkoutSetupController.createOrUpdateWorkoutSetup(
                        isUpdate: workoutSetupController.isUpdate.value,
                      );
                    },
                    text:
                        workoutSetupController.isUpdate.value != true
                            ? AppText.appsetup10Screensubmit
                            : 'Update Workout',
                    fontSize: 20,
                    alignment: Alignment.center,
                    fontWeight: FontWeight.w500,
                    backgroundColor: AppColors.secondary,
                    textColor: AppColors.backgroundDark,
                    selectedColor: AppColors.secondary,
                    selectedTextColor: AppColors.backgroundDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
