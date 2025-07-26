// add_asset.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/workout/controller/add_exercise_controller.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddExercisecontroller());

    final double avatarSize = MediaQuery.of(context).size.width / 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Avatar
        Center(
          child: GestureDetector(
            onTap: () {
              controller.pickImageFromGallery();
            },
            child: Container(
              width: avatarSize,
              height: avatarSize,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 1),
              ),
              child: Obx(() {
                final File? imageFile = controller.pickedImage.value;
                return ClipOval(
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child:
                        imageFile != null
                            ? Image.file(
                              imageFile,
                              width: avatarSize,
                              height: avatarSize,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              IconPath.cameraicon,
                              width: avatarSize / 4,
                              height: avatarSize / 4,
                              fit: BoxFit.cover,
                            ),
                  ),
                );
              }),
            ),
          ),
        ),

        // Text below avatar
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            "Add asset",
            style: getTextStyle1(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textWhite,
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 10);
  }
}
