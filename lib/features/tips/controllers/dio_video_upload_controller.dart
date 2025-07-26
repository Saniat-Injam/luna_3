// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:barbell/core/services/dio_network_caller.dart';
// import 'package:barbell/core/models/response_data.dart';
// import 'package:barbell/core/utils/constants/api_constants.dart';
// import 'package:barbell/core/utils/video_compression_helper.dart';
// import 'package:video_compress/video_compress.dart';

// /// Robust Dio-based video upload controller
// /// Optimized for handling large video files with compression and retry logic
// class DioVideoUploadController extends GetxController {
//   late GlobalKey<FormState> formKey;

//   // Text controllers
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final videoUrlController = TextEditingController();
//   final tagsController = TextEditingController();

//   // Observable states
//   final RxList<String> tags = <String>[].obs;
//   final RxString errorMessage = ''.obs;
//   final Rx<XFile?> selectedVideoFile = Rx<XFile?>(null);

//   // Compression states
//   final RxBool isCompressing = false.obs;
//   final RxDouble compressionProgress = 0.0.obs;
//   final RxString compressionStatus = ''.obs;

//   // Upload states
//   final RxBool isUploading = false.obs;
//   final RxDouble uploadProgress = 0.0.obs;
//   final RxString uploadStatus = ''.obs;

//   // Edit mode states
//   final RxBool isEditMode = false.obs;
//   final RxString editVideoId = ''.obs;

//   // Network service
//   final DioNetworkCaller _dioNetworkCaller = DioNetworkCaller();
//   CancelToken? _uploadCancelToken;

//   @override
//   void onInit() {
//     formKey = GlobalKey<FormState>();
//     // Initialize Dio network caller with optimized settings for large files
//     _dioNetworkCaller.initialize();
//     super.onInit();
//   }

//   /// Add tag to the list
//   void addTag(String tag) {
//     if (tag.isNotEmpty) {
//       final newTags =
//           tag
//               .split(',')
//               .map((t) => t.trim())
//               .where((t) => t.isNotEmpty && !tags.contains(t))
//               .toList();
//       tags.addAll(newTags);
//       tagsController.clear();
//     }
//   }

//   /// Remove tag from the list
//   void removeTag(String tag) {
//     tags.remove(tag);
//   }

//   /// Set selected video file with intelligent size analysis
//   void setVideoFile(XFile? file) async {
//     if (file != null) {
//       // Check file size and provide user feedback
//       final fileSize = await file.length();
//       final fileSizeMB = fileSize / (1024 * 1024);

//       if (fileSizeMB > 100) {
//         errorMessage.value =
//             'Video file is too large (${fileSizeMB.toStringAsFixed(1)}MB). Please select a video smaller than 100MB.';
//         return;
//       }

//       // Analyze file and provide compression recommendation
//       final videoFile = File(file.path);
//       await VideoCompressionHelper.shouldCompressVideo(
//         videoFile,
//         maxSizeMB: 8, // Lower threshold for better upload success
//       );

//       if (fileSizeMB > 15) {
//         compressionStatus.value =
//             '⚠️ Very large file (${fileSizeMB.toStringAsFixed(1)}MB). Maximum compression will be applied automatically.';
//       } else if (fileSizeMB > 8) {
//         compressionStatus.value =
//             '🔄 Large file (${fileSizeMB.toStringAsFixed(1)}MB). Compression recommended for reliable upload.';
//       } else if (fileSizeMB > 5) {
//         compressionStatus.value =
//             'ℹ️ Medium file (${fileSizeMB.toStringAsFixed(1)}MB). Consider compression for faster upload.';
//       } else {
//         compressionStatus.value =
//             '✅ Good size (${fileSizeMB.toStringAsFixed(1)}MB). Ready for upload.';
//       }
//     } else {
//       compressionStatus.value = '';
//       errorMessage.value = '';
//     }

//     selectedVideoFile.value = file;
//     // Clear URL if file is selected
//     if (file != null) {
//       videoUrlController.clear();
//     }
//     update();
//   }

