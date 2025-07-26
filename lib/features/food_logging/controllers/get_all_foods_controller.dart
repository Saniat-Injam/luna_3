import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/food_logging/controllers/logged_food_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/models/food_item_model.dart';
import 'package:logger/logger.dart';

class GetAllFoodsController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<FoodCaloriesModel> _foodCaloriesModel = [];
  final List<FoodCaloriesModel> _filteredFoodCaloriesModel = [];

  List<FoodCaloriesModel> get foodsItems =>
      _filteredFoodCaloriesModel.isNotEmpty || searchQuery.value.isNotEmpty
          ? _filteredFoodCaloriesModel
          : _foodCaloriesModel;
  List<FoodCaloriesModel> get allFoodsItems => _foodCaloriesModel;
  List<FoodCaloriesModel> get personalFoodItems =>
      foodsItems.where((element) => element.userId != null).toList();

  final RxList<FoodItem> allFoodItems = <FoodItem>[].obs;
  final RxList<FoodItem> filteredFoodItems = <FoodItem>[].obs;
  final RxString selectedTab = 'All'.obs;
  final RxString searchQuery = ''.obs;

  Future<bool> getAllFoods() async {
    _isLoading = true;
    bool isSuccess = false;
    update();
    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getAllFood,
    );
    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'] as List<dynamic>;
      _foodCaloriesModel.clear();
      _foodCaloriesModel.addAll(
        data
            .map<FoodCaloriesModel>(
              (e) => FoodCaloriesModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );

      // Apply any existing search filter
      filterFoodItems();

      isSuccess = true;
      // EasyLoading.showSuccess('✅ ${response.responseData['message']}');
    } else {
      EasyLoading.showError('Something went wrong');
      Logger().e('Error: ${response.errorMessage}');
    }
    _isLoading = false;
    update();
    return isSuccess;
  }

  // remove item from foodsItems
  void removeFoodItem(String foodId) {
    _foodCaloriesModel.removeWhere((item) => item.sId == foodId);
    _filteredFoodCaloriesModel.removeWhere((item) => item.sId == foodId);
    update();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    filterFoodItems();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterFoodItems();
  }

  void clearSearch() {
    searchQuery.value = '';
    filterFoodItems();
  }

  void filterFoodItems() {
    var items = _foodCaloriesModel.toList();

    // Filter by search query (search in name and instructions/description)
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      items =
          items.where((item) {
            final name = (item.name ?? '').toLowerCase();
            final instructions = (item.instructions ?? '').toLowerCase();

            return name.contains(query) || instructions.contains(query);
          }).toList();
    }

    // Update filtered list
    _filteredFoodCaloriesModel.clear();
    _filteredFoodCaloriesModel.addAll(items);

    // Notify UI to update
    update();
  }

  void addFoodItem(FoodCaloriesModel item) {
    final loggedFoodController = Get.find<LoggedFoodController>();
    loggedFoodController.addFoodItem(
      item.name ?? '',
      item.nutritionPerServing?.calories?.toInt() ?? 0,
    );
    Get.back(); // Return to food logging screen
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Initialize with dummy data
  //   allFoodItems.value = [
  //     FoodItem(
  //       name: 'Chicken Provencal',
  //       calories: 780,
  //       imageUrl: ImagePath.chickenProvencal,
  //     ),
  //     FoodItem(
  //       name: 'Grilled Salmon',
  //       calories: 400,
  //       imageUrl: ImagePath.grilledSalmon,
  //     ),
  //     FoodItem(
  //       name: 'Spaghetti Carbonara',
  //       calories: 600,
  //       imageUrl: ImagePath.spaghettiCarbonara,
  //     ),
  //     FoodItem(
  //       name: 'Beef Burger (with bun)',
  //       calories: 300,
  //       imageUrl: ImagePath.beefBurger,
  //     ),
  //     FoodItem(
  //       name: 'Vegetable Stir-Fry',
  //       calories: 250,
  //       imageUrl: ImagePath.vegitable,
  //     ),
  //   ];
  //   filteredFoodItems.value = allFoodItems.toList();
  // }
}
