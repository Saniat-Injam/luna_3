import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/tips/models/article_model.dart';
import 'package:barbell/features/tips/view/upload_tips_screen.dart';

/// Controller for managing article tips
/// Handles API integration with pagination, search, and infinite scroll
class ArticleController extends GetxController {
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
  final RxInt totalArticles = 0.obs;
  final int pageLimit = 5;

  // Search
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  // Mode tracking
  final RxBool isSavedMode = false.obs;

  // Articles data
  List<ArticleModel> _allArticles = [];
  List<ArticleModel> _filteredArticles = [];
  List<ArticleModel> _savedArticles = [];

  List<ArticleModel> get articles => _filteredArticles;
  List<ArticleModel> get savedArticles => _savedArticles;

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
    _allArticles.clear();
    _filteredArticles.clear();
    _savedArticles.clear();

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
            loadMoreSavedArticles();
          } else {
            loadMoreArticles();
          }
        }
      }
    });
  }

  //!------------------------------- Fetch articles from API with pagination -------------------------
  Future<void> loadArticlesFromAPI({bool isRefresh = false}) async {
    try {
      // Set regular mode flag
      isSavedMode.value = false;

      if (isRefresh) {
        currentPage.value = 1;
        hasReachedEnd.value = false;
        _allArticles.clear();
        _filteredArticles.clear();
      }

      isLoading.value = true;
      errorMessage.value = '';

      final String url = _buildApiUrl();

      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> articlesJson = responseData['data'] ?? [];
        final Map<String, dynamic> pagination =
            responseData['pagination'] ?? {};

        // Parse pagination
        totalPages.value = pagination['pages'] ?? 1;
        totalArticles.value = pagination['total'] ?? 0;

        // Parse articles
        final List<ArticleModel> newArticles =
            articlesJson.map((json) => ArticleModel.fromJson(json)).toList();

        if (isRefresh) {
          _allArticles = newArticles;
        } else {
          _allArticles.addAll(newArticles);
        }

        _filteredArticles = _allArticles;
        _savedArticles =
            _allArticles.where((element) => element.saved).toList();

        // Check if reached end
        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        } else {
          hasReachedEnd.value = false;
        }

        update();
      } else {
        errorMessage.value = 'Failed to load articles from server';
        if (_allArticles.isEmpty) {
          // Only show error if no articles are loaded at all
          EasyLoading.showError('Failed to load articles');
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      if (_allArticles.isEmpty) {
        EasyLoading.showError('Please check your internet connection');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more articles for pagination with proper error handling
  Future<void> loadMoreArticles() async {
    if (isLoadingMore.value || hasReachedEnd.value) return;

    print('Loading more articles - setting isLoadingMore to true');
    isLoadingMore.value = true;
    update(); // Trigger UI update to show shimmer
    currentPage.value++;

    try {
      final String url = _buildApiUrl();
      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> articlesJson = responseData['data'] ?? [];

        final List<ArticleModel> newArticles =
            articlesJson.map((json) => ArticleModel.fromJson(json)).toList();

        _allArticles.addAll(newArticles);
        _filteredArticles = _allArticles;
        _savedArticles =
            _allArticles.where((element) => element.saved).toList();

        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      } else {
        // Revert page number on error
        currentPage.value--;
        EasyLoading.showError('Failed to load more articles');
      }
    } catch (e) {
      // Revert page number on error
      currentPage.value--;
      EasyLoading.showError('Network error occurred');
    } finally {
      print('Load more articles finished - setting isLoadingMore to false');
      isLoadingMore.value = false;
      update(); // Trigger UI update when loading more is complete
    }
  }

  /// Build API URL with pagination and search parameters
  String _buildApiUrl() {
    String url =
        '${Urls.getAllArticleTip}?page=${currentPage.value}&limit=$pageLimit';

    if (searchQuery.value.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(searchQuery.value)}';
    }

    return url;
  }

  /// Search articles with API call
  Future<void> searchArticles(String query) async {
    searchQuery.value = query;
    searchController.text = query;

    if (query.isEmpty) {
      // Reset to normal loading
      isSearching.value = false;
      currentPage.value = 1;
      hasReachedEnd.value = false;
      await loadArticlesFromAPI(isRefresh: true);
    } else {
      // Perform search
      isSearching.value = true;
      currentPage.value = 1;
      hasReachedEnd.value = false;
      await loadArticlesFromAPI(isRefresh: true);
    }
  }

  /// Clear search and reload all articles
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    currentPage.value = 1;
    hasReachedEnd.value = false;
    loadArticlesFromAPI(isRefresh: true);
  }
  //!---------------------------------------------------------------------------------

  //!---------------------------Refresh articles from API-----------------------------
  Future<void> refreshArticles() async {
    await loadArticlesFromAPI(isRefresh: true);
  }
  //!---------------------------End Refresh articles from API-------------------------

  //!---------------------------Toggle favorite status with API------------------------
  /// Toggle favorite status with API call
  Future<void> toggleFavorite(String id) async {
    // Optimistically update UI first
    final index = _allArticles.indexWhere((element) => element.id == id);
    if (index == -1) return;

    final article = _allArticles[index];
    final wasLiked = article.liked;

    // Update locally first for immediate UI feedback
    final updatedArticle = ArticleModel(
      id: article.id,
      title: article.title,
      description: article.description,
      image: article.image,
      tag: article.tag,
      favCount: wasLiked ? article.favCount - 1 : article.favCount + 1,
      userId: article.userId,
      createdAt: article.createdAt,
      updatedAt: DateTime.now(),
      saved: article.saved,
      liked: !wasLiked,
    );

    _allArticles[index] = updatedArticle;
    _updateFilteredLists();
    update();

    // Make API call
    final response = await _networkCaller.patchRequest(
      url: Urls.likeArticle(id),
      body: {}, // Empty body as it's just toggling
    );

    if (!response.isSuccess) {
      // Revert changes if API call failed
      _allArticles[index] = article;
      _updateFilteredLists();
      update();

      EasyLoading.showError(
        'Failed to ${wasLiked ? 'unlike' : 'like'} article',
      );
    }
  }
  //!---------------------------End Toggle favorite status-----------------------------

  //!---------------------------Toggle saved status with API---------------------------
  /// Toggle saved status with API call
  Future<void> toggleSaved(String id) async {
    try {
      // Find article in the appropriate list based on current mode
      ArticleModel? article;
      int index = -1;

      if (isSavedMode.value) {
        // In saved mode, find in saved articles list
        index = _savedArticles.indexWhere((element) => element.id == id);
        if (index != -1) {
          article = _savedArticles[index];
        }
      } else {
        // In regular mode, find in all articles list
        index = _allArticles.indexWhere((element) => element.id == id);
        if (index != -1) {
          article = _allArticles[index];
        }
      }

      if (article == null) return;

      final wasSaved = article.saved;

      // Update locally first for immediate UI feedback
      if (isSavedMode.value) {
        if (wasSaved) {
          // In saved mode, remove the item when unsaving
          _savedArticles.removeAt(index);
        }
      } else {
        // In regular mode, update the save status
        final updatedArticle = article.copyWith(
          saved: !wasSaved,
          updatedAt: DateTime.now(),
        );
        _allArticles[index] = updatedArticle;
        _updateFilteredLists();
      }

      update();

      // Make API call
      final response = await _networkCaller.patchRequest(
        url: Urls.saveArticle(id),
        body: {}, // Empty body as it's just toggling
      );

      if (!response.isSuccess) {
        // Revert changes if API call failed
        if (isSavedMode.value) {
          if (wasSaved) {
            // Re-add the item back to saved list
            _savedArticles.insert(index, article);
          }
        } else {
          _allArticles[index] = article;
          _updateFilteredLists();
        }
        update();

        EasyLoading.showError(
          'Failed to ${wasSaved ? 'unsave' : 'save'} article',
        );
      } else {
        // Show success message
        EasyLoading.showSuccess(
          wasSaved
              ? 'Article unsaved successfully'
              : 'Article saved successfully',
        );
      }
    } catch (e) {
      EasyLoading.showError('Network error occurred');
    }
  }
  //!---------------------------End Toggle saved status---------------------------------

  //!---------------------------Update filtered lists after changes---------------------
  /// Update filtered lists after changes
  void _updateFilteredLists() {
    _savedArticles = _allArticles.where((element) => element.saved).toList();
    _filteredArticles = _allArticles;
  }
  //!---------------------------End Update filtered lists after changes-----------------

  //!------------------------- Load Saved Articles with Pagination ---------------------
  /// Load saved articles from API with pagination and search
  Future<void> loadSavedArticlesFromAPI({bool isRefresh = false}) async {
    try {
      // Set saved mode flag
      isSavedMode.value = true;

      if (isRefresh) {
        currentPage.value = 1;
        hasReachedEnd.value = false;
        _savedArticles.clear();
      }

      isLoading.value = true;
      errorMessage.value = '';

      final String url = _buildSavedArticlesApiUrl();

      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> articlesJson = responseData['data'] ?? [];
        final Map<String, dynamic> pagination =
            responseData['pagination'] ?? {};

        // Parse pagination
        totalPages.value = pagination['pages'] ?? 1;
        totalArticles.value = pagination['total'] ?? 0;

        // Parse saved articles and ensure they are marked as saved
        final List<ArticleModel> newSavedArticles =
            articlesJson
                .map((json) => ArticleModel.fromJson(json))
                .map(
                  (article) => article.copyWith(saved: true),
                ) // Ensure saved flag is true
                .toList();

        if (isRefresh) {
          _savedArticles = newSavedArticles;
        } else {
          _savedArticles.addAll(newSavedArticles);
        }

        // Check if reached end
        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      } else {
        errorMessage.value = 'Failed to load saved articles from server';
        if (_savedArticles.isEmpty) {
          EasyLoading.showError('Failed to load saved articles');
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      if (_savedArticles.isEmpty) {
        EasyLoading.showError('Please check your internet connection');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more saved articles for pagination
  Future<void> loadMoreSavedArticles() async {
    if (isLoadingMore.value || hasReachedEnd.value) return;

    try {
      print('Loading more saved articles - setting isLoadingMore to true');
      isLoadingMore.value = true;
      update(); // Trigger UI update to show shimmer
      currentPage.value++;

      final String url = _buildSavedArticlesApiUrl();
      final response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess) {
        final Map<String, dynamic> responseData = response.responseData;
        final List<dynamic> articlesJson = responseData['data'] ?? [];

        final List<ArticleModel> newSavedArticles =
            articlesJson.map((json) => ArticleModel.fromJson(json)).toList();

        _savedArticles.addAll(newSavedArticles);

        if (currentPage.value >= totalPages.value) {
          hasReachedEnd.value = true;
        }

        update();
      } else {
        // Revert page number on error
        currentPage.value--;
        EasyLoading.showError('Failed to load more saved articles');
      }
    } catch (e) {
      // Revert page number on error
      currentPage.value--;
      EasyLoading.showError('Network error occurred');
    } finally {
      print(
        'Load more saved articles finished - setting isLoadingMore to false',
      );
      isLoadingMore.value = false;
      update(); // Trigger UI update when loading more is complete
    }
  }

  /// Build API URL for saved articles with pagination and search
  String _buildSavedArticlesApiUrl() {
    String url =
        '${Urls.getMySavedArticles}?page=${currentPage.value}&limit=$pageLimit';

    if (searchQuery.value.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(searchQuery.value)}';
    }

    return url;
  }

  /// Search saved articles with API call
  Future<void> searchSavedArticles(String query) async {
    try {
      searchQuery.value = query;
      searchController.text = query;

      if (query.isEmpty) {
        // Reset to normal loading
        isSearching.value = false;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadSavedArticlesFromAPI(isRefresh: true);
      } else {
        // Perform search
        isSearching.value = true;
        currentPage.value = 1;
        hasReachedEnd.value = false;
        await loadSavedArticlesFromAPI(isRefresh: true);
      }
    } catch (e) {
      EasyLoading.showError('Failed to search saved articles');
    }
  }

  /// Refresh saved articles from API
  Future<void> refreshSavedArticles() async {
    await loadSavedArticlesFromAPI(isRefresh: true);
  }
  //!------------------------------------------------------------------------------------

  //!------------------------------- Delete article Api (Admin only)-------------------------
  Future<void> deleteArticle(String id) async {
    EasyLoading.show(status: 'Deleting article...');
    final response = await _networkCaller.deleteRequest(
      Urls.deleteArticleTip(id),
    );

    if (response.isSuccess) {
      // Remove from local list
      _allArticles.removeWhere((article) => article.id == id);
      _updateFilteredLists();
      update();

      EasyLoading.showSuccess('Article deleted successfully');
    } else {
      EasyLoading.showError('Failed to delete article');
    }
    EasyLoading.dismiss();
  }
  //!---------------------------------End Delete article Api---------------------------------

  //!------------------------------- Navigate to edit article (Admin only)-------------------
  void editArticle(String id) {
    final article = _allArticles.firstWhere((article) => article.id == id);

    // Navigate to upload screen in edit mode
    Get.to(
      () => UploadTipsScreen(
        appBarTitle: 'Edit Article',
        isVideo: false,
        isEdit: true,
        articleData: article,
      ),
    );
  }
  //!---------------------------------End Navigate to edit article------------------------------

  //!------------------------------------------------------------------------------------
}