//   /// Compress video with progress tracking
//   Future<File?> compressVideoFile({VideoQuality? quality}) async {
//     if (selectedVideoFile.value == null) return null;

//     try {
//       isCompressing.value = true;
//       compressionProgress.value = 0.0;
//       errorMessage.value = '';

//       final videoFile = File(selectedVideoFile.value!.path);
//       final originalSize = await videoFile.length();
//       final originalSizeMB = originalSize / (1024 * 1024);

//       // Determine compression quality if not specified
//       quality ??= VideoCompressionHelper.getRecommendedQuality(originalSizeMB);

//       compressionStatus.value =
//           'Compressing ${originalSizeMB.toStringAsFixed(1)}MB video...';
//       EasyLoading.show(status: compressionStatus.value);

//       // Compress video with progress tracking
//       final compressedFile = await VideoCompressionHelper.compressVideo(
//         videoFile: videoFile,
//         quality: quality,
//         onProgress: (progress) {
//           compressionProgress.value = progress;
//           final statusText = 'Compressing... ${progress.toStringAsFixed(0)}%';
//           compressionStatus.value = statusText;
//           EasyLoading.showProgress(progress / 100, status: statusText);
//         },
//       );

//       if (compressedFile != null) {
//         final compressedSize = await compressedFile.length();
//         final compressedSizeMB = compressedSize / (1024 * 1024);
//         final reductionPercent =
//             ((originalSize - compressedSize) / originalSize * 100);

//         compressionStatus.value =
//             '✅ Compressed: ${originalSizeMB.toStringAsFixed(1)}MB → ${compressedSizeMB.toStringAsFixed(1)}MB (${reductionPercent.toStringAsFixed(1)}% reduction)';

//         EasyLoading.showSuccess('Video compressed successfully!');
//         return compressedFile;
//       } else {
//         compressionStatus.value =
//             '❌ Compression failed. Will try with original video.';
//         EasyLoading.showError('Compression failed');
//         return videoFile;
//       }
//     } catch (e) {
//       compressionStatus.value = '❌ Compression error: ${e.toString()}';
//       errorMessage.value = 'Video compression failed. Will use original file.';
//       EasyLoading.showError('Compression failed: ${e.toString()}');
//       return File(selectedVideoFile.value!.path);
//     } finally {
//       isCompressing.value = false;
//       compressionProgress.value = 0.0;
//     }
//   }

//   /// Validate form before submission
//   bool validateForm() {
//     if (!formKey.currentState!.validate()) return false;

//     if (tags.isEmpty) {
//       errorMessage.value = 'At least one tag is required';
//       return false;
//     }

//     // Check if either URL or file is provided
//     bool hasUrl = videoUrlController.text.trim().isNotEmpty;
//     bool hasFile = selectedVideoFile.value != null;

//     if (!hasUrl && !hasFile) {
//       errorMessage.value =
//           'Please provide either a video URL or upload a video file';
//       return false;
//     }

//     if (hasUrl && hasFile) {
//       errorMessage.value = 'Please provide either URL or upload file, not both';
//       return false;
//     }

//     return true;
//   }

//   /// Upload video with automatic compression and retry logic
//   Future<void> uploadVideo() async {
//     if (!validateForm()) return;

//     try {
//       errorMessage.value = '';
//       XFile? finalVideoFile = selectedVideoFile.value;

//       // Handle video file upload with smart compression
//       if (selectedVideoFile.value != null) {
//         final videoFile = File(selectedVideoFile.value!.path);
//         final fileSize = await videoFile.length();
//         final fileSizeMB = fileSize / (1024 * 1024);

//         // Automatic compression for large files
//         if (fileSizeMB > 8) {
//           final compressedFile = await compressVideoFile();
//           if (compressedFile != null) {
//             finalVideoFile = XFile(compressedFile.path);
//           }
//         }
//       }

