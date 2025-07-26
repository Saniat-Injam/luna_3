// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:barbell/core/services/network_caller.dart';
// import 'package:barbell/core/services/dio_network_caller.dart';
// import 'package:barbell/core/models/response_data.dart';
// import 'package:barbell/core/utils/constants/api_constants.dart';
// import 'package:barbell/core/utils/video_compression_helper.dart';
// import 'package:barbell/features/tips/controllers/video_controller.dart';
// import 'package:video_compress/video_compress.dart';

// /// Controller for uploading video tips
// /// Handles video tip creation with API integration
// class UploadVideoTipController extends GetxController {
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
//   final NetworkCaller _networkCaller = NetworkCaller();
//   final DioNetworkCaller _dioNetworkCaller = DioNetworkCaller();
//   CancelToken? _uploadCancelToken;

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

//   /// Set selected video file with compression check
//   void setVideoFile(XFile? file) async {
//     if (file != null) {
//       // Check file size (limit to 100MB for videos)
//       final fileSize = await file.length();
//       final fileSizeMB = fileSize / (1024 * 1024);

//       if (fileSizeMB > 100) {
//         errorMessage.value =
//             'Video file is too large (${fileSizeMB.toStringAsFixed(1)}MB). Please select a video smaller than 100MB.';
//         return;
//       }

//       // Check if compression is needed - lower threshold for automatic compression
//       final videoFile = File(file.path);
//       final shouldCompress = await VideoCompressionHelper.shouldCompressVideo(
//         videoFile,
//         maxSizeMB: 10, // Reduced from 25MB to 10MB for better success rate
//       );

//       if (shouldCompress) {
//         compressionStatus.value =
//             'Video is large (${fileSizeMB.toStringAsFixed(1)}MB). Compression strongly recommended for successful upload.';
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

//   /// Compress video before upload
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

//   /// Compress video with maximum quality reduction for very large files
//   Future<File?> _compressWithMaxQuality(File videoFile) async {
//     try {
//       isCompressing.value = true;
//       compressionProgress.value = 0.0;

//       EasyLoading.show(status: 'Applying maximum compression...');

//       // Use lowest quality for maximum compression
//       final compressedFile = await VideoCompressionHelper.compressVideo(
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

//       EasyLoading.dismiss();
//       return compressedFile;
//     } catch (e) {
//       EasyLoading.dismiss();
//       compressionStatus.value = 'Maximum compression failed: ${e.toString()}';
//       return null;
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

//   /// Submit video tip (create or update based on mode)
//   Future<void> submitVideoTip() async {
//     if (isEditMode.value) {
//       await _updateVideoTip();
//     } else {
//       await _createVideoTip();
//     }
//   }

//   /// Create new video tip with compression and retry logic
//   Future<void> _createVideoTip() async {
//     if (!validateForm()) return;

//     try {
//       errorMessage.value = '';
//       XFile? finalVideoFile = selectedVideoFile.value;

//       // If we have a video file, check if compression is needed
//       if (selectedVideoFile.value != null) {
//         final videoFile = File(selectedVideoFile.value!.path);
//         final fileSize = await videoFile.length();
//         final fileSizeMB = fileSize / (1024 * 1024);

//         // Auto-compress files larger than 10MB without asking
//         if (fileSizeMB > 10) {
//           EasyLoading.show(status: 'Compressing large video file...');

//           final compressedFile = await compressVideoFile();
//           if (compressedFile != null) {
//             finalVideoFile = XFile(compressedFile.path);

//             // Check compressed file size
//             final compressedSize = await compressedFile.length();
//             final compressedSizeMB = compressedSize / (1024 * 1024);

//             if (compressedSizeMB > 15) {
//               // If still too large after compression, try with lower quality
//               EasyLoading.show(
//                 status: 'File still large, applying maximum compression...',
//               );
//               final ultraCompressedFile = await _compressWithMaxQuality(
//                 compressedFile,
//               );
//               if (ultraCompressedFile != null) {
//                 finalVideoFile = XFile(ultraCompressedFile.path);
//               }
//             }
//           }
//         } else if (fileSizeMB > 5) {
//           // For medium files (5-10MB), offer compression choice
//           final shouldCompress =
//               await Get.dialog<bool>(
//                 AlertDialog(
//                   title: const Text('Optimize Video?'),
//                   content: Text(
//                     'Your video is ${fileSizeMB.toStringAsFixed(1)}MB. Compressing it will improve upload success rate. Would you like to compress it?',
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

//         EasyLoading.show(status: 'Uploading video...');
//       } else {
//         EasyLoading.show(status: 'Creating video tip...');
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
//         // Upload with video file - with retry logic
//         response = await _uploadWithRetry(jsonData, finalVideoFile);
//       } else {
//         // Post without file (URL only)
//         response = await _networkCaller.formDataRequest(
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
//       EasyLoading.dismiss();
//     }
//   }

//   /// Upload with retry logic for better success rate using Dio
//   Future<dynamic> _uploadWithRetry(
//     Map<String, dynamic> jsonData,
//     XFile videoFile, {
//     int maxRetries = 3,
//   }) async {
//     dynamic response;
//     int retryCount = 0;
//     XFile currentVideoFile = videoFile;

