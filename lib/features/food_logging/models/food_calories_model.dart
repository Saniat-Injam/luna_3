import 'package:barbell/features/food_logging/models/nutrition_perserving_model.dart';

class FoodCaloriesModel {
  String? sId;
  String? img;
  String? userId;
  String? name;
  List<String>? ingredients;
  String? instructions;
  int? servings;
  int? preparationTime;
  NutritionPerServingModel? nutritionPerServing;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FoodCaloriesModel({
    this.sId,
    this.img,
    this.userId,
    this.name,
    this.ingredients,
    this.instructions,
    this.servings,
    this.preparationTime,
    this.nutritionPerServing,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  FoodCaloriesModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    img = json['img'];
    userId = json['user_id'];
    name = json['name'];
    ingredients = json['ingredients'].cast<String>();
    instructions = json['instructions'];
    servings = json['servings'];
    preparationTime = json['preparationTime'];
    nutritionPerServing =
        json['nutritionPerServing'] != null
            ? NutritionPerServingModel.fromJson(json['nutritionPerServing'])
            : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['_id'] = sId;
    // data['img'] = img;
    // data['user_id'] = userId;
    data['name'] = name;
    data['ingredients'] = ingredients;
    data['instructions'] = instructions;
    data['servings'] = servings;
    data['preparationTime'] = preparationTime;
    if (nutritionPerServing != null) {
      data['nutritionPerServing'] = nutritionPerServing!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['__v'] = iV;
    return data;
  }
}

/*
  {
      "_id": "6854dd8d1d1da5b82afacc92",
      "img": "https://res.cloudinary.com/dymow3weu/image/upload/v1750392204/Grilled%20Chicken%20Salad-1750392204092.jpg",
      "user_id": "68525cf2adbe3a262449191d",
      "name": "Grilled Chicken Salad",
      "ingredients": [
          "Chicken breast",
          "Mixed greens",
          "Cherry tomatoes",
          "Cucumber",
          "Olive oil",
          "Balsamic vinegar"
      ],
      "instructions": "1. Grill chicken breast until cooked through. 2. Chop vegetables. 3. Toss with olive oil and balsamic vinegar. 4. Slice chicken and serve over salad.",
      "servings": 2,
      "preparationTime": 30,
      "nutritionPerServing": {
          "calories": 350,
          "protein": 25,
          "carbs": 15,
          "fats": 20,
          "fiber": 5,
          "_id": "6854dd8d1d1da5b82afacc93"
      },
      "createdAt": "2025-06-20T04:03:25.331Z",
      "updatedAt": "2025-06-20T04:03:25.331Z",
      "__v": 0
  }

*/
