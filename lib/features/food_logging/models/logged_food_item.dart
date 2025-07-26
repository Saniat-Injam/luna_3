// Export the model
export 'logged_food_item.dart';

class LoggedFoodItem {
  final String name;
  final int calories;
  final String mealType;

  LoggedFoodItem({
    required this.name,
    required this.calories,
    required this.mealType,
  });
}
