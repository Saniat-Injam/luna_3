import 'package:barbell/features/food_logging/models/food_item.dart'
    as new_model;

class FoodItem {
  final String name;
  final int calories;
  final String imageUrl;
  final bool isFavorite;

  FoodItem({
    required this.name,
    required this.calories,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      calories: json['calories'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'calories': calories, 'imageUrl': imageUrl};
  }

  // Convert to new FoodItem model
  new_model.FoodItem toNewModel() {
    return new_model.FoodItem(
      name: name,
      barcode: '',
      brand: '',
      servingSize: 100,
      servingUnit: 'g',
      calories: calories.toDouble(),
      carbs: 0,
      protein: 0,
      fat: 0,
      fiber: 0,
      description: '',
      ingredients: '',
      imageUrls: [imageUrl],
    );
  }

  // Create from new FoodItem model
  factory FoodItem.fromNewModel(new_model.FoodItem item) {
    return FoodItem(
      name: item.name,
      calories: item.calories.toInt(),
      imageUrl:
          item.imageUrls.isNotEmpty
              ? item.imageUrls[0]
              : 'assets/images/placeholder.png',
    );
  }
}
