import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/habits/controller/create_habit_controller.dart';

class CreateHabitView extends StatelessWidget {
  const CreateHabitView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateHabitController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(title: 'Create Habit for All Users'),
      bottomNavigationBar: CustomBottomNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizer.wp(20)),
          child: Column(
            spacing: Sizer.hp(20),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return GestureDetector(
                  onTap: () => _onClickPickSvgIcon(controller),
                  child: Container(
                    // padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            controller.habitIcon.value?.path != null
                                ? Colors.transparent
                                : Colors.grey,
                      ),
                      // color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                        controller.habitIcon.value?.path == null
                            ? const Icon(
                              Icons.add,
                              size: 80,
                              color: Colors.white,
                            )
                            : SvgPicture.file(
                              File(controller.habitIcon.value!.path),
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.file(
                                  File(controller.habitIcon.value!.path),
                                  width: 120,
                                  height: 120,
                                );
                              },
                            ),
                  ),
                );
              }),
              Obx(
                () => Text(
                  controller.habitIcon.value?.path != null
                      ? "Change Icon"
                      : 'Select Icon',
                  style: AppTextStyle.f16W500(),
                ),
              ),

              // Input fields
              _buildInputField(
                title: 'Habit Name',
                controller: controller.habitNameController,
              ),
              _buildInputField(
                title: 'Habit Description',
                maxLines: 3,
                controller: controller.habitDescriptionController,
              ),

              SizedBox(height: Sizer.hp(48)),

              FilledButton(
                onPressed: () {
                  controller.createHabit();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    int? maxLines,
    TextEditingController? controller,
  }) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      controller: controller,
      style: AppTextStyle.f16W500(),
      decoration: InputDecoration(
        hintText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onClickPickSvgIcon(CreateHabitController controller) async {
    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        controller.habitIcon.value = value;
      }
    });
  }
}
