import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/profile/models/profile_model.dart';

class ProfileController extends GetxController {
  bool isLoading = false;
  bool isSuccess = false;
  String errorMessage = '';
  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  // Profile Image
  final pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Notification toggle state
  var isNotificationEnabled = true.obs;
  var isNotificationToggling = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize notification state - you might want to get this from user preferences or API
    // For now, defaulting to enabled
    isNotificationEnabled.value = true;
  }

  // ------------------------------------------------------
  //! Get Profile Data
  // ------------------------------------------------------
  Future<bool> getProfileData() async {
    isLoading = true;
    isSuccess = false;
    errorMessage = '';
    update();
    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getProfile,
    );

    if (response.isSuccess) {
      _profileModel = ProfileModel.fromJson(response.responseData['data']);
      if (_profileModel?.userId.role == 'user' ||
          _profileModel?.userId.role == 'admin') {
        await StorageService.saveIsWorkoutSettedup(
          true,
        ); // response success means workout setup is done
        await StorageService.saveRole(_profileModel?.userId.role ?? '');
      }
      isSuccess = true;

      // Initialize notification state from user preferences or default to enabled
      // You can extend this to read from the profile data if the API returns notification status
      _initializeNotificationState();

      // await StorageService.saveAuthData(profile: _profileModel);
    } else {
      isSuccess = false;
      errorMessage = response.errorMessage ?? 'Failed to fetch profile data';
      EasyLoading.showError(
        'Failed to fetch profile data',
        duration: const Duration(seconds: 2),
      );
      Logger().e('Failed to fetch profile data: ${response.errorMessage}');
    }
    isLoading = false;
    update();
    return isSuccess;
  }

  void handlePickedImage(File imageFile) async {
    pickedImage.value = imageFile;
    EasyLoading.show(status: 'uploading...');
    final response = await Get.find<NetworkCaller>().multipartRequest(
      url: Urls.uploadOrChangeImg,
      jsonData: {},
      fileName: "files",
      image: XFile(imageFile.path),
    );
    if (response.isSuccess) {
      await getProfileData();
      EasyLoading.showSuccess('Image uploaded successfully');
    } else {
      pickedImage.value = null;
      EasyLoading.showError('Failed to upload image');
    }
    EasyLoading.dismiss();
  }

  // ------------------------------------------------------
  //! update profile data
  // ------------------------------------------------------
  Future<bool> updateProfileData({required Map<String, dynamic> data}) async {
    EasyLoading.show(status: 'Loading...');
    final response = await Get.find<NetworkCaller>().patchRequest(
      url: Urls.updateProfileData,
      body: data,
    );

    if (response.isSuccess) {
      await getProfileData();
      EasyLoading.showSuccess('Profile updated successfully');
      return true;
    } else {
      EasyLoading.showError('Failed to update profile data');
      Logger().e('Failed to update profile data: ${response.errorMessage}');
      return false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        pickedImage.value = File(image.path);
        handlePickedImage(File(image.path));
      }
      Get.back(); // Close bottom sheet
    } catch (e) {
      Logger().e('Failed to pick image: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }

  /// Toggle notification on/off
  Future<void> toggleNotification(bool enabled) async {
    try {
      isNotificationToggling.value = true;

      final response = await Get.find<NetworkCaller>().patchRequest(
        url: Urls.notificationOnOff,
        body: {"enabled": enabled},
      );

      if (response.isSuccess) {
        isNotificationEnabled.value = enabled;
        // Save preference locally
        await _saveNotificationPreference(enabled);

        EasyLoading.showSuccess(
          enabled ? 'Notifications enabled' : 'Notifications disabled',
          duration: const Duration(seconds: 1),
        );
      } else {
        // Revert the switch state on failure
        isNotificationEnabled.value = !enabled;
        EasyLoading.showError(
          'Failed to update notification settings',
          duration: const Duration(seconds: 2),
        );
        Logger().e('Failed to update notification settings: ${response.errorMessage}');
      }
    } catch (e) {
      // Revert the switch state on error
      isNotificationEnabled.value = !enabled;
      EasyLoading.showError(
        'An error occurred while updating notification settings',
        duration: const Duration(seconds: 2),
      );
      Logger().e('An error occurred while updating notification settings: $e');
    } finally {
      isNotificationToggling.value = false;
    }
  }

  /// Initialize notification state from stored preferences
  void _initializeNotificationState() async {
    // Read from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedState =
        prefs.getBool('notification_enabled') ?? true; // Default to enabled
    isNotificationEnabled.value = storedState;
  }

  /// Save notification preference to local storage
  Future<void> _saveNotificationPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', enabled);
  }
}