//     // Initialize progress tracking
//     isUploading.value = true;
//     uploadProgress.value = 0.0;

//     // Create cancel token for this upload
//     _uploadCancelToken = CancelToken();

//     while (retryCount <= maxRetries) {
//       try {
//         if (retryCount > 0) {
//           EasyLoading.show(
//             status: 'Retrying upload... (${retryCount + 1}/${maxRetries + 1})',
//           );
//           await Future.delayed(
//             const Duration(seconds: 2),
//           ); // Brief delay before retry
//         }

//         // Use Dio for better handling of large files
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
//             EasyLoading.showProgress(
//               uploadProgress.value,
//               status: 'Uploading... $progressPercent%',
//             );
//           },
//           cancelToken: _uploadCancelToken,
//         );

//         // If successful, break out of retry loop
//         if (response.isSuccess) {
//           uploadProgress.value = 1.0;
//           break;
//         }

//         // On 502, 520, or other server errors, try compressing more aggressively
//         if ((response.statusCode == 502 ||
//                 response.statusCode == 520 ||
//                 response.statusCode == 413) &&
//             retryCount < maxRetries) {
//           EasyLoading.show(
//             status: 'Server rejected file, compressing video further...',
//           );

//           final videoFileToCompress = File(currentVideoFile.path);
//           final fileSize = await videoFileToCompress.length();
//           final fileSizeMB = fileSize / (1024 * 1024);

//           // Apply more aggressive compression
//           File? compressedFile;
//           if (fileSizeMB > 3) {
//             // Lower threshold for compression
//             if (retryCount == 1) {
//               // First retry: medium compression
//               compressedFile = await VideoCompressionHelper.compressVideo(
//                 videoFile: videoFileToCompress,
//                 quality: VideoQuality.MediumQuality,
//                 onProgress: (progress) {
//                   EasyLoading.showProgress(
//                     progress / 100,
//                     status:
//                         'Compressing for retry... ${progress.toStringAsFixed(0)}%',
//                   );
//                 },
//               );
//             } else {
//               // Second retry and beyond: maximum compression
//               compressedFile = await VideoCompressionHelper.compressVideo(
//                 videoFile: videoFileToCompress,
//                 quality: VideoQuality.LowQuality,
//                 onProgress: (progress) {
//                   EasyLoading.showProgress(
//                     progress / 100,
//                     status:
//                         'Maximum compression... ${progress.toStringAsFixed(0)}%',
//                   );
//                 },
//               );
//             }

//             if (compressedFile != null) {
//               currentVideoFile = XFile(compressedFile.path);
//               final newSize = await compressedFile.length();
//               final newSizeMB = newSize / (1024 * 1024);
//               compressionStatus.value =
//                   'Compressed to ${newSizeMB.toStringAsFixed(1)}MB for retry';
//             }
//           }
//         }

//         retryCount++;

//         // If this was the last retry, break
//         if (retryCount > maxRetries) {
//           break;
//         }
//       } catch (e) {
//         // Handle DioException specifically
//         if (e is DioException && e.type == DioExceptionType.cancel) {
//           // Upload was cancelled by user
//           return response ?? _createCancelledResponse();
//         }

//         retryCount++;
//         if (retryCount > maxRetries) {
//           rethrow;
//         }
//         // Wait a bit longer before retrying on exceptions
//         await Future.delayed(Duration(seconds: retryCount * 2));
//       }
//     }

//     // Clean up
//     isUploading.value = false;
//     uploadProgress.value = 0.0;
//     _uploadCancelToken = null;

//     return response;
//   }

//   /// Create a response object for cancelled uploads
//   dynamic _createCancelledResponse() {
//     return ResponseData(
//       isSuccess: false,
//       statusCode: 499,
//       errorMessage: 'Upload cancelled by user',
//     );
//   }

//   /// Cancel ongoing upload
//   void cancelUpload() {
//     if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
//       _uploadCancelToken!.cancel('Upload cancelled by user');
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       EasyLoading.dismiss();
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

//     late final dynamic response;

//     // Use PUT method with form-data and "data" field
//     response = await _networkCaller.multipart(
//       url: Urls.updateVideoTip(editVideoId.value),
//       type: MultipartRequestType.POST,
//       fieldsData: body,
//       file: selectedVideoFile.value,
//       fileName: "video",
//       fieldName: "data",
//     );

//     if (response.isSuccess) {
//       EasyLoading.showSuccess('Video updated successfully');
//       _clearForm();

//       // Refresh the main video list to show updated data
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
//   }

//   /// Cancel ongoing compression
//   void cancelCompression() {
//     VideoCompressionHelper.cancelCompression();
//     isCompressing.value = false;
//     compressionProgress.value = 0.0;
//     EasyLoading.dismiss();
//   }

//   @override
//   void onInit() {
//     formKey = GlobalKey<FormState>();
//     // Initialize Dio network caller
//     _dioNetworkCaller.initialize();
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     // Cancel any ongoing uploads
//     if (_uploadCancelToken != null && !_uploadCancelToken!.isCancelled) {
//       _uploadCancelToken!.cancel('Controller is being disposed');
//     }

//     // Cancel any ongoing compression
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
