import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/tips/models/video_model.dart';
import 'package:barbell/features/tips/view/upload_tips_screen.dart';

/// Controller for managing video tips
/// Handles API integration with pagination, search, and infinite scroll
class VideoController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Network service
  final NetworkCaller _networkCaller = NetworkCaller();

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasReachedEnd = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalVideos = 0.obs;
  final int pageLimit = 5;

  // Search
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  // Mode tracking
  final RxBool isSavedMode = false.obs;

  // Videos data
  List<VideoModel> _allVideos = [];
  List<VideoModel> _filteredVideos = [];
  List<VideoModel> _savedVideos = [];

  List<VideoModel> get videos => _filteredVideos;
  List<VideoModel> get savedVideos => _savedVideos;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  @override
  void onClose() {
    // Properly dispose of controllers to prevent memory leaks
    searchController.dispose();
    scrollController.dispose();

    // Clear data to free memory
    _allVideos.clear();
    _filteredVideos.clear();
    _savedVideos.clear();

    super.onClose();
  }

  /// Setup infinite scroll listener with debouncing for better performance
  void _setupScrollListener() {
    scrollController.addListener(() {
      // Add threshold for better performance
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && !hasReachedEnd.value) {
          // Load more based on current mode
          if (isSavedMode.value) {
            loadMoreSavedVideos();
          } else {
            loadMoreVideos();
          }
        }
      }
    });
  }

  //!------------------------------- Fetch videos from API with pagination -------------------------
  Future<void> loadVideosFromAPI({bool isRefresh = false}) async {
    isSavedMode.value = false;

    if (isRefresh) {
      currentPage.value = 1;
      hasReachedEnd.value = false;
      _allVideos.clear();
      _filteredVideos.clear();
    }

    isLoading.value = true;
    errorMessage.value = '';

    final String url = _buildApiUrl();

    final response = await _networkCaller.getRequest(url: url);

    if (response.isSuccess) {
      final Map<String, dynamic> responseData = response.responseData;
      final List<dynamic> videosJson = responseData['data'] ?? [];
      final Map<String, dynamic> pagination = responseData['pagination'] ?? {};

      // Parse pagination
      totalPages.value = pagination['pages'] ?? 1;
      totalVideos.value = pagination['total'] ?? 0;

      // Parse videos
      final List<VideoModel> newVideos =
          videosJson.map((json) => VideoModel.fromJson(json)).toList();

      if (isRefresh) {
        _allVideos = newVideos;
      } else {
        _allVideos.addAll(newVideos);
      }

      _filteredVideos = _allVideos;
      _savedVideos = _allVideos.where((element) => element.saved).toList();

      // Check if reached end
      if (currentPage.value >= totalPages.value) {
        hasReachedEnd.value = true;
      }

      update();
    } else {
      errorMessage.value = 'Failed to load videos from server';
      if (_allVideos.isEmpty) {
        // Only show error if no videos are loaded at all
        EasyLoading.showError('Failed to load videos');
      }
    }

    // Always set loading to false at the end
    isLoading.value = false;
  }

  /// Load more videos for pagination with proper error handling
  Future<void> loadMoreVideos() async {
    if (isLoadingMore.value || hasReachedEnd.value) return;

    print('Loading more videos - setting isLoadingMore to true');
    isLoadingMore.value = true;
    update(); // Trigger UI update to show shimmer
    currentPage.value++;

    try {
      final String url = _buildApiUrl();
      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> videosJson = responseData['data'] ?? [];

        final List<VideoModel> newVideos =
            videosJson.map((json) => VideoModel.fromJson(json)).toList();

        _allVideos.addAll(newVideos);
        _filteredVideos = _allVideos;
        _savedVideos = _allVideos.where((element) => element.saved).toList();

        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      } else {
        // Revert page number on error
        currentPage.value--;
        EasyLoading.showError('Failed to load more videos');
      }
    } catch (e) {
      // Revert page number on error
      currentPage.value--;
      EasyLoading.showError('Network error occurred');
    } finally {
      print('Load more videos finished - setting isLoadingMore to false');
      isLoadingMore.value = false;
      update(); // Trigger UI update when loading more is complete
    }
  }

  /// Build API URL with pagination and search parameters
  String _buildApiUrl() {
    String url =
        '${Urls.getAllVideoTip}?page=${currentPage.value}&limit=$pageLimit';

    if (searchQuery.value.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(searchQuery.value)}';
    }

    return url;
  }

  /// Search videos with API call
  Future<void> searchVideos(String query) async {
    try {
      searchQuery.value = query;
      searchController.text = query;

      if (query.isEmpty) {
        // Reset to normal loading
        isSearching.value = false;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadVideosFromAPI(isRefresh: true);
      } else {
        // Perform search
        isSearching.value = true;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadVideosFromAPI(isRefresh: true);
      }
    } catch (e) {
      EasyLoading.showError('Failed to search videos');
    }
  }

  /// Clear search and reload all videos
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    currentPage.value = 1;
    hasReachedEnd.value = false;
    loadVideosFromAPI(isRefresh: true);
  }
  //!------------------------------------------------------------------------------------

  //!------------------------------- Load Saved Videos with Pagination -------------------------
  /// Load saved videos from API with pagination and search
  Future<void> loadSavedVideosFromAPI({bool isRefresh = false}) async {
    try {
      // Set saved mode flag
      isSavedMode.value = true;

      if (isRefresh) {
        currentPage.value = 1;
        hasReachedEnd.value = false;
        _savedVideos.clear();
      }

      isLoading.value = true;
      errorMessage.value = '';

      final String url = _buildSavedVideosApiUrl();

      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> videosJson = responseData['data'] ?? [];
        final Map<String, dynamic> pagination =
            responseData['pagination'] ?? {};

        // Parse pagination
        totalPages.value = pagination['pages'] ?? 1;
        totalVideos.value = pagination['total'] ?? 0;

        // Parse saved videos and ensure they are marked as saved
        final List<VideoModel> newSavedVideos =
            videosJson
                .map((json) => VideoModel.fromJson(json))
                .map(
                  (video) => video.copyWith(saved: true),
                ) // Ensure saved flag is true
                .toList();

        if (isRefresh) {
          _savedVideos = newSavedVideos;
        } else {
          _savedVideos.addAll(newSavedVideos);
        }

        // Check if reached end
        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      } else {
        if (_savedVideos.isEmpty) {
          EasyLoading.showError('Failed to load saved videos');
        }
      }
    } catch (e) {
      if (_savedVideos.isEmpty) {
        EasyLoading.showError('Please check your internet connection');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more saved videos for pagination
  Future<void> loadMoreSavedVideos() async {
    if (isLoadingMore.value || hasReachedEnd.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final String url = _buildSavedVideosApiUrl();
      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> videosJson = responseData['data'] ?? [];

        final List<VideoModel> newSavedVideos =
            videosJson.map((json) => VideoModel.fromJson(json)).toList();

        _savedVideos.addAll(newSavedVideos);

        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      }
    } catch (e) {
      // Revert page number on error
      currentPage.value--;
      EasyLoading.showError('Failed to load more saved videos');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Build API URL for saved videos with pagination and search
  String _buildSavedVideosApiUrl() {
    String url =
        '${Urls.getMySavedVideos}?page=${currentPage.value}&limit=$pageLimit';

    if (searchQuery.value.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(searchQuery.value)}';
    }

    return url;
  }

  /// Search saved videos with API call
  Future<void> searchSavedVideos(String query) async {
    try {
      searchQuery.value = query;
      searchController.text = query;

      if (query.isEmpty) {
        // Reset to normal loading
        isSearching.value = false;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadSavedVideosFromAPI(isRefresh: true);
      } else {
        // Perform search
        isSearching.value = true;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadSavedVideosFromAPI(isRefresh: true);
      }
    } catch (e) {
      EasyLoading.showError('Failed to search saved videos');
    }
  }

  /// Refresh saved videos from API
  Future<void> refreshSavedVideos() async {
    await loadSavedVideosFromAPI(isRefresh: true);
  }
  //!------------------------------------------------------------------------------------

  /// Refresh videos from API
  Future<void> refreshVideos() async {
    await loadVideosFromAPI(isRefresh: true);
  }

  /// Toggle favorite status with API call
  Future<void> toggleFavorite(String id) async {
    try {
      // Optimistically update UI first
      final index = _allVideos.indexWhere((element) => element.id == id);
      if (index == -1) return;

      final video = _allVideos[index];
      final wasLiked = video.liked;

      // Update locally first for immediate UI feedback
      final updatedVideo = video.copyWith(
        favCount: wasLiked ? video.favCount - 1 : video.favCount + 1,
        liked: !wasLiked,
        updatedAt: DateTime.now(),
      );

      _allVideos[index] = updatedVideo;
      _updateFilteredLists();
      update();

      // Make API call
      final response = await _networkCaller.patchRequest(
        url: Urls.likeVideoTip(id),
        body: {}, // Empty body as it's just toggling
      );

      if (!response.isSuccess) {
        // Revert changes if API call failed
        _allVideos[index] = video;
        _updateFilteredLists();
        update();

        EasyLoading.showError(
          'Failed to ${wasLiked ? 'unlike' : 'like'} video',
        );
      }
    } catch (e) {
      EasyLoading.showError('Network error occurred');
    }
  }

  /// Toggle saved status with API call
  Future<void> toggleSaved(String id) async {
    try {
      // Find video in the appropriate list based on current mode
      VideoModel? video;
      int index = -1;

      if (isSavedMode.value) {
        // In saved mode, find in saved videos list
        index = _savedVideos.indexWhere((element) => element.id == id);
        if (index != -1) {
          video = _savedVideos[index];
        }
      } else {
        // In regular mode, find in all videos list
        index = _allVideos.indexWhere((element) => element.id == id);
        if (index != -1) {
          video = _allVideos[index];
        }
      }

      if (video == null) return;

      final wasSaved = video.saved;

      // Update locally first for immediate UI feedback
      if (isSavedMode.value) {
        if (wasSaved) {
          // In saved mode, remove the item when unsaving
          _savedVideos.removeAt(index);
        }
      } else {
        // In regular mode, update the save status
        final updatedVideo = video.copyWith(
          saved: !wasSaved,
          updatedAt: DateTime.now(),
        );
        _allVideos[index] = updatedVideo;
        _updateFilteredLists();
      }

      update();

      // Make API call
      final response = await _networkCaller.patchRequest(
        url: Urls.saveVideoTip(id),
        body: {}, // Empty body as it's just toggling
      );

      if (!response.isSuccess) {
        // Revert changes if API call failed
        if (isSavedMode.value) {
          if (wasSaved) {
            // Re-add the item back to saved list
            _savedVideos.insert(index, video);
          }
        } else {
          _allVideos[index] = video;
          _updateFilteredLists();
        }
        update();

        EasyLoading.showError(
          'Failed to ${wasSaved ? 'unsave' : 'save'} video',
        );
      } else {
        // Show success message
        EasyLoading.showSuccess(
          wasSaved ? 'Video unsaved successfully' : 'Video saved successfully',
        );
      }
    } catch (e) {
      EasyLoading.showError('Network error occurred');
    }
  }

  /// Update filtered lists after changes
  void _updateFilteredLists() {
    _savedVideos = _allVideos.where((element) => element.saved).toList();
    _filteredVideos = _allVideos;
  }

  //!------------------------------- Save/Unsave video tip -------------------------
  /// Save a video tip
  Future<void> saveVideoTip(String videoId) async {
    try {
      final response = await _networkCaller.patchRequest(
        url: Urls.saveVideoTip(videoId),
        body: {},
      );

      if (response.isSuccess) {
        // Update local video save state
        for (int i = 0; i < _allVideos.length; i++) {
          if (_allVideos[i].id == videoId) {
            _allVideos[i] = _allVideos[i].copyWith(saved: true);
            break;
          }
        }

        // Update saved videos list
        for (int i = 0; i < _savedVideos.length; i++) {
          if (_savedVideos[i].id == videoId) {
            _savedVideos[i] = _savedVideos[i].copyWith(saved: true);
            break;
          }
        }

        update();

        EasyLoading.showSuccess('Video saved successfully');
      } else {
        throw Exception('Failed to save video');
      }
    } catch (e) {
      EasyLoading.showError('Failed to save video: ${e.toString()}');
    }
  }

  /// Unsave a video tip
  Future<void> unsaveVideoTip(String videoId) async {
    try {
      final response = await _networkCaller.patchRequest(
        url: Urls.saveVideoTip(
          videoId,
        ), // Same endpoint, PATCH request toggles save state
        body: {},
      );

      if (response.isSuccess) {
        // Update local video save state
        for (int i = 0; i < _allVideos.length; i++) {
          if (_allVideos[i].id == videoId) {
            _allVideos[i] = _allVideos[i].copyWith(saved: false);
            break;
          }
        }

        // Remove from saved videos list if in saved mode
        if (isSavedMode.value) {
          _savedVideos.removeWhere((video) => video.id == videoId);
        } else {
          // Update saved videos list
          for (int i = 0; i < _savedVideos.length; i++) {
            if (_savedVideos[i].id == videoId) {
              _savedVideos[i] = _savedVideos[i].copyWith(saved: false);
              break;
            }
          }
        }

        update();

        EasyLoading.showSuccess('Video unsaved successfully');
      } else {
        throw Exception('Failed to unsave video');
      }
    } catch (e) {
      EasyLoading.showError('Failed to unsave video: ${e.toString()}');
    }
  }

  /// Toggle save state of a video
  Future<void> toggleSaveVideo(String videoId, bool currentSaveState) async {
    if (currentSaveState) {
      await unsaveVideoTip(videoId);
    } else {
      await saveVideoTip(videoId);
    }
  }
  //!------------------------------------------------------------------------------------

  //!------------------------------- Delete video (Admin only)-------------------------
  Future<void> deleteVideo(String id) async {
    try {
      isLoading.value = true;

      final response = await _networkCaller.deleteRequest(
        Urls.deleteVideoTip(id),
      );

      if (response.isSuccess) {
        // Remove from local list
        _allVideos.removeWhere((video) => video.id == id);
        _updateFilteredLists();
        update();

        EasyLoading.showSuccess('Video deleted successfully');
      } else {
        throw Exception('Failed to delete video from server');
      }
    } catch (e) {
      EasyLoading.showError('Failed to delete video: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  //!------------------------------------------------------------------------------------

  //!------------------------------- Navigate to edit video (Admin only)-------------------------
  void editVideo(String id) {
    final video = _allVideos.firstWhere((video) => video.id == id);

    // Navigate to upload screen in edit mode
    Get.to(
      () => UploadTipsScreen(
        appBarTitle: 'Edit Video',
        isVideo: true,
        isEdit: true,
        videoData: video,
      ),
    );
  }

  //!------------------------------------------------------------------------------------
}
