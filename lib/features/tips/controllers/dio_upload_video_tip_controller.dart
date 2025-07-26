// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:barbell/core/services/dio_network_caller.dart';
// import 'package:barbell/core/services/network_caller.dart';
// import 'package:barbell/core/utils/constants/api_constants.dart';
// import 'package:barbell/core/utils/video_compression_helper.dart';
// import 'package:barbell/features/tips/controllers/video_controller.dart';
// import 'package:video_compress/video_compress.dart';

// /// Enhanced upload controller using Dio for better file upload handling
// /// Provides improved large file support and progress tracking
// class DioUploadVideoTipController extends GetxController {
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
//   final RxBool isCompressing = false.obs;
//   final RxDouble compressionProgress = 0.0.obs;
//   final RxString compressionStatus = ''.obs;
//   final RxBool isUploading = false.obs;
//   final RxDouble uploadProgress = 0.0.obs;

//   // Edit mode states
//   final RxBool isEditMode = false.obs;
//   final RxString editVideoId = ''.obs;

//   // Network service
//   final DioNetworkCaller _dioNetworkCaller = DioNetworkCaller();
//   CancelToken? _uploadCancelToken;

//   @override
//   void onInit() {
//     formKey = GlobalKey<FormState>();
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

//   /// Set selected video file with enhanced size checking
//   void setVideoFile(XFile? file) async {
//     if (file != null) {
//       // Check file size (increased limit for Dio handling)
//       final fileSize = await file.length();
//       final fileSizeMB = fileSize / (1024 * 1024);

//       if (fileSizeMB > 200) {
//         errorMessage.value =
//             'Video file is too large (${fileSizeMB.toStringAsFixed(1)}MB). Please select a video smaller than 200MB.';
//         return;
//       }

//       // Enhanced compression recommendation
//       final videoFile = File(file.path);
//       final shouldCompress = await VideoCompressionHelper.shouldCompressVideo(
//         videoFile,
//         maxSizeMB: 15, // Even more aggressive for Dio
//       );

//       if (shouldCompress) {
//         if (fileSizeMB > 30) {
//           compressionStatus.value =
//               'Video is very large (${fileSizeMB.toStringAsFixed(1)}MB). Compression required for successful upload.';
//         } else {
//           compressionStatus.value =
//               'Video is large (${fileSizeMB.toStringAsFixed(1)}MB). Compression recommended for faster upload.';
//         }
//       } else {
//         compressionStatus.value = '';
//       }
//     } else {
//       compressionStatus.value = '';
//     }

//     selectedVideoFile.value = file;
//     // Clear URL if file is selected
//     if (file != null) {
//       videoUrlController.clear();
//     }
//     update();
//   }

//   /// Compress video with enhanced progress tracking
//   Future<File?> compressVideoFile() async {
//     if (selectedVideoFile.value == null) return null;

//     try {
//       isCompressing.value = true;
//       compressionProgress.value = 0.0;
//       errorMessage.value = '';

//       EasyLoading.show(status: 'Compressing video...');

//       final videoFile = File(selectedVideoFile.value!.path);
//       final originalSize = await videoFile.length();
//       final originalSizeMB = originalSize / (1024 * 1024);

//       // Get recommended compression quality
//       final quality = VideoCompressionHelper.getRecommendedQuality(
//         originalSizeMB,
//       );

//       // Compress video with progress tracking
//       final compressedFile = await VideoCompressionHelper.compressVideo(
//         videoFile: videoFile,
//         quality: quality,
//         onProgress: (progress) {
//           compressionProgress.value = progress;
//           EasyLoading.showProgress(
//             progress / 100,
//             status: 'Compressing video... ${progress.toStringAsFixed(0)}%',
//           );
//         },
//       );

//       EasyLoading.dismiss();

//       if (compressedFile != null) {
//         final compressedSize = await compressedFile.length();
//         final compressedSizeMB = compressedSize / (1024 * 1024);
//         final reductionPercent =
//             ((originalSize - compressedSize) / originalSize * 100);

