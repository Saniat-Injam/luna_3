import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import '../controller/professional_video_player_controller.dart';
import 'volume_indicator_widget.dart';

/// Professional YouTube-like video player widget with UI only
/// All business logic is handled by ProfessionalVideoPlayerController
class ProfessionalVideoPlayerWidget extends StatefulWidget {
  const ProfessionalVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
    this.aspectRatio = 16 / 9,
  });

  final String videoUrl;
  final bool autoPlay;
  final bool showControls;
  final double aspectRatio;

  @override
  State<ProfessionalVideoPlayerWidget> createState() =>
      _ProfessionalVideoPlayerWidgetState();
}

class _ProfessionalVideoPlayerWidgetState
    extends State<ProfessionalVideoPlayerWidget> {
  late ProfessionalVideoPlayerController controller;
  late String controllerId;

  @override
  void initState() {
    super.initState();
    // Create unique controller ID to prevent conflicts
    controllerId =
        'video_${widget.videoUrl.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
    controller = Get.put(
      ProfessionalVideoPlayerController(),
      tag: controllerId,
    );

    // Initialize with error handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.initializeVideoPlayer(
          videoUrl: widget.videoUrl,
          autoPlay: widget.autoPlay,
          showControls: widget.showControls,
          aspectRatio: widget.aspectRatio,
        );
      }
    });
  }

  @override
  void dispose() {
    // Properly dispose controller with tag
    if (Get.isRegistered<ProfessionalVideoPlayerController>(
      tag: controllerId,
    )) {
      Get.delete<ProfessionalVideoPlayerController>(tag: controllerId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / widget.aspectRatio,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Obx(() {
          if (controller.hasError) {
            return _buildErrorWidget();
          } else if (!controller.isInitialized) {
            return _buildLoadingWidget();
          } else {
            return _buildVideoPlayer();
          }
        }),
      ),
    );
  }

  /// Enhanced error state widget
  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.background.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 28,
                color: Colors.red.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Video failed to load',
              style: getTextStyleInter(
                color: AppColors.textTitle,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                controller.retryVideoInitialization();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enhanced loading state widget
  Widget _buildLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.background.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: AppColors.secondary,
                strokeWidth: 2,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading video...',
              style: getTextStyleInter(
                color: AppColors.textSub,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please wait',
              style: getTextStyleInter(
                color: AppColors.textSub.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enhanced main video player with YouTube-like interactions
  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        controller.handleVideoTap();
      },
      onDoubleTapDown: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final screenWidth = renderBox.size.width;
        final tapPosition = localPosition.dx;

        controller.handleDoubleTap(tapPosition, screenWidth);
      },
      onVerticalDragUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final screenWidth = renderBox.size.width;
        final tapPosition = localPosition.dx;

        controller.handleVerticalDrag(
          tapPosition,
          screenWidth,
          details.delta.dy,
        );
      },
      child: Obx(
        () => Stack(
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: controller.videoController.value.aspectRatio,
                child: VideoPlayer(controller.videoController),
              ),
            ),

            // Buffering indicator
            if (controller.isBuffering) _buildBufferingIndicator(),

            // Center play button when paused
            if (!controller.isPlaying && !controller.isBuffering)
              _buildCenterPlayButton(),

            // Seek feedback indicator
            if (controller.showSeekIndicator) _buildSeekIndicator(),

            // Controls overlay
            if (controller.showControls && widget.showControls)
              AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: _buildControlsOverlay(),
                  );
                },
              ),

            // Volume indicator
            VolumeIndicatorWidget(controller: controller),
          ],
        ),
      ),
    );
  }

  /// Build buffering indicator
  Widget _buildBufferingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: AppColors.secondary,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buffering...',
            style: getTextStyleInter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced center play button with better animations
  Widget _buildCenterPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: controller.togglePlayPause,
        child: Obx(
          () => AnimatedScale(
            scale: controller.isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Icon(Icons.play_arrow, size: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Build seek feedback indicator
  Widget _buildSeekIndicator() {
    return Center(
      child: AnimatedBuilder(
        animation: controller.seekAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: controller.seekAnimation.value,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.seekDirection == 'forward'
                          ? Icons.fast_forward
                          : Icons.fast_rewind,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.seekAmount} seconds',
                      style: getTextStyleInter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Enhanced controls overlay with YouTube-like design
  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Column(children: [const Spacer(), _buildBottomControls()]),
    );
  }

  /// Enhanced bottom controls with YouTube-like styling
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Progress bar
          _buildProgressBar(),
          const SizedBox(height: 2),
          // Control buttons
          Obx(
            () => Row(
              children: [
                // Play/Pause button
                _buildControlButton(
                  icon: controller.isPlaying ? Icons.pause : Icons.play_arrow,
                  onTap: controller.togglePlayPause,
                  size: 20,
                ),
                const SizedBox(width: 16),
                // Backward 10s button
                _buildControlButton(
                  icon: Icons.replay_10,
                  onTap: () => controller.seekWithFeedback(-10),
                  size: 20,
                ),
                const SizedBox(width: 8),
                // Forward 10s button
                _buildControlButton(
                  icon: Icons.forward_10,
                  onTap: () => controller.seekWithFeedback(10),
                  size: 20,
                ),
                const Spacer(),
                // Volume down button
                // _buildControlButton(
                //   icon: Icons.volume_down,
                //   onTap: () {
                //     controller.adjustVolumeWithIndicator(-0.1);
                //   },
                //   size: 18,
                // ),
                // const SizedBox(width: 8),
                // // Volume button (mute/unmute)
                // _buildControlButton(
                //   icon: controller.volumeIcon,
                //   onTap: () {
                //     controller.toggleMute();
                //     controller.showVolumeSliderTemporarily();
                //   },
                //   size: 20,
                // ),
                const SizedBox(width: 8),
                // Volume up button
                _buildControlButton(
                  icon: Icons.volume_up,
                  onTap: () {
                    controller.adjustVolumeWithIndicator(0.1);
                  },
                  size: 18,
                ),
                const SizedBox(width: 8),
                // Time display
                _buildTimeDisplay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build control button with consistent styling
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  /// Build time display with YouTube-like styling
  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Obx(
        () => Text(
          '${controller.formatDuration(controller.currentPosition)} / ${controller.formatDuration(controller.totalDuration)}',
          style: getTextStyleInter(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Enhanced progress bar with YouTube-like behavior
  Widget _buildProgressBar() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.secondary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
        thumbColor: AppColors.secondary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        trackHeight: 4,
        overlayColor: AppColors.secondary.withValues(alpha: 0.3),
      ),
      child: Obx(
        () => Slider(
          value:
              controller.totalDuration.inMilliseconds > 0
                  ? controller.currentPosition.inMilliseconds /
                      controller.totalDuration.inMilliseconds
                  : 0.0,
          onChangeStart: (value) {
            controller.handleProgressSeek(value);
          },
          onChanged: (value) {
            controller.handleProgressSeek(value);
          },
          onChangeEnd: (value) {
            controller.handleProgressSeekEnd(value);
          },
        ),
      ),
    );
  }
}
