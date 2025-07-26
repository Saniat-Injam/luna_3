import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/tips/controllers/article_controller.dart';
import 'package:barbell/features/tips/models/article_model.dart';

/// Optimized article card widget with proper memory management
/// Uses AutomaticKeepAliveClientMixin to maintain state during scroll
class ArticleCard extends StatefulWidget {
  const ArticleCard({super.key, required this.articleModel, this.onSave});

  final ArticleModel articleModel;
  final VoidCallback? onSave;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard>
    with AutomaticKeepAliveClientMixin {
  bool _isDescriptionExpanded = false;
  bool _imageHasError = false;

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
          _buildImage(),
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

  Widget _buildImage() {
    AppLoggerHelper.debug('🖼️ Loading image: ${widget.articleModel.image}');
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Container(
        height: 200,
        width: double.infinity,
        color: AppColors.cardBackground,
        child:
            widget.articleModel.image != null && !_imageHasError
                ? Image.network(
                  widget.articleModel.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.cardBackground,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                          strokeWidth: 2,
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    AppLoggerHelper.error('🖼️ Image loading error', error);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _imageHasError = true;
                        });
                      }
                    });
                    return _buildPlaceholderImage();
                  },
                )
                : _buildPlaceholderImage(),
      ),
    );
  }

  /// Professional placeholder image with better design
  Widget _buildPlaceholderImage() {
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
              Icons.article_outlined,
              size: 40,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Article Image',
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

  /// Header with category and admin options
  Widget _buildHeader() {
    return Row(
      children: [_buildCategory(), const Spacer(), _buildAdminOptions()],
    );
  }

  /// Category badge
  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        widget.articleModel.primaryCategory,
        style: AppTextStyle.f14W500().copyWith(color: AppColors.secondary),
      ),
    );
  }

  /// Admin options (edit/delete) - shown only for admin users
  Widget _buildAdminOptions() {
    return GetBuilder<ArticleController>(
      builder: (controller) {
        if (!(StorageService.role == 'admin')) return const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => controller.editArticle(widget.articleModel.id),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textSub,
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
  void _showDeleteConfirmation(ArticleController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Delete Article', style: AppTextStyle.f18W600()),
        content: Text(
          'Are you sure you want to delete "${widget.articleModel.title}"?',
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
              controller.deleteArticle(widget.articleModel.id);
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

  /// Article title
  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        widget.articleModel.title,
        style: getTextStyleInter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textTitle, // Use textTitle instead of textPrimary
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Expandable description with "Show more" functionality
  Widget _buildExpandableDescription() {
    final isLongDescription = widget.articleModel.description.length > 100;
    final displayText =
        _isDescriptionExpanded
            ? widget.articleModel.description
            : widget.articleModel.shortDescription;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: AppTextStyle.f14W400().copyWith(color: AppColors.textSub),
        ),
        if (isLongDescription) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Text(
              _isDescriptionExpanded ? 'Show less' : 'Show more',
              style: AppTextStyle.f14W500().copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Tags display
  Widget _buildTags() {
    if (widget.articleModel.tag.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children:
          widget.articleModel.tag.take(3).map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2F37),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#$tag',
                style: AppTextStyle.f14W400().copyWith(
                  color: const Color(0xFFE8E7EA),
                ),
              ),
            );
          }).toList(),
    );
  }

  /// Footer with interactions and date
  Widget _buildFooter() {
    return Row(
      children: [
        _buildLikeButton(),
        const SizedBox(width: 16),
        _buildSaveButton(),
        const Spacer(),
        Text(
          widget.articleModel.formattedDate,
          style: AppTextStyle.f14W400().copyWith(color: AppColors.textSub),
        ),
      ],
    );
  }

  /// Like button with count
  Widget _buildLikeButton() {
    return GetBuilder<ArticleController>(
      builder: (controller) {
        return InkWell(
          onTap: () => controller.toggleFavorite(widget.articleModel.id),
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
                  widget.articleModel.liked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color:
                      widget.articleModel.liked
                          ? Colors.red
                          : AppColors.textSub,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.articleModel.favCount}',
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
    return GetBuilder<ArticleController>(
      builder: (controller) {
        return InkWell(
          onTap: () => controller.toggleSaved(widget.articleModel.id),
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
                  widget.articleModel.saved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  size: 18,
                  color:
                      widget.articleModel.saved
                          ? AppColors.secondary
                          : AppColors.textSub,
                ),
                const SizedBox(width: 4),
                Text(
                  'Save',
                  style: AppTextStyle.f14W500().copyWith(
                    color:
                        widget.articleModel.saved
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
