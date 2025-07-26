import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/features/profile/models/privacy_policy_model.dart';
import 'package:barbell/features/profile/services/privacy_policy_service.dart';
import 'package:logger/logger.dart';


class PrivacyPolicyController extends GetxController {
  final Logger _logger = Logger();

  // Observable variables
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isCreating = false.obs;
  var isDeleting = false.obs;
  var privacyPolicies = <PrivacyPolicyModel>[].obs;
  var currentPrivacyPolicy = Rxn<PrivacyPolicyModel>();
  var errorMessage = ''.obs;

  // Check if user is admin
  bool get isAdmin => StorageService.role == 'admin';

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
  }

  /// Load privacy policy from API
  Future<void> loadPrivacyPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await PrivacyPolicyService.getPrivacyPolicy();

      if (response.isSuccess) {
        final privacyPolicyResponse =
            response.responseData as PrivacyPolicyResponse;
        privacyPolicies.value = privacyPolicyResponse.data;

        // Set the first policy as current (usually there's only one)
        if (privacyPolicyResponse.data.isNotEmpty) {
          currentPrivacyPolicy.value = privacyPolicyResponse.data.first;
        }

        _logger.i('Privacy policy loaded successfully');
      } else {
        errorMessage.value = 'Failed to load privacy policy';
        _logger.e('Failed to load privacy policy: ${response.errorMessage}');

        // Show error snackbar
        EasyLoading.showError(
          'Failed to load privacy policy',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      _logger.e('Error loading privacy policy: $e');

      EasyLoading.showError(
        'An unexpected error occurred',
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update privacy policy (Admin only)
  Future<void> updatePrivacyPolicy({
    required String title,
    required String content,
    String? version,
  }) async {
    if (!isAdmin) {
      EasyLoading.showError(
        'Access Denied',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (currentPrivacyPolicy.value == null) {
      EasyLoading.showError(
        'No privacy policy found to update',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isUpdating.value = true;
      errorMessage.value = '';

      final response = await PrivacyPolicyService.updatePrivacyPolicy(
        id: currentPrivacyPolicy.value!.id,
        title: title,
        content: content,
        version: version,
      );

      if (response.isSuccess) {
        _logger.i('Privacy policy updated successfully');

        // Show success message
        EasyLoading.showSuccess(
          'Privacy policy updated successfully',
          duration: const Duration(seconds: 2),
        );

        // Reload the privacy policy to get the updated content
        await loadPrivacyPolicy();
      } else {
        errorMessage.value = 'Failed to update privacy policy';
        _logger.e('Failed to update privacy policy: ${response.errorMessage}');

        EasyLoading.showError(
          'Failed to update privacy policy',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      _logger.e('Error updating privacy policy: $e');

      EasyLoading.showError(
        'An unexpected error occurred while updating',
        duration: const Duration(seconds: 2),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Create privacy policy (Admin only)
  Future<void> createPrivacyPolicy({
    required String title,
    required String content,
    String? version,
  }) async {
    if (!isAdmin) {
      EasyLoading.showError(
        'Access Denied',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isCreating.value = true;
      errorMessage.value = '';

      final response = await PrivacyPolicyService.createPrivacyPolicy(
        title: title,
        content: content,
        version: version ?? '1.0',
      );

      if (response.isSuccess) {
        _logger.i('Privacy policy created successfully');

        // Show success message
        EasyLoading.showSuccess(
          'Privacy policy created successfully',
          duration: const Duration(seconds: 2),
        );

        // Reload the privacy policy to get the updated content
        await loadPrivacyPolicy();
      } else {
        errorMessage.value = 'Failed to create privacy policy';
        _logger.e('Failed to create privacy policy: ${response.errorMessage}');

        EasyLoading.showError(
          'Failed to create privacy policy',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      _logger.e('Error creating privacy policy: $e');

      EasyLoading.showError(
        'An unexpected error occurred while creating',
        duration: const Duration(seconds: 2),
      );
    } finally {
      isCreating.value = false;
    }
  }

  /// Delete privacy policy (Admin only)
  Future<void> deletePrivacyPolicy() async {
    if (!isAdmin) {
      EasyLoading.showError(
        'Access Denied',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (currentPrivacyPolicy.value == null) {
      EasyLoading.showError(
        'No privacy policy found to delete',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isDeleting.value = true;
      errorMessage.value = '';

      final response = await PrivacyPolicyService.deletePrivacyPolicy(
        currentPrivacyPolicy.value!.id,
      );

      if (response.isSuccess) {
        _logger.i('Privacy policy deleted successfully');

        // Show success message
        EasyLoading.showSuccess(
          'Privacy policy deleted successfully',
          duration: const Duration(seconds: 2),
        );

        // Clear current privacy policy and reload
        currentPrivacyPolicy.value = null;
        privacyPolicies.clear();
        await loadPrivacyPolicy();
      } else {
        errorMessage.value = 'Failed to delete privacy policy';
        _logger.e('Failed to delete privacy policy: ${response.errorMessage}');

        EasyLoading.showError(
          'Failed to delete privacy policy',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      _logger.e('Error deleting privacy policy: $e');

      EasyLoading.showError(
        'An unexpected error occurred while deleting',
        duration: const Duration(seconds: 2),
      );
    } finally {
      isDeleting.value = false;
    }
  }

  /// Refresh privacy policy
  Future<void> refreshPrivacyPolicy() async {
    await loadPrivacyPolicy();
  }
}
