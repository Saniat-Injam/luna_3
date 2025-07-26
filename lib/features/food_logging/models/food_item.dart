import 'package:json_annotation/json_annotation.dart';

part 'food_item.g.dart';

@JsonSerializable()
class FoodItem {
  final String name;
  final String barcode;
  final String brand;
  final double servingSize;
  final String servingUnit;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final double fiber;
  final String description;
  final String ingredients;
  final List<String> imageUrls;

  FoodItem({
    required this.name,
    required this.barcode,
    required this.brand,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.description,
    required this.ingredients,
    this.imageUrls = const [],
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemToJson(this);

  FoodItem copyWith({
    String? name,
    String? barcode,
    String? brand,
    double? servingSize,
    String? servingUnit,
    double? calories,
    double? carbs,
    double? protein,
    double? fat,
    double? fiber,
    String? description,
    String? ingredients,
    List<String>? imageUrls,
  }) {
    return FoodItem(
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