//         compressionStatus.value =
//             'Compressed successfully! Size reduced from ${originalSizeMB.toStringAsFixed(1)}MB to ${compressedSizeMB.toStringAsFixed(1)}MB (${reductionPercent.toStringAsFixed(1)}% reduction)';

//         return compressedFile;
//       } else {
//         compressionStatus.value = 'Compression failed. Using original video.';
//         return videoFile;
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       compressionStatus.value = 'Compression failed: ${e.toString()}';
//       errorMessage.value =
//           'Video compression failed. Trying with original file.';
//       return File(selectedVideoFile.value!.path);
//     } finally {
//       isCompressing.value = false;
//       compressionProgress.value = 0.0;
//     }
//   }

//   /// Set edit mode for updating existing video
//   void setEditMode(String videoId) {
//     isEditMode.value = true;
//     editVideoId.value = videoId;
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

//   /// Submit video tip with Dio upload
//   Future<void> submitVideoTip() async {
//     if (isEditMode.value) {
//       await _updateVideoTip();
//     } else {
//       await _createVideoTip();
//     }
//   }

//   /// Create new video tip with Dio upload and enhanced compression
//   Future<void> _createVideoTip() async {
//     if (!validateForm()) return;

//     try {
//       errorMessage.value = '';
//       XFile? finalVideoFile = selectedVideoFile.value;

//       // Enhanced file size handling with automatic compression
//       if (selectedVideoFile.value != null) {
//         final videoFile = File(selectedVideoFile.value!.path);
//         final fileSize = await videoFile.length();
//         final fileSizeMB = fileSize / (1024 * 1024);

//         // More aggressive auto-compression for Dio
//         if (fileSizeMB > 15) {
//           EasyLoading.show(status: 'Optimizing large video file...');

//           final compressedFile = await compressVideoFile();
//           if (compressedFile != null) {
//             finalVideoFile = XFile(compressedFile.path);

//             // Check if still too large and apply maximum compression
//             final compressedSize = await compressedFile.length();
//             final compressedSizeMB = compressedSize / (1024 * 1024);

//             if (compressedSizeMB > 25) {
//               EasyLoading.show(status: 'Applying maximum compression...');
//               final ultraCompressed = await _applyMaxCompression(
//                 compressedFile,
//               );
//               if (ultraCompressed != null) {
//                 finalVideoFile = XFile(ultraCompressed.path);
//               }
//             }
//           }
//         } else if (fileSizeMB > 8) {
//           // For medium-large files, offer compression
//           final shouldCompress =
//               await Get.dialog<bool>(
//                 AlertDialog(
//                   title: const Text('Optimize Video Upload?'),
//                   content: Text(
//                     'Your video is ${fileSizeMB.toStringAsFixed(1)}MB. Compressing it will improve upload reliability and speed. Recommend compression?',
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Get.back(result: false),
//                       child: const Text('Upload Original'),
//                     ),
//                     TextButton(
//                       onPressed: () => Get.back(result: true),
//                       child: const Text('Compress & Upload'),
//                     ),
//                   ],
//                 ),
//               ) ??
//               false;

//           if (shouldCompress) {
//             final compressedFile = await compressVideoFile();
//             if (compressedFile != null) {
//               finalVideoFile = XFile(compressedFile.path);
//             }
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

//       late final dynamic response;

//       if (finalVideoFile != null) {
//         // Upload with Dio - enhanced with progress tracking
//         response = await _uploadWithDio(jsonData, finalVideoFile);
//       } else {
//         // For URL-only uploads, use regular network caller
//         response = await Get.find<NetworkCaller>().formDataRequest(
//           url: Urls.createVideoTip,
//           jsonData: jsonData,
//         );
//       }

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
//     } finally {
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       EasyLoading.dismiss();
//     }
//   }

//   /// Apply maximum compression for very large files
//   Future<File?> _applyMaxCompression(File videoFile) async {
//     try {
//       return await VideoCompressionHelper.compressVideo(
//         videoFile: videoFile,
//         quality: VideoQuality.LowQuality,
//         onProgress: (progress) {
//           compressionProgress.value = progress;
//           EasyLoading.showProgress(
//             progress / 100,
//             status: 'Maximum compression... ${progress.toStringAsFixed(0)}%',
//           );
//         },
//       );
//     } catch (e) {
//       debugPrint('Maximum compression failed: $e');
//       return null;
//     }
//   }

