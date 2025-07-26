// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
  name: json['name'] as String,
  barcode: json['barcode'] as String,
  brand: json['brand'] as String,
  servingSize: (json['servingSize'] as num).toDouble(),
  servingUnit: json['servingUnit'] as String,
  calories: (json['calories'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  protein: (json['protein'] as num).toDouble(),
  fat: (json['fat'] as num).toDouble(),
  fiber: (json['fiber'] as num).toDouble(),
  description: json['description'] as String,
  ingredients: json['ingredients'] as String,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
  'name': instance.name,
  'barcode': instance.barcode,
  'brand': instance.brand,
  'servingSize': instance.servingSize,
  'servingUnit': instance.servingUnit,
  'calories': instance.calories,
  'carbs': instance.carbs,
  'protein': instance.protein,
  'fat': instance.fat,
  'fiber': instance.fiber,
  'description': instance.description,
  'ingredients': instance.ingredients,
  'imageUrls': instance.imageUrls,
};
