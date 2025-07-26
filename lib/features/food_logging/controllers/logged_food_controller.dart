import 'package:get/get.dart';
import '../models/logged_food_item.dart';

class LoggedFoodController extends GetxController {
  final RxMap<String, RxList<LoggedFoodItem>> loggedFoodByMeal =
      {
        'Breakfast': RxList<LoggedFoodItem>(),
        'Lunch': RxList<LoggedFoodItem>(),
        'Dinner': RxList<LoggedFoodItem>(),
        'Snacks': RxList<LoggedFoodItem>(),
      }.obs;

  final RxString currentMealType = ''.obs;

  void setCurrentMealType(String mealType) {
    currentMealType.value = mealType;
  }

  void addFoodItem(String name, int calories) {
    if (currentMealType.value.isNotEmpty) {
      final newItem = LoggedFoodItem(
        name: name,
        calories: calories,
        mealType: currentMealType.value,
      );
      loggedFoodByMeal[currentMealType.value]?.add(newItem);
    }
  }

  void removeFoodItem(String mealType, int index) {
    loggedFoodByMeal[mealType]?.removeAt(index);
  }

  int getTotalCaloriesForMeal(String mealType) {
    return loggedFoodByMeal[mealType]?.fold<int>(
          0,
          (sum, item) => sum + item.calories,
        ) ??
        0;
  }

  bool hasFoodItems(String mealType) {
    return (loggedFoodByMeal[mealType]?.isNotEmpty ?? false);
  }
}
