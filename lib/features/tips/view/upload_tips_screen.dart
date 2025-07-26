import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/tips/controllers/upload_article_tip_controller.dart';
import 'package:barbell/features/tips/controllers/upload_video_tip_controller_enhanced.dart';
import 'package:barbell/features/tips/models/article_model.dart';
import 'package:barbell/features/tips/models/video_model.dart';
import 'package:barbell/features/tips/widgets/custom_text_field.dart';

class UploadTipsScreen extends StatelessWidget {
  final String appBarTitle;
  final bool isVideo;
  final bool isEdit;
  final ArticleModel? articleData;
  final VideoModel? videoData;

  const UploadTipsScreen({
    super.key,
    required this.appBarTitle,
    this.isVideo = false,
    this.isEdit = false,
    this.articleData,
    this.videoData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: appBarTitle, showNotification: true),
      body: _UploadTipsBody(
        appBarTitle: appBarTitle,
        isVideo: isVideo,
        isEdit: isEdit,
        articleData: articleData,
        videoData: videoData,
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class _UploadTipsBody extends StatefulWidget {
  final String appBarTitle;
  final bool isVideo;
  final bool isEdit;
  final ArticleModel? articleData;
  final VideoModel? videoData;

  const _UploadTipsBody({
    required this.appBarTitle,
    this.isVideo = false,
    this.isEdit = false,
    this.articleData,
    this.videoData,
  });

  @override
  State<_UploadTipsBody> createState() => _UploadTipsBodyState();
}

class _UploadTipsBodyState extends State<_UploadTipsBody> {
  late final dynamic controller;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize appropriate controller based on mode
    if (widget.isVideo) {
      controller = Get.put(UploadVideoTipControllerEnhanced());

      // Pre-fill data if editing a video
      if (widget.isEdit && widget.videoData != null) {
        _prefillVideoData();
      }
    } else {
      controller = Get.put(UploadArticleTipController());

      // Pre-fill data if editing an article
      if (widget.isEdit && widget.articleData != null) {
        _prefillArticleData();
      }
    }
  }

  /// Pre-fill form with existing article data for editing
  void _prefillArticleData() {
    final articleController = controller as UploadArticleTipController;
    final article = widget.articleData!;

    // Debug logging
    AppLoggerHelper.debug('📋 PREFILL ARTICLE DATA DEBUG:');
    AppLoggerHelper.debug('📝 Original Article ID: ${article.id}');
    AppLoggerHelper.debug('📝 Original Title: "${article.title}"');
    AppLoggerHelper.debug('📝 Original Description: "${article.description}"');
    AppLoggerHelper.debug('📝 Original Image: "${article.image}"');
    AppLoggerHelper.debug('📝 Original Tags: ${article.tag}');

    // Set form fields
    articleController.titleController.text = article.title;
    articleController.descriptionController.text = article.description;
    if (article.image != null) {
      articleController.imageUrlController.text = article.image!;
    }

    // Set tags
    articleController.tags.clear();
    articleController.tags.addAll(article.tag);

    // Set edit mode and article ID for update API call
    articleController.setEditMode(article.id);

    // Debug verification
    AppLoggerHelper.debug('✅ AFTER PREFILL:');
    AppLoggerHelper.debug(
      '📝 Title Controller: "${articleController.titleController.text}"',
    );
    AppLoggerHelper.debug(
      '📝 Description Controller: "${articleController.descriptionController.text}"',
    );
    AppLoggerHelper.debug(
      '📝 Image URL Controller: "${articleController.imageUrlController.text}"',
    );
    AppLoggerHelper.debug('📝 Tags: ${articleController.tags.toList()}');
    AppLoggerHelper.debug(
      '📝 Edit Mode: ${articleController.isEditMode.value}',
    );
    AppLoggerHelper.debug(
      '📝 Edit Article ID: ${articleController.editArticleId.value}',
    );
  }

  /// Pre-fill form with existing video data for editing
  void _prefillVideoData() {
    final videoController = controller as UploadVideoTipControllerEnhanced;
    final video = widget.videoData!;

    // Debug logging
    AppLoggerHelper.debug('📋 PREFILL VIDEO DATA DEBUG:');
    AppLoggerHelper.debug('🎥 Original Video ID: ${video.id}');
    AppLoggerHelper.debug('🎥 Original Title: "${video.title}"');
    AppLoggerHelper.debug('🎥 Original Description: "${video.description}"');
    AppLoggerHelper.debug('🎥 Original Video URL: "${video.video}"');
    AppLoggerHelper.debug('🎥 Original Tags: ${video.tag}');

    // Set form fields
    videoController.titleController.text = video.title;
    videoController.descriptionController.text = video.description;
    if (video.video != null && video.video!.isNotEmpty) {
      videoController.videoUrlController.text = video.video!;
    }

    // Set tags
    videoController.tags.clear();
    videoController.tags.addAll(video.tag);

    // Set edit mode and video ID for update API call
    videoController.setEditMode(video.id);

    // Debug verification
    AppLoggerHelper.debug('✅ AFTER PREFILL VIDEO:');
    AppLoggerHelper.debug(
      '🎥 Title Controller: "${videoController.titleController.text}"',
    );
    AppLoggerHelper.debug(
      '🎥 Description Controller: "${videoController.descriptionController.text}"',
    );
    AppLoggerHelper.debug(
      '🎥 Video URL Controller: "${videoController.videoUrlController.text}"',
    );
    AppLoggerHelper.debug('🎥 Tags: ${videoController.tags.toList()}');
    AppLoggerHelper.debug('🎥 Edit Mode: ${videoController.isEditMode.value}');
    AppLoggerHelper.debug(
      '🎥 Edit Video ID: ${videoController.editVideoId.value}',
    );
  }

  Future<void> _pickFile() async {
    final XFile? file =
        await (widget.isVideo
            ? _imagePicker.pickVideo(source: ImageSource.gallery)
            : _imagePicker.pickImage(source: ImageSource.gallery));

    if (file != null) {
      if (widget.isVideo) {
        final videoController = controller as UploadVideoTipControllerEnhanced;
        videoController.setVideoFile(file);
        // Clear URL when file is selected
        videoController.videoUrlController.clear();
      } else {
        final articleController = controller as UploadArticleTipController;
        articleController.setImageFile(file);
        // Clear URL when file is selected
        articleController.imageUrlController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title field
              Text('Title', style: AppTextStyle.f18W400()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.titleController,
                hintText:
                    'Enter the title of the ${widget.isVideo ? 'video tip' : 'article'}',
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),

              // Description field
              Text('Description', style: AppTextStyle.f18W400()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.descriptionController,
                hintText: 'Provide a detailed description or content',
                maxLines: 5,
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Description is required'
                            : null,
              ),
              const SizedBox(height: 20),

              // Media upload field
              _buildMediaUploadField(),
              const SizedBox(height: 20),

              // URL field
              widget.isVideo
                  ? Text('Video URL (Optional)', style: AppTextStyle.f18W400())
                  : Text('Image URL (Optional)', style: AppTextStyle.f18W400()),
              const SizedBox(height: 8),
              CustomTextField(
                controller:
                    widget.isVideo
                        ? (controller as UploadVideoTipControllerEnhanced)
                            .videoUrlController
                        : (controller as UploadArticleTipController)
                            .imageUrlController,
                hintText:
                    widget.isVideo
                        ? 'Enter video link (like : https://www.example.com/watch?v=...)'
                        : 'Enter image link (like : https://www.example.com/image.jpg)',
                willValidate: false,
                onChange: (value) {
                  // Clear file if URL is entered and not empty
                  if (value.isNotEmpty) {
                    if (widget.isVideo) {
                      (controller as UploadVideoTipControllerEnhanced)
                          .setVideoFile(null);
                    } else {
                      (controller as UploadArticleTipController).setImageFile(
                        null,
                      );
                    }
                  }
                },
                suffixIcon: Transform.scale(
                  scale: 0.5,
                  child: SvgPicture.asset(
                    SvgPath.closeTag,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFEAFF55),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tags field
              Text('Tags', style: AppTextStyle.f18W400()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.tagsController,
                hintText: 'Enter tags separated by commas',
                onFieldSubmitted: (value) => controller.addTag(value),
                onChange: (value) {
                  if (value.endsWith(',')) {
                    controller.addTag(value.substring(0, value.length - 1));
                  }
                },
                validator:
                    (value) =>
                        controller.tags.isEmpty
                            ? 'At least one tag is required'
                            : null,
              ),

              // Tags display
              Obx(
                () => Wrap(
                  spacing: 8,
                  children:
                      controller.tags
                          .map<Widget>(
                            (tag) => Chip(
                              backgroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(
                                color: const Color(0xFF203F2C),
                                width: 1,
                              ),
                              label: Text(tag),
                              labelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                              onDeleted: () => controller.removeTag(tag),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(height: 30),

              // Submit button
              _buildSubmitButton(),

              // Upload Progress Section (Video only)
              if (widget.isVideo) ...[
                Obx(() {
                  final videoController =
                      controller as UploadVideoTipControllerEnhanced;

                  final isUploading = videoController.isUploading.value;
                  final isCompressing = videoController.isCompressing.value;

                  if (isUploading || isCompressing) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.withValues(alpha: 0.1),
                            Colors.purple.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      isCompressing
                                          ? Colors.orange.withValues(alpha: 0.2)
                                          : Colors.blue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isCompressing
                                      ? Icons.compress
                                      : Icons.cloud_upload,
                                  color:
                                      isCompressing
                                          ? Colors.orange
                                          : Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isCompressing
                                          ? 'Compressing Video'
                                          : widget.isEdit
                                          ? 'Updating Video Tip'
                                          : 'Uploading Video Tip',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      isCompressing
                                          ? 'Progress: ${videoController.compressionProgress.value.toStringAsFixed(1)}%'
                                          : 'Progress: ${videoController.uploadProgress.value}%',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Large Percentage Display (like test screen)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: (isCompressing
                                        ? Colors.orange
                                        : Colors.blue)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (isCompressing
                                          ? Colors.orange
                                          : Colors.blue)
                                      .withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isCompressing
                                    ? '${videoController.compressionProgress.value.toStringAsFixed(1)}%'
                                    : '${videoController.uploadProgress.value}%',
                                style: TextStyle(
                                  color:
                                      isCompressing
                                          ? Colors.orange
                                          : Colors.blue,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  isCompressing
                                      ? videoController
                                              .compressionProgress
                                              .value /
                                          100
                                      : videoController
                                          .uploadProgressDouble
                                          .value,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isCompressing ? Colors.orange : Colors.blue,
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Progress Text and Cancel Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCompressing
                                        ? '${videoController.compressionProgress.value.toStringAsFixed(1)}% compressed'
                                        : '${videoController.uploadProgress.value}% uploaded',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    isCompressing
                                        ? '${videoController.compressionProgress.value.toStringAsFixed(1)}% completed'
                                        : '${videoController.uploadProgress.value}% completed',
                                    style: TextStyle(
                                      color: (isCompressing
                                              ? Colors.orange
                                              : Colors.blue)
                                          .withValues(alpha: 0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  if (isCompressing) {
                                    videoController.cancelCompression();
                                  } else {
                                    videoController.cancelUpload();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),

                          // Compression Status
                          if (videoController
                              .compressionStatus
                              .value
                              .isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                videoController.compressionStatus.value,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isVideo ? 'Upload Video' : 'Upload Image',
          style: AppTextStyle.f18W400(),
        ),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: _pickFile,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121400),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF13251A)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getFileDisplayText(),
                      style: TextStyle(
                        color: _hasSelectedFile() ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    SvgPath.uploadIcon,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFEAFF55),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getFileDisplayText() {
    if (widget.isVideo) {
      final videoController = controller as UploadVideoTipControllerEnhanced;
      if (videoController.selectedVideoFile.value != null) {
        final fileName = videoController.selectedVideoFile.value!.name;
        // You could add file size here if needed
        return 'Video file selected: $fileName';
      } else {
        return 'Choose a video to upload (Max: 50MB)';
      }
    } else {
      final articleController = controller as UploadArticleTipController;
      if (articleController.selectedImageFile.value != null) {
        final fileName = articleController.selectedImageFile.value!.name;
        return 'Image file selected: $fileName';
      } else {
        return 'Choose an image to upload';
      }
    }
  }

  bool _hasSelectedFile() {
    if (widget.isVideo) {
      return (controller as UploadVideoTipControllerEnhanced)
              .selectedVideoFile
              .value !=
          null;
    } else {
      return (controller as UploadArticleTipController)
              .selectedImageFile
              .value !=
          null;
    }
  }

  Widget _buildSubmitButton() {
    if (widget.isVideo) {
      final videoController = controller as UploadVideoTipControllerEnhanced;
      return Obx(() {
        final isLoading =
            videoController.isUploading.value ||
            videoController.isCompressing.value;
        final isCompressing = videoController.isCompressing.value;

        return _buildButton(
          isLoading: isLoading,
          isVideo: true,
          isCompressing: isCompressing,
        );
      });
    } else {
      // For non-video case, just return the button without Obx since there's no reactive state
      return _buildButton(
        isLoading: false,
        isVideo: false,
        isCompressing: false,
      );
    }
  }

  Widget _buildButton({
    required bool isLoading,
    required bool isVideo,
    required bool isCompressing,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () {
                  if (isVideo) {
                    (controller as UploadVideoTipControllerEnhanced)
                        .submitVideoTip();
                  } else {
                    (controller as UploadArticleTipController)
                        .submitArticleTip();
                  }
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              isLoading
                  ? (isVideo && isCompressing
                      ? 'Compressing...'
                      : widget.isEdit
                      ? 'Updating...'
                      : 'Uploading...')
                  : (widget.isEdit ? "Update Tip" : "Submit Tip"),
              style: getTextStyleInter(
                color:
                    isLoading
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
