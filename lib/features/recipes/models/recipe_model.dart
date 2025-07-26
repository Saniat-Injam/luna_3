import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/models/nutrition_perserving_model.dart';

class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final int calories;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isFavorite;
  final bool isMyRecipe;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.calories,
    this.description = '',
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
    this.isMyRecipe = false,
  });

  // Convert Recipe to FoodItem for use with FoodDetailsScreen
  FoodCaloriesModel toFoodItem() {
    return FoodCaloriesModel(
      name: name,
      nutritionPerServing: NutritionPerServingModel(
        calories: calories.toDouble(),
      ),
      img: imageUrl,
      ingredients: ingredients,
      instructions: instructions.toString(),
    );
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? calories,
    String? description,
    List<String>? ingredients,
    List<String>? instructions,
    bool? isFavorite,
    bool? isMyRecipe,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
      isMyRecipe: isMyRecipe ?? this.isMyRecipe,
    );
  }
}
