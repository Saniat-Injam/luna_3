import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Shimmer loading widget for article cards
/// Shows loading placeholder while articles are being fetched
class ArticleShimmerWidget extends StatelessWidget {
  /// Number of shimmer cards to show
  final int itemCount;

  const ArticleShimmerWidget({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ArticleShimmerCard();
      },
    );
  }
}

/// Individual shimmer card widget
/// Mimics the layout of actual article card with dark theme
class ArticleShimmerCard extends StatelessWidget {
  const ArticleShimmerCard({super.key});

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
          // Image shimmer
          _buildImageShimmer(),

          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderShimmer(),
                const SizedBox(height: 10),
                _buildTitleShimmer(),
                const SizedBox(height: 8),
                _buildDescriptionShimmer(),
                const SizedBox(height: 12),
                _buildTagsShimmer(),
                const SizedBox(height: 16),
                _buildFooterShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageShimmer() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Shimmer.fromColors(
        baseColor: AppColors.background.withValues(alpha: 0.3),
        highlightColor: AppColors.textSub.withValues(alpha: 0.1),
        child: Container(
          height: 200,
          width: double.infinity,
          color: AppColors.background,
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Row(
        children: [
          // Category badge shimmer
          Container(
            height: 24,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const Spacer(),
          // Admin options shimmer
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
        ],
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
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 20,
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
          const SizedBox(height: 4),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.background.withValues(alpha: 0.3),
      highlightColor: AppColors.textSub.withValues(alpha: 0.1),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 24,
            width: 90,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
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
          // Date shimmer
          Container(
            height: 14,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
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
