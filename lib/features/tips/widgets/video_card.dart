import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/tips/controllers/video_controller.dart';
import 'package:barbell/features/tips/models/video_model.dart';
import 'package:barbell/features/tips/widgets/professional_video_player_widget.dart';
import 'package:barbell/features/tips/widgets/youtube_video_widget.dart';

/// Optimized video card widget with proper memory management
/// Uses AutomaticKeepAliveClientMixin to maintain state during scroll
class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.videoModel, this.onSave});

  final VideoModel videoModel;
  final VoidCallback? onSave;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with AutomaticKeepAliveClientMixin {
  bool _isDescriptionExpanded = false;

  @override
  bool get wantKeepAlive => true; // Keep state alive during scroll

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideo(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildExpandableDescription(),
                const SizedBox(height: 12),
                _buildTags(),
                const SizedBox(height: 16),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideo() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child:
            widget.videoModel.video != null &&
                    widget.videoModel.video!.isNotEmpty
                ? _buildVideoPlayer()
                : _buildPlaceholderVideo(),
      ),
    );
  }

  /// Build video player with YouTube detection and error handling
  Widget _buildVideoPlayer() {
    // Validate video URL first
    if (widget.videoModel.video == null || widget.videoModel.video!.isEmpty) {
      return _buildPlaceholderVideo();
    }

    try {
      if (widget.videoModel.isYouTubeVideo) {
        // Debug print for testing
        debugPrint('🎥 Detected YouTube video: ${widget.videoModel.video}');
        debugPrint('📺 Video ID: ${widget.videoModel.youTubeVideoId}');

        return YouTubeVideoWidget(videoUrl: widget.videoModel.video!);
      } else {
        // Debug print for testing
        debugPrint('🎬 Regular video: ${widget.videoModel.video}');

        return ProfessionalVideoPlayerWidget(
          key: Key('video_${widget.videoModel.id}'),
          videoUrl: widget.videoModel.video!,
          autoPlay: false,
          showControls: true,
        );
      }
    } catch (e) {
      debugPrint('Error building video player: $e');
      return _buildPlaceholderVideo();
    }
  }

  /// Professional placeholder video with better design
  Widget _buildPlaceholderVideo() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background.withValues(alpha: 0.8),
            AppColors.cardBackground.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_circle_outline,
              size: 40,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Video Content',
            style: AppTextStyle.f14W500().copyWith(
              color: AppColors.textSub.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Content available',
            style: AppTextStyle.f14W400().copyWith(
              color: AppColors.textSub.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Header with admin options for admin users
  Widget _buildHeader() {
    return Row(
      children: [
        _buildCategory(),
        const SizedBox(width: 8),
        _buildVideoTypeIndicator(),
        const Spacer(),
        _buildAdminOptions(),
      ],
    );
  }

  /// Video type indicator (YouTube badge)
  Widget _buildVideoTypeIndicator() {
    if (widget.videoModel.isYouTubeVideo) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, color: Colors.white, size: 12),
            const SizedBox(width: 2),
            Text(
              'YouTube',
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Video category badge
  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        widget.videoModel.tagsString.isNotEmpty
            ? widget.videoModel.tagsString
            : 'Video',
        style: AppTextStyle.f14W500().copyWith(
          color: AppColors.secondary,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Admin options (edit/delete) - shown only for admin users
  Widget _buildAdminOptions() {
    return GetBuilder<VideoController>(
      builder: (controller) {
        if (!(StorageService.role == 'admin')) return const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => controller.editVideo(widget.videoModel.id),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _showDeleteConfirmation(controller),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(VideoController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Delete Video', style: AppTextStyle.f18W600()),
        content: Text(
          'Are you sure you want to delete "${widget.videoModel.title}"?',
          style: AppTextStyle.f14W400().copyWith(color: AppColors.textSub),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyle.f14W500()),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteVideo(widget.videoModel.id);
            },
            child: Text(
              'Delete',
              style: AppTextStyle.f14W500().copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Video title
  Widget _buildTitle() {
    return Text(
      widget.videoModel.title,
      style: AppTextStyle.f18W600().copyWith(color: AppColors.textTitle),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Expandable description with "Read more" functionality
  Widget _buildExpandableDescription() {
    final description = widget.videoModel.description;
    if (description.isEmpty) return const SizedBox.shrink();

    const maxLines = 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: AppTextStyle.f14W400().copyWith(
            color: AppColors.textSub,
            height: 1.4,
          ),
          maxLines: _isDescriptionExpanded ? null : maxLines,
          overflow:
              _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
        ),
        if (description.length > 150) // Show read more for longer descriptions
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _isDescriptionExpanded ? 'Read less' : 'Read more',
                style: AppTextStyle.f14W500().copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Video tags
  Widget _buildTags() {
    final tags = widget.videoModel.tagsString;
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children:
          tags.split(',').map((tag) {
            final trimmedTag = tag.trim();
            if (trimmedTag.isEmpty) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2F37),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#$trimmedTag',
                style: AppTextStyle.f14W400().copyWith(
                  color: AppColors.textSub,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        _buildLikeButton(),
        const SizedBox(width: 16),
        _buildSaveButton(),
        const Spacer(),
        Text(
          widget.videoModel.formattedDate,
          style: AppTextStyle.f14W400().copyWith(color: AppColors.textSub),
        ),
      ],
    );
  }

  /// Like button with count
  Widget _buildLikeButton() {
    return GetBuilder<VideoController>(
      builder: (controller) {
        return InkWell(
          onTap: () => controller.toggleFavorite(widget.videoModel.id),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF2A2F37),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.videoModel.liked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color:
                      widget.videoModel.liked ? Colors.red : AppColors.textSub,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.videoModel.favCount}',
                  style: AppTextStyle.f14W500().copyWith(
                    color: AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Save button
  Widget _buildSaveButton() {
    return GetBuilder<VideoController>(
      builder: (controller) {
        return InkWell(
          onTap: () => controller.toggleSaved(widget.videoModel.id),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF2A2F37),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.videoModel.saved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  size: 18,
                  color:
                      widget.videoModel.saved
                          ? AppColors.secondary
                          : AppColors.textSub,
                ),
                const SizedBox(width: 4),
                Text(
                  'Save',
                  style: AppTextStyle.f14W500().copyWith(
                    color:
                        widget.videoModel.saved
                            ? AppColors.secondary
                            : AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
