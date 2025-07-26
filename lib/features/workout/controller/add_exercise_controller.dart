// add_asset_controller.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/workout/controller/get_all_workout_controller.dart';
import 'package:barbell/features/workout/view/all_workout_screen.dart';
import 'package:logger/logger.dart';

class AddExercisecontroller extends GetxController {
  Rx<File?> pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController exerciseDescriptionController = TextEditingController();
  TextEditingController primaryMuscleGroupController = TextEditingController();
  TextEditingController exerciseTypeController = TextEditingController();

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
        EasyLoading.showSuccess('Image uploaded successfully');
      } else {
        EasyLoading.showError('No image selected');
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image');
      Logger().e('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        pickedImage.value = File(image.path);
        EasyLoading.showSuccess('Image uploaded successfully');
      } else {
        EasyLoading.showError('No image selected');
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image');
      Logger().e('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> onClickSaveExercise({bool isforAllUser = false}) async {
    EasyLoading.show(status: 'Uploading...');

    final response = await Get.find<NetworkCaller>().multipartRequest(
      url:
          isforAllUser
              ? Urls.createCommonExercise
              : Urls.createPersonalizeExercise,
      // 'https://luna3server.onrender.com/api/v1/exercise/createPersonalizeExercise',
      jsonData: {
        'name': exerciseNameController.text,
        'description': exerciseDescriptionController.text,
        'primaryMuscleGroup': primaryMuscleGroupController.text,
        'exerciseType': exerciseTypeController.text,
      },
      image: XFile(pickedImage.value?.path ?? ''),
    );

    if (response.isSuccess) {
      EasyLoading.showSuccess('${response.responseData['message']}');
      Get.offAll(
        () => const AllWorkoutScreen(),
        transition: Transition.rightToLeft,
      );
      Get.find<GetAllWorkoutController>().getAllWorkout();
    } else {
      EasyLoading.showError('Something went wrong');
      Logger().e('Failed to save exercise: ${response.errorMessage}');
    }

    EasyLoading.dismiss();
  }
}
