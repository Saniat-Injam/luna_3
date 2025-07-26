import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/features/food_logging/controllers/add_consumed_food_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class FoodImageController extends GetxController {
  final _imagePath = Rx<String?>(null);
  String? get imagePath => _imagePath.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      _isLoading.value = true;
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _imagePath.value = pickedFile.path;
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> takePhoto() async {
    try {
      final status = await Permission.camera.status;
      if (status.isDenied) {
        final result = await Permission.camera.request();
        if (result.isDenied) {
          EasyLoading.showError(
            'Camera permission is required to take photos',
          );
          return;
        }
      }

      if (await Permission.camera.isPermanentlyDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Camera permission is permanently denied. Please enable it from settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      }

      _isLoading.value = true;
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imagePath.value = pickedFile.path;
        await Get.find<AddConsumedFoodController>()
            .addConsumedFoodByTakingPhoto(image: pickedFile);
      }
    } catch (e) {
      EasyLoading.showError('Failed to take photo');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearImage() {
    _imagePath.value = null;
  }
}
