import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import '../widgets/professional_video_player_widget.dart';

/// Example usage of the Professional Video Player Widget
/// This demonstrates how to integrate the widget in your app
class VideoPlayerExampleScreen extends StatelessWidget {
  const VideoPlayerExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Professional Video Player',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appbar,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Video player with auto-play enabled
            const ProfessionalVideoPlayerWidget(
              videoUrl:
                  'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
              autoPlay: true,
              showControls: true,
              aspectRatio: 16 / 9,
            ),

            const SizedBox(height: 24),

            /// Video description section
            Text(
              'Video Features:',
              style: getTextStyleInter(
                color: AppColors.textTitle,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            /// Feature list
            _buildFeatureItem(
              icon: Icons.touch_app,
              title: 'Touch Controls',
              description: 'Tap to show/hide controls, double-tap to seek',
            ),

            _buildFeatureItem(
              icon: Icons.volume_up,
              title: 'Volume Control',
              description: 'Vertical swipe on right side to adjust volume',
            ),

            _buildFeatureItem(
              icon: Icons.fast_forward,
              title: 'Seek Controls',
              description: 'Double-tap left/right to seek backward/forward',
            ),

            _buildFeatureItem(
              icon: Icons.play_circle,
              title: 'Auto-hide Controls',
              description: 'Controls automatically hide during playback',
            ),
          ],
        ),
      ),
    );
  }

  /// Build feature item widget
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyleInter(
                    color: AppColors.textTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: getTextStyleInter(
                    color: AppColors.textSub,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
