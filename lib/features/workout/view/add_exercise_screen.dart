import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/enums.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/food_logging/widgets/custom_text_field.dart';
import 'package:barbell/features/workout/controller/add_exercise_controller.dart';
import 'package:barbell/features/workout/widgets/add_asset.dart';

class AddExerciseScreen extends StatelessWidget {
  const AddExerciseScreen({super.key, this.isForAllUsers = false});

  final bool isForAllUsers;

  @override
  Widget build(BuildContext context) {
    final AddExercisecontroller addExercisecontroller = Get.put(
      AddExercisecontroller(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'Create',
                  showBackButton: true,
                  showNotification: true,
                  onBackPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(height: Sizer.hp(20)),

                // Circular Image picker widget
                UploadImageWidget(),
                SizedBox(height: Sizer.hp(20)),

                // Exercise Name
                Text(
                  "Exercise Name",
                  style: getTextStyle1(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: Sizer.hp(16)),
                CustomTextField(
                  hintText: "Enter Exercise Name",
                  controller: addExercisecontroller.exerciseNameController,
                ),

                SizedBox(height: Sizer.hp(20)),

                // Exercise Name
                Text(
                  "Exercise Description",
                  style: getTextStyle1(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: Sizer.hp(16)),
                CustomTextField(
                  hintText: "Enter Exercise Description",
                  controller:
                      addExercisecontroller.exerciseDescriptionController,
                ),

                SizedBox(height: Sizer.hp(20)),
                Text(
                  "Primary Muscle Group",
                  style: getTextStyle1(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: Sizer.hp(16)),
                CustomTextField(
                  hintText: "Enter Primary Muscle Group",
                  controller:
                      addExercisecontroller.primaryMuscleGroupController,
                ),
                SizedBox(height: Sizer.hp(20)),

                Text(
                  "Exercise Type",
                  style: getTextStyle1(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: Sizer.hp(16)),
                DropdownButtonFormField(
                  dropdownColor: AppColors.appbar,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  items:
                      ExerciseType.values
                          .map(
                            (type) => DropdownMenuItem(
                              onTap: () {
                                addExercisecontroller
                                    .exerciseTypeController
                                    .text = type.toString().split('.').last;
                              },
                              value: type,
                              child: Text(
                                type.toString().split('.').last,
                                style: AppTextStyle.f16W400(),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.appbar,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: Text(
                    "Select Exercise Type",
                    style: AppTextStyle.f16W400(),
                  ),
                ),

                SizedBox(height: Sizer.hp(25)),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        () => addExercisecontroller.onClickSaveExercise(
                          isforAllUser: isForAllUsers,
                        ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 48,
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: AppTextStyle.f16W500().copyWith(
                        color: AppColors.appbar,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Sizer.hp(25)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
