import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/tips/controllers/video_controller.dart';
import 'package:barbell/features/tips/models/video_model.dart';
import 'package:barbell/features/tips/widgets/video_card.dart';
import 'package:barbell/features/tips/widgets/video_shimmer_widget.dart';

class FitnessTipsVideoScreen extends StatefulWidget {
  const FitnessTipsVideoScreen({super.key, this.isSaved});
  final bool? isSaved;

  @override
  State<FitnessTipsVideoScreen> createState() => _FitnessTipsVideoScreenState();
}

class _FitnessTipsVideoScreenState extends State<FitnessTipsVideoScreen> {
  late VideoController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<VideoController>();

    // Initialize the controller with proper mode only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        _isInitialized = true;
        if (widget.isSaved == true) {
          _controller.loadSavedVideosFromAPI(isRefresh: true);
        } else {
          // Only load regular videos if not in saved mode and no videos loaded
          if (_controller.videos.isEmpty) {
            _controller.loadVideosFromAPI(isRefresh: true);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    // Properly dispose of controller to prevent memory leaks
    if (Get.isRegistered<VideoController>()) {
      final controller = Get.find<VideoController>();
      // Clear error states when screen is disposed
      controller.errorMessage.value = '';
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBarWidget(
            title: widget.isSaved == true ? "Saved Videos" : "Fitness Videos",
            showNotification: true,
          ),
          body: _FitnessTipsVideoBody(isSaved: widget.isSaved),
        );
      },
    );
  }
}

class _FitnessTipsVideoBody extends StatelessWidget {
  const _FitnessTipsVideoBody({this.isSaved});
  final bool? isSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          if (isSaved != true) _buildSearchField(),
          if (isSaved != true) const SizedBox(height: 16),
          _buildVideosList(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return GetBuilder<VideoController>(
      builder:
          (controller) => TextField(
            controller: controller.searchController,
            style: getTextStyleInter(color: AppColors.textSub),
            decoration: InputDecoration(
              hintText:
                  isSaved == true ? 'Search saved videos' : 'Search for videos',
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (isSaved == true) {
                controller.searchSavedVideos(value);
              } else {
                controller.searchVideos(value);
              }
            },
          ),
    );
  }

  Widget _buildVideosList() {
    return Expanded(
      child: GetBuilder<VideoController>(
        builder: (controller) {
          // Determine which data to use based on saved mode
          final bool isInSavedMode = isSaved == true;
          final List<VideoModel> currentVideos =
              isInSavedMode ? controller.savedVideos : controller.videos;

          // Show shimmer loading when loading and no data exists
          if (controller.isLoading.value && currentVideos.isEmpty) {
            return const VideoShimmerWidget(itemCount: 5);
          }

          // Show empty state when no videos found
          if (!controller.isLoading.value &&
              currentVideos.isEmpty &&
              controller.errorMessage.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isInSavedMode
                        ? Icons.bookmark_border
                        : Icons.play_circle_outline,
                    size: 64,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isInSavedMode ? 'No saved videos' : 'No videos Tip found',
                    style: getTextStyleInter(
                      color: AppColors.textSub,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isInSavedMode
                        ? 'Videos you save will appear here for easy access'
                        : 'Try adjusting your search or check back later',
                    style: getTextStyleInter(
                      color: AppColors.textSub.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Show error state
          if (controller.errorMessage.value.isNotEmpty &&
              currentVideos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading videos',
                    style: getTextStyleInter(
                      color: AppColors.textSub,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: getTextStyleInter(
                      color: AppColors.textSub.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (isInSavedMode) {
                        controller.loadSavedVideosFromAPI(isRefresh: true);
                      } else {
                        controller.refreshVideos();
                      }
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          // Show videos list with pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              if (isInSavedMode) {
                await controller.loadSavedVideosFromAPI(isRefresh: true);
              } else {
                await controller.refreshVideos();
              }
            },
            backgroundColor: AppColors.cardBackground,
            color: AppColors.secondary,
            child: Obx(() {
              return ListView.builder(
                key: const PageStorageKey('fitness_video_list'),
                controller: controller.scrollController,
                padding: const EdgeInsets.only(top: 22.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    currentVideos.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show shimmer loading at the end when loading more
                  if (index == currentVideos.length &&
                      controller.isLoadingMore.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: VideoShimmerWidget(itemCount: 2),
                    );
                  }

                  final VideoModel video = currentVideos[index];
                  return Padding(
                    key: ValueKey(video.id), // Add key for better performance
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: VideoCard(videoModel: video),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
