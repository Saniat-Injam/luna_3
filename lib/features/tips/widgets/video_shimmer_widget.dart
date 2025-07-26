import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Shimmer loading widget for video cards
/// Shows loading placeholder while videos are being fetched
class VideoShimmerWidget extends StatelessWidget {
  /// Number of shimmer cards to show
  final int itemCount;

  const VideoShimmerWidget({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const VideoShimmerCard();
      },
    );
  }
}

/// Individual shimmer card widget for videos
/// Mimics the layout of actual video card with dark theme
class VideoShimmerCard extends StatelessWidget {
  const VideoShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
          // Video thumbnail shimmer with play button
          _buildVideoThumbnailShimmer(),

          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryShimmer(),
                const SizedBox(height: 8),
                _buildTitleShimmer(),
                const SizedBox(height: 12),
                _buildDescriptionShimmer(),
                const SizedBox(height: 16),
                _buildFooterShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnailShimmer() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Shimmer.fromColors(
          baseColor: AppColors.background.withValues(alpha: 0.3),
          highlightColor: AppColors.textSub.withValues(alpha: 0.1),
          child: Container(
            color: AppColors.background,
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: 30,
                  color: AppColors.textSub.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Container(
        height: 20,
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTitleShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 22,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 22,
            width: 250,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 16,
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Likes count shimmer
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 16,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),

          // Action buttons shimmer
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
