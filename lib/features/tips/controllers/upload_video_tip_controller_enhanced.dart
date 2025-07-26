import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/core/utils/video_compression_helper.dart';
import 'package:barbell/features/tips/controllers/video_controller.dart';
import 'package:barbell/features/tips/view/fitness_tips_video_screen.dart';

/// Enhanced video tip upload controller
/// Combines the working Dio implementation from TestController with
/// the comprehensive video handling from the existing controller
class UploadVideoTipControllerEnhanced extends GetxController {
  late GlobalKey<FormState> formKey;

  // Text controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final videoUrlController = TextEditingController();
  final tagsController = TextEditingController();

  // Observable states
  final RxList<String> tags = <String>[].obs;
  final RxString errorMessage = ''.obs;
  final Rx<XFile?> selectedVideoFile = Rx<XFile?>(null);
  final RxBool isCompressing = false.obs;
  final RxDouble compressionProgress = 0.0.obs;
  final RxString compressionStatus = ''.obs;
  final RxBool isUploading = false.obs;
  final RxString uploadProgress =
      '0'.obs; // String to match TestController pattern
  final RxDouble uploadProgressDouble = 0.0.obs; // For internal calculations

  // Edit mode states
  final RxBool isEditMode = false.obs;
  final RxString editVideoId = ''.obs;

