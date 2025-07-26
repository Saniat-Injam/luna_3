import 'package:get/get.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';

class FoodFavoritesController extends GetxController {
  final RxList<FoodCaloriesModel> favoriteItems = <FoodCaloriesModel>[].obs;

  // Store favorite IDs in memory for quick access
  final RxList<String> _favoriteIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load favorite IDs immediately for quick access
    loadFavoriteIds();
    // Don't load favorites immediately in onInit as food data might not be available
    // Favorites will be loaded when refreshFavorites() is called from the UI
  }

  /// Load favorite IDs from storage (independent of food data)
  Future<void> loadFavoriteIds() async {
    try {
      final favoriteIds = await StorageService.getFavoriteFoodIds();
      _favoriteIds.value = favoriteIds;
    } catch (e) {
      AppLoggerHelper.error('Error loading favorite IDs', e);
    }
  }

  Future<void> _loadFavorites() async {
    try {
      // Check if GetAllFoodsController exists and has data
      if (Get.isRegistered<GetAllFoodsController>()) {
        final allFoodsController = Get.find<GetAllFoodsController>();

        favoriteItems.clear();
        for (String id in _favoriteIds) {
          final foodItem = allFoodsController.allFoodsItems.firstWhereOrNull(
            (item) => item.sId == id,
          );
          if (foodItem != null) {
            favoriteItems.add(foodItem);
          }
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error loading favorites', e);
    }
  }

  Future<void> toggleFavorite(FoodCaloriesModel foodItem) async {
    final foodId = foodItem.sId ?? '';

    if (StorageService.isFavorite(foodId)) {
      await StorageService.removeFromFavorites(foodId);
      favoriteItems.removeWhere((item) => item.sId == foodId);
      _favoriteIds.remove(foodId); // Remove from in-memory favorite IDs
    } else {
      await StorageService.addToFavorites(foodId);
      favoriteItems.add(foodItem);
      _favoriteIds.add(foodId); // Add to in-memory favorite IDs
    }
  }

  bool isFavorite(FoodCaloriesModel foodItem) {
    final foodId = foodItem.sId ?? '';
    // Make this reactive by accessing the observable list
    return favoriteItems.any((item) => item.sId == foodId);
  }

  /// Check if a food is favorite using stored IDs
  bool isFavoriteById(String foodId) {
    return _favoriteIds.contains(foodId) || StorageService.isFavorite(foodId);
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }
}