//       // Prepare data for API
//       final Map<String, dynamic> jsonData = {
//         "title": titleController.text.trim(),
//         "description": descriptionController.text.trim(),
//         "tag": tags.toList(),
//         "favCount": 0,
//       };

//       // Add video URL if provided
//       if (videoUrlController.text.trim().isNotEmpty) {
//         jsonData["video"] = videoUrlController.text.trim();
//       }

//       // Upload with robust error handling
//       final response = await _uploadWithRetry(jsonData, finalVideoFile);

//       if (response.isSuccess) {
//         EasyLoading.showSuccess('Video tip uploaded successfully!');
//         _clearForm();
//         Get.back();
//       } else {
//         errorMessage.value =
//             response.errorMessage ?? 'Failed to upload video tip';
//         EasyLoading.showError(errorMessage.value);
//       }
//     } catch (e) {
//       errorMessage.value = 'Upload failed: ${e.toString()}';
//       EasyLoading.showError(errorMessage.value);
//     }
//   }

//   /// Upload with intelligent retry logic using Dio
//   Future<ResponseData> _uploadWithRetry(
//     Map<String, dynamic> jsonData,
//     XFile? videoFile, {
//     int maxRetries = 3,
//   }) async {
//     if (videoFile == null) {
//       // Handle URL-only uploads (not implemented in this example)
//       return ResponseData(
//         isSuccess: false,
//         statusCode: 400,
//         errorMessage: 'File upload is required for this implementation',
//       );
//     }

//     int retryCount = 0;
//     XFile currentVideoFile = videoFile;
//     ResponseData? response;

//     // Initialize upload tracking
//     isUploading.value = true;
//     uploadProgress.value = 0.0;
//     _uploadCancelToken = CancelToken();

//     while (retryCount <= maxRetries) {
//       try {
//         if (retryCount > 0) {
//           uploadStatus.value =
//               'Retrying upload... (${retryCount + 1}/${maxRetries + 1})';
//           EasyLoading.show(status: uploadStatus.value);
//           await Future.delayed(const Duration(seconds: 2));
//         } else {
//           uploadStatus.value = 'Starting upload...';
//           EasyLoading.show(status: uploadStatus.value);
//         }

//         // Upload using Dio with progress tracking
//         response = await _dioNetworkCaller.uploadFile(
//           url: Urls.createVideoTip,
//           data: jsonData,
//           file: currentVideoFile,
//           fileName: "video",
//           fieldName: "data",
//           onSendProgress: (sent, total) {
//             uploadProgress.value = sent / total;
//             final progressPercent = (uploadProgress.value * 100)
//                 .toStringAsFixed(0);
//             uploadStatus.value = 'Uploading... $progressPercent%';
//             EasyLoading.showProgress(
//               uploadProgress.value,
//               status: uploadStatus.value,
//             );
//           },
//           cancelToken: _uploadCancelToken,
//         );

//         // Check if upload was successful
//         if (response.isSuccess) {
//           uploadProgress.value = 1.0;
//           uploadStatus.value = 'Upload completed successfully!';
//           break;
//         }

//         // Handle specific error codes with compression retry
//         if (_shouldRetryWithCompression(response.statusCode) &&
//             retryCount < maxRetries) {
//           final compressedFile = await _retryWithCompression(
//             currentVideoFile,
//             retryCount,
//           );
//           if (compressedFile != null) {
//             currentVideoFile = XFile(compressedFile.path);
//           }
//         }

//         retryCount++;
//       } catch (e) {
//         if (e is DioException && e.type == DioExceptionType.cancel) {
//           response = ResponseData(
//             isSuccess: false,
//             statusCode: 499,
//             errorMessage: 'Upload cancelled by user',
//           );
//           break;
//         }

//         retryCount++;
//         if (retryCount > maxRetries) {
//           response = ResponseData(
//             isSuccess: false,
//             statusCode: 500,
//             errorMessage:
//                 'Upload failed after multiple attempts: ${e.toString()}',
//           );
//           break;
//         }

//         // Wait before retrying
//         await Future.delayed(Duration(seconds: retryCount * 2));
//       }
//     }

