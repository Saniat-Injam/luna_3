import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/tips/controllers/article_controller.dart';

/// Controller for uploading article tips
/// Handles article tip creation with API integration
class UploadArticleTipController extends GetxController {
  late GlobalKey<FormState> formKey;

  // Text controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();
  final tagsController = TextEditingController();

  // Observable states
  final RxList<String> tags = <String>[].obs;
  final RxString errorMessage = ''.obs;
  final Rx<XFile?> selectedImageFile = Rx<XFile?>(null);

  // Loading state
  final isLoading = false.obs;

  // Edit mode states
  final RxBool isEditMode = false.obs;
  final RxString editArticleId = ''.obs;

  // Network service
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Add tag to the list
  void addTag(String tag) {
    if (tag.isNotEmpty) {
      final newTags =
          tag
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty && !tags.contains(t))
              .toList();
      tags.addAll(newTags);
      tagsController.clear();
    }
  }

  /// Remove tag from the list
  void removeTag(String tag) {
    tags.remove(tag);
  }

  /// Set selected image file
  void setImageFile(XFile? file) {
    selectedImageFile.value = file;
    // Clear URL if file is selected
    if (file != null) {
      imageUrlController.clear();
    }
    update();
  }

  /// Set edit mode for updating existing article
  void setEditMode(String articleId) {
    isEditMode.value = true;
    editArticleId.value = articleId;
  }

  /// Validate form before submission
  bool validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (tags.isEmpty) {
      errorMessage.value = 'At least one tag is required';
      return false;
    }

    // Check if either URL or file is provided (both are optional for articles)
    bool hasUrl = imageUrlController.text.trim().isNotEmpty;
    bool hasFile = selectedImageFile.value != null;

    if (hasUrl && hasFile) {
      errorMessage.value = 'Please provide either URL or upload file, not both';
      return false;
    }

    return true;
  }

  /// Submit article tip (create or update based on mode)
  Future<void> submitArticleTip() async {
    if (isEditMode.value) {
      await _updateArticleTip();
    } else {
      await _createArticleTip();
      await _createArticleTip();
    }
  }

  /// Create new article tip
  Future<void> _createArticleTip() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Show loading with EasyLoading
      EasyLoading.show(status: 'Uploading article...');
      errorMessage.value = '';

      // Prepare data for API
      final Map<String, dynamic> jsonData = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "tag": tags.toList(),
        "favCount": 0,
      };

      // Add image URL if provided
      if (imageUrlController.text.trim().isNotEmpty) {
        jsonData["image"] = imageUrlController.text.trim();
      }

      late final dynamic response;

      if (selectedImageFile.value != null) {
        // Upload with image file
        response = await _networkCaller.multipartRequest(
          url: Urls.createArticalTip,
          jsonData: jsonData,
          image: selectedImageFile.value!,
          fileName: "image",
        );
      } else {
        // Post without file (URL only or no image)
        response = await _networkCaller.formDataRequest(
          url: Urls.createArticalTip,
          jsonData: jsonData,
        );
      }

      if (response.isSuccess) {
        EasyLoading.showSuccess('Article uploaded successfully!');
        _clearForm();
        Get.back();
      } else {
        EasyLoading.showError('Failed to upload article');
      }
    } catch (e) {
      EasyLoading.showError('Error uploading article');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  /// Update existing article tip
  Future<void> _updateArticleTip() async {
    if (!validateForm()) return;

    isLoading.value = true;

    EasyLoading.show(status: 'Updating article...');

    // Build the request data (only include non-empty fields)
    Map<String, dynamic> body = {};

    if (titleController.text.trim().isNotEmpty) {
      body['title'] = titleController.text.trim();
    }
    if (descriptionController.text.trim().isNotEmpty) {
      body['description'] = descriptionController.text.trim();
    }
    if (tags.isNotEmpty) {
      body['tag'] = tags.toList();
    }

    // Only include image URL if no file is selected and URL is provided
    if (selectedImageFile.value == null &&
        imageUrlController.text.trim().isNotEmpty) {
      body['image'] = imageUrlController.text.trim();
    }

    if (body.isEmpty && selectedImageFile.value == null) {
      EasyLoading.showError('No changes to update');
      return;
    }

    late final dynamic response;

    // Use PUT method with form-data and "data" field (confirmed working in Postman)
    response = await _networkCaller.multipart(
      url: Urls.updateArticleTip(editArticleId.value),
      type: MultipartRequestType.PUT,
      fieldsData: body,
      file: selectedImageFile.value,
      fileName: "image",
      fieldName: "data",
    );

    if (response.isSuccess) {
      EasyLoading.showSuccess('Article updated successfully');
      _clearForm();

      // Refresh the main article list to show updated data
      try {
        final articleController = Get.find<ArticleController>();
        articleController.refreshArticles();
      } catch (e) {
        // ArticleController might not be loaded, ignore
      }

      Get.back();
    } else {
      EasyLoading.showError('Failed to update article');
    }
  }

  /// Clear form after successful submission
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    imageUrlController.clear();
    tagsController.clear();
    tags.clear();
    selectedImageFile.value = null;
    isEditMode.value = false;
    editArticleId.value = '';
  }

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    tagsController.dispose();
    super.onClose();
  }
}
