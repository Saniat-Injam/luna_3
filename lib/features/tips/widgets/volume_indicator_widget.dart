import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import '../controller/professional_video_player_controller.dart';

/// Volume indicator widget for video player
/// Displays current volume level with animated indicator
class VolumeIndicatorWidget extends StatelessWidget {
  const VolumeIndicatorWidget({super.key, required this.controller});

  final ProfessionalVideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      top: 0,
      bottom: 0,
      child: Center(
        child: Obx(
          () => AnimatedOpacity(
            opacity: controller.showVolumeIndicator ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Volume icon that changes based on current volume level
                  Icon(controller.volumeIcon, color: Colors.white, size: 28),
                  const SizedBox(height: 16),

                  /// Volume level indicator bar
                  Container(
                    height: 100,
                    width: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height:
                            100 *
                            (controller.isMuted ? 0 : controller.currentVolume),
                        width: 6,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Volume percentage display
                  Text(
                    '${controller.volumePercentage}%',
                    style: getTextStyleInter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