//   /// Upload with Dio including progress tracking and retry logic
//   Future<dynamic> _uploadWithDio(
//     Map<String, dynamic> jsonData,
//     XFile videoFile,
//   ) async {
//     isUploading.value = true;
//     uploadProgress.value = 0.0;
//     _uploadCancelToken = _dioNetworkCaller.createCancelToken();

//     try {
//       // Show initial upload status
//       EasyLoading.show(status: 'Starting upload...');

//       final response = await _dioNetworkCaller.uploadFile(
//         url: Urls.createVideoTip,
//         data: jsonData,
//         file: videoFile,
//         fileName: "video",
//         fieldName: "data",
//         cancelToken: _uploadCancelToken,
//         onSendProgress: (sent, total) {
//           final progress = (sent / total * 100);
//           uploadProgress.value = progress;
//           EasyLoading.showProgress(
//             sent / total,
//             status: 'Uploading... ${progress.toStringAsFixed(0)}%',
//           );
//         },
//       );

//       return response;
//     } catch (e) {
//       debugPrint('Dio upload error: $e');
//       rethrow;
//     }
//   }

//   /// Update existing video tip
//   Future<void> _updateVideoTip() async {
//     if (!validateForm()) return;

//     EasyLoading.show(status: 'Updating video...');

//     // Build the request data (only include non-empty fields)
//     Map<String, dynamic> body = {};

//     if (titleController.text.trim().isNotEmpty) {
//       body['title'] = titleController.text.trim();
//     }
//     if (descriptionController.text.trim().isNotEmpty) {
//       body['description'] = descriptionController.text.trim();
//     }
//     if (tags.isNotEmpty) {
//       body['tag'] = tags.toList();
//     }

//     // Only include video URL if no file is selected and URL is provided
//     if (selectedVideoFile.value == null &&
//         videoUrlController.text.trim().isNotEmpty) {
//       body['video'] = videoUrlController.text.trim();
//     }

//     if (body.isEmpty && selectedVideoFile.value == null) {
//       EasyLoading.showError('No changes to update');
//       return;
//     }

//     // For updates, use the existing network caller for now
//     // TODO: Implement Dio update method if needed
//     late final dynamic response;

//     response = await Get.find<NetworkCaller>().multipart(
//       url: Urls.updateVideoTip(editVideoId.value),
//       type: MultipartRequestType.PUT,
//       fieldsData: body,
//       file: selectedVideoFile.value,
//       fileName: "video",
//       fieldName: "data",
//     );

//     if (response.isSuccess) {
//       EasyLoading.showSuccess('Video updated successfully');
//       _clearForm();

//       // Refresh the main video list
//       try {
//         final videoController = Get.find<VideoController>();
//         videoController.refreshVideos();
//       } catch (e) {
//         // VideoController might not be loaded, ignore
//       }

//       Get.back();
//     } else {
//       EasyLoading.showError('Failed to update video');
//     }
//   }

//   /// Cancel ongoing upload
//   void cancelUpload() {
//     _uploadCancelToken?.cancel('Upload cancelled by user');
//     isUploading.value = false;
//     uploadProgress.value = 0.0;
//     EasyLoading.dismiss();
//   }

//   /// Cancel ongoing compression
//   void cancelCompression() {
//     VideoCompressionHelper.cancelCompression();
//     isCompressing.value = false;
//     compressionProgress.value = 0.0;
//     EasyLoading.dismiss();
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
//     errorMessage.value = '';
//     isUploading.value = false;
//     uploadProgress.value = 0.0;
//   }

//   @override
//   void onClose() {
//     // Cancel any ongoing operations
//     if (isCompressing.value) {
//       VideoCompressionHelper.cancelCompression();
//     }
//     if (isUploading.value) {
//       _uploadCancelToken?.cancel();
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