//     // Clean up
//     isUploading.value = false;
//     uploadProgress.value = 0.0;
//     uploadStatus.value = '';
//     _uploadCancelToken = null;

//     return response ??
//         ResponseData(
//           isSuccess: false,
//           statusCode: 500,
//           errorMessage: 'Upload failed after all retry attempts',
//         );
//   }

//   /// Check if error code warrants compression retry
//   bool _shouldRetryWithCompression(int statusCode) {
//     return [413, 502, 520, 504].contains(statusCode);
//   }

//   /// Retry with more aggressive compression
//   Future<File?> _retryWithCompression(XFile currentFile, int retryCount) async {
//     final videoFile = File(currentFile.path);
//     final fileSize = await videoFile.length();
//     final fileSizeMB = fileSize / (1024 * 1024);

//     if (fileSizeMB <= 2) {
//       // Already very small, can't compress much more
//       return null;
//     }

//     VideoQuality quality;
//     String compressionType;

//     if (retryCount == 1) {
//       quality = VideoQuality.MediumQuality;
//       compressionType = 'medium compression';
//     } else {
//       quality = VideoQuality.LowQuality;
//       compressionType = 'maximum compression';
//     }

//     compressionStatus.value =
//         'Server rejected file, applying $compressionType...';
//     EasyLoading.show(status: compressionStatus.value);

//     try {
//       final compressedFile = await VideoCompressionHelper.compressVideo(
//         videoFile: videoFile,
//         quality: quality,
//         onProgress: (progress) {
//           compressionProgress.value = progress;
//           EasyLoading.showProgress(
//             progress / 100,
//             status: 'Retry compression... ${progress.toStringAsFixed(0)}%',
//           );
//         },
//       );

//       if (compressedFile != null) {
//         final newSize = await compressedFile.length();
//         final newSizeMB = newSize / (1024 * 1024);
//         compressionStatus.value =
//             'Compressed to ${newSizeMB.toStringAsFixed(1)}MB for retry';
//       }

//       return compressedFile;
//     } catch (e) {
//       compressionStatus.value = 'Retry compression failed: ${e.toString()}';
//       return null;
//     }
//   }

//   /// Cancel ongoing upload
//   void cancelUpload() {
//     if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
//       _uploadCancelToken!.cancel('Upload cancelled by user');
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       uploadStatus.value = '';
//       EasyLoading.dismiss();
//     }
//   }

//   /// Cancel ongoing compression
//   void cancelCompression() {
//     VideoCompressionHelper.cancelCompression();
//     isCompressing.value = false;
//     compressionProgress.value = 0.0;
//     compressionStatus.value = '';
//     EasyLoading.dismiss();
//   }

//   /// Set edit mode for updating existing video
//   void setEditMode(String videoId) {
//     isEditMode.value = true;
//     editVideoId.value = videoId;
//   }

//   /// Clear form after successful submission
//   void _clearForm() {
//     titleController.clear();
//     descriptionController.clear();
//     videoUrlController.clear();
//     tagsController.clear();
//     tags.clear();
//     selectedVideoFile.value = null;
//     isEditMode.value = false;
//     editVideoId.value = '';
//     isCompressing.value = false;
//     compressionProgress.value = 0.0;
//     compressionStatus.value = '';
//     isUploading.value = false;
//     uploadProgress.value = 0.0;
//     uploadStatus.value = '';
//     errorMessage.value = '';
//   }

//   @override
//   void onClose() {
//     // Cancel any ongoing operations
//     if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
//       _uploadCancelToken!.cancel('Controller is being disposed');
//     }

//     if (isCompressing.value) {
//       VideoCompressionHelper.cancelCompression();
//     }

//     // Clean up temporary files
//     VideoCompressionHelper.cleanupTempFiles();

//     // Dispose controllers
//     titleController.dispose();
//     descriptionController.dispose();
//     videoUrlController.dispose();
//     tagsController.dispose();

//     super.onClose();
//   }
// }
