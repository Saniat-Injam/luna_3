import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/tips/controllers/article_controller.dart';
import 'package:barbell/features/tips/models/article_model.dart';
import 'package:barbell/features/tips/widgets/article_card.dart';
import 'package:barbell/features/tips/widgets/article_shimmer_widget.dart';

class FitnessTipsScreen extends StatefulWidget {
  const FitnessTipsScreen({super.key, this.isSaved});
  final bool? isSaved;

  @override
  State<FitnessTipsScreen> createState() => _FitnessTipsScreenState();
}

class _FitnessTipsScreenState extends State<FitnessTipsScreen> {
  late ArticleController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ArticleController>();

    // Initialize the controller with proper mode only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        _isInitialized = true;
        if (widget.isSaved == true) {
          _controller.loadSavedArticlesFromAPI(isRefresh: true);
        } else {
          // Only load regular articles if not in saved mode and no articles loaded
          if (_controller.articles.isEmpty) {
            _controller.loadArticlesFromAPI(isRefresh: true);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    // Clear error states when screen is disposed
    if (Get.isRegistered<ArticleController>()) {
      final controller = Get.find<ArticleController>();
      controller.errorMessage.value = '';
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.isSaved == true ? "Saved Articles" : "Fitness Tips",
        showNotification: true,
      ),
      body: _FitnessTipsBody(isSaved: widget.isSaved),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class _FitnessTipsBody extends StatelessWidget {
  const _FitnessTipsBody({this.isSaved});
  final bool? isSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          if (isSaved != true) _buildSearchField(),
          if (isSaved != true) const SizedBox(height: 16),

          _buildArticlesList(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    final ArticleController articleController = Get.find<ArticleController>();
    return TextField(
      controller: articleController.searchController,
      style: AppTextStyle.f14W400().copyWith(color: AppColors.textSub),
      decoration: InputDecoration(
        hintText: 'Search for tips and articles',
        suffixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFF1C2227),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        // Use the new search method with API integration
        articleController.searchArticles(value);
      },
    );
  }

  // Build articles list with pull-to-refresh and infinite scroll
  Widget _buildArticlesList() {
    return Expanded(
      child: GetBuilder<ArticleController>(
        builder: (controller) {
          return Obx(() {
            // Show shimmer loading for initial load
            if (controller.isLoading.value && controller.articles.isEmpty) {
              return const ArticleShimmerWidget(itemCount: 5);
            }

            final articlesToShow =
                isSaved == true
                    ? controller.savedArticles
                    : controller.articles;

            // Show empty state
            if (articlesToShow.isEmpty && !controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: AppColors.textSub,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.isSearching.value &&
                              controller.searchQuery.value.isNotEmpty
                          ? 'No articles found for "${controller.searchQuery.value}"'
                          : 'No articles found',
                      style: AppTextStyle.f16W500().copyWith(
                        color: AppColors.textSub,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (controller.errorMessage.value.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: AppTextStyle.f14W400().copyWith(
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.refreshArticles(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      child: const Text('Retry'),
                    ),
                    if (controller.isSearching.value &&
                        controller.searchQuery.value.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => controller.clearSearch(),
                        child: Text(
                          'Clear Search',
                          style: AppTextStyle.f14W400().copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            // Show articles list with pull-to-refresh and infinite scroll
            return RefreshIndicator(
              onRefresh: () => controller.refreshArticles(),
              color: AppColors.secondary,
              backgroundColor: AppColors.background,
              child: Obx(() {
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(top: 22.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      articlesToShow.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show shimmer loading at the end when loading more
                    if (index == articlesToShow.length &&
                        controller.isLoadingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: ArticleShimmerWidget(itemCount: 2),
                      );
                    }

                    final ArticleModel article = articlesToShow[index];
                    return Padding(
                      key: ValueKey(
                        article.id,
                      ), // Add key for better performance
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ArticleCard(articleModel: article),
                    );
                  },
                );
              }),
            );
          });
        },
      ),
    );
  }
}
