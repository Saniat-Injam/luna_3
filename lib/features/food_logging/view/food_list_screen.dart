import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/food_favorites_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/view/create_food_screen.dart';
import 'package:barbell/features/food_logging/view/food_details_screen.dart';
import 'package:barbell/features/food_logging/widgets/all_food_list_contant_widget.dart';
import 'package:barbell/features/food_logging/widgets/food_item_card.dart';
import 'package:barbell/features/food_logging/widgets/tab_button.dart';
import 'package:shimmer/shimmer.dart';

class FoodListScreen extends StatelessWidget {
  static const routeName = '/food-list-screen';
  const FoodListScreen({super.key});

  void _fetchFoodsIfEmpty(GetAllFoodsController controller) {
    if (controller.foodsItems.isEmpty) {
      controller.getAllFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAllFoodController = Get.find<GetAllFoodsController>();
    final searchController = TextEditingController();

    // Fetch foods if the list is empty
    _fetchFoodsIfEmpty(getAllFoodController);

    final favoritesController = Get.put(FoodFavoritesController());
    Get.put(FoodImageController());

    // Ensure favorites are loaded when foods are available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for foods to be loaded, then refresh favorites
      if (getAllFoodController.foodsItems.isNotEmpty) {
        await favoritesController.refreshFavorites();
      } else {
        // If foods are not loaded yet, wait for them and then load favorites
        await getAllFoodController.getAllFoods();
        await favoritesController.refreshFavorites();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Foods List',
        showNotification: true,
        actions: [
          if (StorageService.role == 'user')
            Tooltip(
              message: 'Create new food item',
              child: IconButton(
                onPressed: () {
                  Get.to(() => const CreateFoodScreen(isCreate: true));
                },
                icon: const Icon(Icons.add, color: AppColors.textWhite),
              ),
            ),

          if (StorageService.role == 'admin')
            PopupMenuButton(
              icon: const Icon(Icons.add, color: AppColors.textWhite),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'personal',
                    child: Text('Create personal food'),
                  ),
                  const PopupMenuItem(
                    value: 'public',
                    child: Text('Create food for all users'),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'personal') {
                  Get.to(
                    () => CreateFoodScreen(
                      isCreate: true,
                      foodItem:
                          getAllFoodController.foodsItems.isNotEmpty
                              ? getAllFoodController.foodsItems.first
                              : null,
                      isForAllUsers: false,
                    ),
                  );
                } else if (value == 'public') {
                  Get.to(
                    () => const CreateFoodScreen(
                      isCreate: true,
                      isForAllUsers: true,
                    ),
                  );
                }
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // -------------- Search Bar --------------
              Obx(
                () => TextField(
                  controller: searchController,
                  onChanged: (value) {
                    getAllFoodController.updateSearchQuery(value);
                  },
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: getTextStyleWorkSans(
                      color: Color(0x99949494),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: AppColors.appbar,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                      gapPadding: 0,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                      gapPadding: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                      gapPadding: 0,
                    ),
                    suffixIcon:
                        getAllFoodController.searchQuery.value.isEmpty
                            ? Icon(
                              Icons.search,
                              color: Color(0x99949494),
                              size: 24,
                            )
                            : IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Color(0x99949494),
                                size: 24,
                              ),
                              onPressed: () {
                                searchController.clear();
                                getAllFoodController.clearSearch();
                              },
                            ),
                  ),
                ),
              ),

              // -------------- Tabs --------------
              const SizedBox(height: 20),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.appbar,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TabButton(
                              title: 'All',
                              controller: getAllFoodController,
                            ),
                          ),
                          // const SizedBox(width: 16),
                          Expanded(
                            child: TabButton(
                              title: 'favorites',
                              controller: getAllFoodController,
                            ),
                          ),
                          // const SizedBox(width: 16),
                          // TabButton(
                          //   title: 'Manual',
                          //   controller: getAllFoodController,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // -------------- Content based on selected tab --------------
              Expanded(
                child: Obx(() {
                  if (getAllFoodController.selectedTab.value == 'All') {
                    return _buildAllTabContent(getAllFoodController);
                  } else {
                    return _buildFavoritesTabContent(getAllFoodController);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllTabContent(GetAllFoodsController controller) {
    return GetBuilder<GetAllFoodsController>(
      builder: (controller) {
        return controller.isLoading
            ? Shimmer.fromColors(
              baseColor: AppColors.primary,
              highlightColor: AppColors.secondary,
              child: AllFoodListContantWidget(),
            )
            : AllFoodListContantWidget();
      },
    );
  }

  Widget _buildFavoritesTabContent(GetAllFoodsController controller) {
    final favoritesController = Get.find<FoodFavoritesController>();

    // Ensure favorites are loaded when this tab is accessed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.foodsItems.isNotEmpty) {
        await favoritesController.refreshFavorites();
      }
    });

    return Obx(() {
      // Filter favorites based on search query
      var filteredFavorites = favoritesController.favoriteItems.toList();

      if (controller.searchQuery.value.isNotEmpty) {
        final query = controller.searchQuery.value.toLowerCase();
        filteredFavorites =
            filteredFavorites.where((item) {
              final name = (item.name ?? '').toLowerCase();
              final instructions = (item.instructions ?? '').toLowerCase();
              return name.contains(query) || instructions.contains(query);
            }).toList();
      }

      if (filteredFavorites.isEmpty) {
        final message =
            controller.searchQuery.value.isNotEmpty
                ? 'No favorites match your search'
                : 'No favorites yet';
        return Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        );
      }

      return ListView.builder(
        itemCount: filteredFavorites.length,
        itemBuilder: (context, index) {
          final item = filteredFavorites[index];
          return GestureDetector(
            onTap: () => Get.to(() => FoodDetailsScreen(foodItem: item)),
            child: FoodItemCard(
              foodItem: item,
              onAdd: () => controller.addFoodItem(item),
            ),
          );
        },
      );
    });
  }
}