  // Dio instance with enhanced configuration
  final dio.Dio _dio = dio.Dio();
  final Logger _logger = Logger();
  dio.CancelToken? _uploadCancelToken;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    _setupDioInterceptors();
  }

  /// Setup Dio interceptors following TestController pattern
  void _setupDioInterceptors() {
    _dio.interceptors.add(
      dio.LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => _logger.d(object),
      ),
    );

    // Enhanced timeout configuration for large file uploads
    _dio.options.connectTimeout = const Duration(minutes: 2);
    _dio.options.receiveTimeout = const Duration(minutes: 15);
    _dio.options.sendTimeout = const Duration(minutes: 15);
  }

  /// Get authentication token
  String? token() {
    return StorageService.accessToken;
  }

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

  /// Set selected video file with validation
  void setVideoFile(XFile? file) async {
    if (file != null) {
      // Check file size (limit to 100MB)
      final fileSize = await file.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileSizeMB > 500) {
        errorMessage.value =
            'Video file is too large (${fileSizeMB.toStringAsFixed(1)}MB). Please select a video smaller than 500MB.';
        EasyLoading.showError(errorMessage.value);
        return;
      }

      // Check if compression is recommended
      if (fileSizeMB > 20) {
        compressionStatus.value =
            'Video is large (${fileSizeMB.toStringAsFixed(1)}MB). Compression recommended for better upload success.';
      } else {
        compressionStatus.value = '';
      }

      _logger.i(
        "Video selected: ${file.name}, Size: ${fileSizeMB.toStringAsFixed(2)}MB",
      );
    } else {
      compressionStatus.value = '';
    }

    selectedVideoFile.value = file;
    // Clear URL if file is selected
    if (file != null) {
      videoUrlController.clear();
    }
  }

  /// Compress video before upload
  Future<File?> compressVideoFile() async {
    if (selectedVideoFile.value == null) return null;

    isCompressing.value = true;
    compressionProgress.value = 0.0;
    errorMessage.value = '';

    final videoFile = File(selectedVideoFile.value!.path);
    final originalSize = await videoFile.length();
    final originalSizeMB = originalSize / (1024 * 1024);

    _logger.i(
      "Starting compression for ${originalSizeMB.toStringAsFixed(2)}MB video",
    );

    // Get recommended compression quality
    final quality = VideoCompressionHelper.getRecommendedQuality(
      originalSizeMB,
    );

    // Compress video with progress tracking
    final compressedFile = await VideoCompressionHelper.compressVideo(
      videoFile: videoFile,
      quality: quality,
      onProgress: (progress) {
        compressionProgress.value = progress;
        _logger.i("Compression progress: ${progress.toStringAsFixed(1)}%");
      },
    );

    if (compressedFile != null) {
      final compressedSize = await compressedFile.length();
      final compressedSizeMB = compressedSize / (1024 * 1024);
      final reductionPercent =
          ((originalSize - compressedSize) / originalSize * 100);

      compressionStatus.value =
          'Compressed successfully! Size reduced from ${originalSizeMB.toStringAsFixed(1)}MB to ${compressedSizeMB.toStringAsFixed(1)}MB (${reductionPercent.toStringAsFixed(1)}% reduction)';

      _logger.i(
        "Compression successful: ${compressedSizeMB.toStringAsFixed(2)}MB",
      );

      isCompressing.value = false;
      return compressedFile;
    } else {
      compressionStatus.value = 'Compression failed. Using original video.';
      _logger.e("Compression failed");

      isCompressing.value = false;
      return videoFile;
    }
  }

  /// Set edit mode for updating existing video
  void setEditMode(String videoId) {
    isEditMode.value = true;
    editVideoId.value = videoId;
    _logger.i("Edit mode enabled for video ID: $videoId");
  }

  /// Validate form before submission
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      _logger.w("Form validation failed");
      return false;
    }

    if (tags.isEmpty) {
      errorMessage.value = 'At least one tag is required';
      _logger.w("No tags provided");
      return false;
    }

    // Check if either URL or file is provided
    bool hasUrl = videoUrlController.text.trim().isNotEmpty;
    bool hasFile = selectedVideoFile.value != null;

    if (!hasUrl && !hasFile) {
      errorMessage.value =
          'Please provide either a video URL or upload a video file';
      _logger.w("No video source provided");
      return false;
    }

    if (hasUrl && hasFile) {
      errorMessage.value = 'Please provide either URL or upload file, not both';
      _logger.w("Both URL and file provided");
      return false;
    }

    _logger.i("Form validation passed");
    return true;
  }

  /// Submit video tip (create or update based on mode)
  Future<void> submitVideoTip() async {
    if (isEditMode.value) {
      await _updateVideoTip();
    } else {
      await _createVideoTip();
    }
  }

  /// Create new video tip following TestController pattern
  Future<void> _createVideoTip() async {
    if (!validateForm()) return;

    // Check authentication
    final authToken = token();
    if (authToken == null) {
      Logger().e('No authentication token found. Please login again.');
      _logger.i('No authentication token found. Please login again.');
      return;
    }

    isUploading.value = true;
    uploadProgress.value = '0';
    uploadProgressDouble.value = 0.0;
    _logger.i("Starting video tip creation...");

    XFile? finalVideoFile = selectedVideoFile.value;

    // Handle video compression if needed
    if (selectedVideoFile.value != null) {
      final videoFile = File(selectedVideoFile.value!.path);
      final fileSize = await videoFile.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      // Auto-compress files larger than 10MB
      if (fileSizeMB > 10) {
        _logger.i(
          "File size ${fileSizeMB.toStringAsFixed(2)}MB requires compression",
        );

        final compressedFile = await compressVideoFile();
        if (compressedFile != null) {
          finalVideoFile = XFile(compressedFile.path);

          // Check if still too large after compression
          final compressedSize = await compressedFile.length();
          final compressedSizeMB = compressedSize / (1024 * 1024);

          if (compressedSizeMB > 50) {
            EasyLoading.showError(
              'Compressed file is still large (${compressedSizeMB.toStringAsFixed(1)}MB). Upload may take longer.',
            );
          }
        }
      }
    }

    // Prepare upload using TestController approach
    await _uploadVideoWithDio(finalVideoFile);
  }

  /// Upload video using Dio following TestController pattern
  Future<void> _uploadVideoWithDio(XFile? videoFile) async {
    if (videoFile == null && videoUrlController.text.trim().isEmpty) {
      _showErrorToast(
        'Please select a video file or provide a video URL to continue',
      );
      return;
    }

    _logger.i("Starting video upload...");

    // Create FormData following TestController structure
    final Map<String, dynamic> jsonData = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "tag": tags.toList(),
    };

    // Add video URL if provided (and no file)
    if (videoFile == null && videoUrlController.text.trim().isNotEmpty) {
      jsonData["video"] = videoUrlController.text.trim();
    }

    dio.FormData formData;

    if (videoFile != null) {
      // Validate file size one more time
      final file = await videoFile.readAsBytes();
      final fileSizeInMB = file.length / (1024 * 1024);
      _logger.i("Final file size: ${fileSizeInMB.toStringAsFixed(2)} MB");

      if (fileSizeInMB > 500) {
        _showErrorToast(
          'Video file is too large (${fileSizeInMB.toStringAsFixed(1)}MB). Maximum 500MB allowed. Please compress or select a smaller video.',
        );
        isUploading.value = false;
        return;
      }

      // Get file extension and determine media type
      final fileExtension = videoFile.path.split('.').last.toLowerCase();
      final mediaType = _getMediaType(fileExtension);

      // Create FormData with video file
      formData = dio.FormData.fromMap({
        'data': jsonEncode(jsonData),
        'video': await dio.MultipartFile.fromFile(
          videoFile.path,
          filename:
              videoFile.name.isNotEmpty
                  ? videoFile.name
                  : 'video.$fileExtension',
          contentType: mediaType,
        ),
      });
    } else {
      // Create FormData without video file (URL only)
      formData = dio.FormData.fromMap({'data': jsonEncode(jsonData)});
    }

    _logger.i("Uploading to: ${Urls.createVideoTip}");
    _logger.i("Using token: ${token()?.substring(0, 20)}...");

    _uploadCancelToken = dio.CancelToken();

    try {
      final response = await _dio.post(
        Urls.createVideoTip,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': token(),
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
          validateStatus:
              (status) => status! < 500, // Don't throw for client errors
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100);
          uploadProgress.value = progress.toStringAsFixed(1);
          uploadProgressDouble.value = sent / total;
          _logger.i("Upload progress: ${progress.toStringAsFixed(1)}%");
        },
        cancelToken: _uploadCancelToken,
      );

      _logger.i("Response status: ${response.statusCode}");
      _logger.i("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i("Upload successful: ${response.data}");

        // Show custom success message
        final videoTitle = titleController.text.trim();
        _showSuccessToast(
          '🎉 Video tip "$videoTitle" uploaded successfully! Your fitness tip is now available to the community.',
        );

        _clearForm();

        // Refresh video list if controller exists
        _refreshVideoList();

        // Navigate back to the fitness tips video screen
        // Go back twice - once from upload screen, once more to reach the fitness tips video screen
        await Future.delayed(
          const Duration(milliseconds: 1500),
        ); // Wait for toast to show
        Get.to(() => FitnessTipsVideoScreen());
      } else {
        // Handle specific error responses and stay on screen
        final errorMsg = _extractErrorMessage(response);
        final customErrorMsg = _getCustomErrorMessage(
          response.statusCode,
          errorMsg,
        );
        _logger.e(
          "Upload failed with status ${response.statusCode}: $errorMsg",
        );
        _showErrorToast(customErrorMsg);
        // Don't navigate - stay on current screen for user to retry
      }
    } catch (e) {
      _logger.e("Upload exception: $e");

      // Handle different types of exceptions
      String errorMessage;
      if (e is dio.DioException) {
        switch (e.type) {
          case dio.DioExceptionType.connectionTimeout:
            errorMessage =
                'Connection timeout. Please check your internet connection and try again.';
            break;
          case dio.DioExceptionType.sendTimeout:
            errorMessage =
                'Upload timeout. The video might be too large or your connection is slow. Please try again.';
            break;
          case dio.DioExceptionType.receiveTimeout:
            errorMessage = 'Server response timeout. Please try again later.';
            break;
          case dio.DioExceptionType.connectionError:
            errorMessage =
                'Network connection error. Please check your internet connection.';
            break;
          case dio.DioExceptionType.cancel:
            errorMessage = 'Upload was cancelled.';
            break;
          default:
            errorMessage =
                'Upload failed due to network error. Please try again.';
        }
      } else {
        errorMessage =
            'Unexpected error occurred while uploading. Please try again.';
      }

      _showErrorToast(errorMessage);
      // Don't navigate - stay on current screen for user to retry
    } finally {
      isUploading.value = false;
      uploadProgress.value = '0';
      uploadProgressDouble.value = 0.0;
      _uploadCancelToken = null;
    }
  }

  /// Update existing video tip
  Future<void> _updateVideoTip() async {
    if (!validateForm()) return;

    // Check authentication
    final authToken = token();
    if (authToken == null) {
      _showErrorToast(
        'Authentication failed. Please log in again and try updating.',
      );
      return;
    }

    isUploading.value = true;
    uploadProgress.value = '0';
    _logger.i("Starting video tip update for ID: ${editVideoId.value}");

    // Build the request data
    final Map<String, dynamic> jsonData = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "tag": tags.toList(),
    };

    // Add video URL if provided and no file is selected
    if (selectedVideoFile.value == null &&
        videoUrlController.text.trim().isNotEmpty) {
      jsonData["video"] = videoUrlController.text.trim();
    }

    dio.FormData formData;

    if (selectedVideoFile.value != null) {
      // Handle video file compression if needed
      XFile? finalVideoFile = selectedVideoFile.value;
      final videoFile = File(selectedVideoFile.value!.path);
      final fileSize = await videoFile.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileSizeMB > 10) {
        final compressedFile = await compressVideoFile();
        if (compressedFile != null) {
          finalVideoFile = XFile(compressedFile.path);
        }
      }

      // Get file extension and determine media type
      final fileExtension = finalVideoFile!.path.split('.').last.toLowerCase();
      final mediaType = _getMediaType(fileExtension);

      formData = dio.FormData.fromMap({
        'data': jsonEncode(jsonData),
        'video': await dio.MultipartFile.fromFile(
          finalVideoFile.path,
          filename:
              finalVideoFile.name.isNotEmpty
                  ? finalVideoFile.name
                  : 'video.$fileExtension',
          contentType: mediaType,
        ),
      });
    } else {
      formData = dio.FormData.fromMap({'data': jsonEncode(jsonData)});
    }

    _uploadCancelToken = dio.CancelToken();

    try {
      final response = await _dio.put(
        Urls.updateVideoTip(editVideoId.value),
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': token(),
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
          validateStatus: (status) => status! < 500,
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100);
          uploadProgress.value = progress.toStringAsFixed(1);
          uploadProgressDouble.value = sent / total;
          _logger.i("Update progress: ${progress.toStringAsFixed(1)}%");
        },
        cancelToken: _uploadCancelToken,
      );

      _logger.i("Update response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i("Update successful");

        // Show custom success message for update
        final videoTitle = titleController.text.trim();
        _showSuccessToast(
          '✨ Video tip "$videoTitle" updated successfully! Your changes have been saved.',
        );

        _clearForm();

        // Refresh video list if controller exists
        _refreshVideoList();

        // Navigate back to the fitness tips video screen
        await Future.delayed(
          const Duration(milliseconds: 1500),
        ); // Wait for toast to show
        Get.back(); // Close upload screen
        Get.back(); // Go back to the previous screen (likely fitness tips video screen)
      } else {
        // Handle specific error responses and stay on screen
        final errorMsg = _extractErrorMessage(response);
        final customErrorMsg = _getCustomErrorMessage(
          response.statusCode,
          errorMsg,
        );
        _logger.e(
          "Update failed with status ${response.statusCode}: $errorMsg",
        );
        _showErrorToast(customErrorMsg);
        // Don't navigate - stay on current screen for user to retry
      }
    } catch (e) {
      _logger.e("Update exception: $e");

      // Handle different types of exceptions
      String errorMessage;
      if (e is dio.DioException) {
        switch (e.type) {
          case dio.DioExceptionType.connectionTimeout:
            errorMessage =
                'Connection timeout. Please check your internet connection and try again.';
            break;
          case dio.DioExceptionType.sendTimeout:
            errorMessage =
                'Update timeout. The video might be too large or your connection is slow. Please try again.';
            break;
          case dio.DioExceptionType.receiveTimeout:
            errorMessage = 'Server response timeout. Please try again later.';
            break;
          case dio.DioExceptionType.connectionError:
            errorMessage =
                'Network connection error. Please check your internet connection.';
            break;
          case dio.DioExceptionType.cancel:
            errorMessage = 'Update was cancelled.';
            break;
          default:
            errorMessage =
                'Update failed due to network error. Please try again.';
        }
      } else {
        errorMessage =
            'Unexpected error occurred while updating. Please try again.';
      }

      _showErrorToast(errorMessage);
      // Don't navigate - stay on current screen for user to retry
    } finally {
      isUploading.value = false;
      uploadProgress.value = '0';
      uploadProgressDouble.value = 0.0;
      _uploadCancelToken = null;
    }
  }

  /// Show custom success toast
  void _showSuccessToast(String message) {
    EasyLoading.showSuccess(message);
    _logger.i(message);
  }

  /// Show custom error toast
  void _showErrorToast(String message) {
    EasyLoading.showError(message);
    _logger.e(message);
  }

  /// Extract error message from response
  String _extractErrorMessage(dio.Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ??
          response?.data['error'] ??
          'Upload failed with status ${response?.statusCode}';
    }
    return 'Upload failed with status ${response?.statusCode}';
  }

  /// Get custom error message based on status code
  String _getCustomErrorMessage(int? statusCode, String originalMessage) {
    switch (statusCode) {
      case 400:
        return 'Invalid video data. Please check your video file and form details.';
      case 401:
        return 'Authentication failed. Please log in again and try uploading.';
      case 403:
        return 'Access denied. You don\'t have permission to upload videos. Please contact support.';
      case 404:
        return 'Upload endpoint not found. Please try again later or contact support.';
      case 413:
        return 'Video file is too large for the server. Please compress your video and try again.';
      case 415:
        return 'Video format not supported. Please use MP4, MOV, AVI, or WebM format.';
      case 422:
        return 'Invalid video data format. Please check all required fields and try again.';
      case 429:
        return 'Too many upload attempts. Please wait a few minutes before trying again.';
      case 500:
        return 'Server error occurred. Please try again in a few minutes.';
      case 502:
        return 'Server temporarily unavailable. Please try again later.';
      case 503:
        return 'Upload service temporarily unavailable. Please try again later.';
      default:
        return originalMessage.isEmpty
            ? 'Upload failed. Please check your connection and try again.'
            : originalMessage;
    }
  }

  /// Helper method to determine MediaType from file extension
  MediaType _getMediaType(String extension) {
    switch (extension.toLowerCase()) {
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'mov':
        return MediaType('video', 'quicktime');
      case 'avi':
        return MediaType('video', 'x-msvideo');
      case 'flv':
        return MediaType('video', 'x-flv');
      case 'webm':
        return MediaType('video', 'webm');
      case 'mkv':
        return MediaType('video', 'x-matroska');
      case '3gp':
        return MediaType('video', '3gpp');
      default:
        return MediaType('video', 'mp4'); // Default to mp4
    }
  }

  /// Test authentication
  Future<void> testAuth() async {
    final authToken = token();
    if (authToken == null) {
      EasyLoading.showError('No authentication token found');
      return;
    }

    final response = await _dio.get(
      '${Urls.baseUrl}/tips/my-tips',
      options: dio.Options(headers: {'Authorization': authToken}),
    );

    _logger.i("Auth test successful: ${response.statusCode}");
    EasyLoading.showSuccess('Authentication is working');
  }

  /// Cancel ongoing upload
  void cancelUpload() {
    if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
      _uploadCancelToken!.cancel('Upload cancelled by user');
      isUploading.value = false;
      uploadProgress.value = '0';
      uploadProgressDouble.value = 0.0;
      EasyLoading.showError('Upload cancelled by user');
      _logger.i("Upload cancelled by user");
    }
  }

  /// Cancel ongoing compression
  void cancelCompression() {
    VideoCompressionHelper.cancelCompression();
    isCompressing.value = false;
    compressionProgress.value = 0.0;
    _logger.i("Compression cancelled");
  }

  /// Clear form after successful submission
  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    videoUrlController.clear();
    tagsController.clear();
    tags.clear();
    selectedVideoFile.value = null;
    isEditMode.value = false;
    editVideoId.value = '';
    isCompressing.value = false;
    compressionProgress.value = 0.0;
    compressionStatus.value = '';
    errorMessage.value = '';
    uploadProgress.value = '0';
    uploadProgressDouble.value = 0.0;

    _logger.i("Form cleared");
  }

  /// Method to clear selected video
  void clearSelectedVideo() {
    selectedVideoFile.value = null;
    compressionStatus.value = '';
    _logger.i("Selected video cleared");
  }

  /// Refresh video list
  void _refreshVideoList() {
    // Refresh the main video list to show updated data
    final videoController = Get.find<VideoController>();
    videoController.refreshVideos();
  }

  @override
  void onClose() {
    // Cancel any ongoing uploads
    if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
      _uploadCancelToken!.cancel('Controller is being disposed');
    }

    // Cancel any ongoing compression
    if (isCompressing.value) {
      VideoCompressionHelper.cancelCompression();
    }

    // Clean up temporary files
    VideoCompressionHelper.cleanupTempFiles();

    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    videoUrlController.dispose();
    tagsController.dispose();

    super.onClose();
  }
}
