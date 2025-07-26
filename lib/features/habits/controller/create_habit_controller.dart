import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/habits/controller/get_habit_controller.dart';
import 'package:logger/logger.dart';

class CreateHabitController extends GetxController {
  Rx<XFile?> habitIcon = Rx<XFile?>(null);
  final picker = ImagePicker();
  final habitNameController = TextEditingController();
  final habitDescriptionController = TextEditingController();

  Future<void> createHabit() async {
    if (habitIcon.value == null) {
      EasyLoading.showError('❌ Please select an icon');
      return;
    }
    if (habitNameController.text.isEmpty) {
      EasyLoading.showError('❌ Please enter a habit name');
      return;
    }
    if (habitDescriptionController.text.isEmpty) {
      EasyLoading.showError('❌ Please enter a habit description');
      return;
    }
    EasyLoading.show(status: 'Loading...');
    final Map<String, dynamic> jsonData = {
      'name': habitNameController.text,
      'description': habitDescriptionController.text,
    };

    final response = await Get.find<NetworkCaller>().multipartRequest(
      url: Urls.createHabit,
      jsonData: jsonData,
      image: habitIcon.value,
    );
    if (response.isSuccess) {
      EasyLoading.showSuccess('✅ ${response.responseData['message']}');
      Get.find<GetHabitController>().getHabits();
      Get.back();
    } else {
      EasyLoading.showError('Something went wrong');
      Logger().e('Error: ${response.errorMessage}');
    }
    EasyLoading.dismiss();
  }
}
