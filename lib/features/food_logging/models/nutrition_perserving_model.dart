class NutritionPerServingModel {
  double? calories;
  double? protein;
  double? carbs;
  double? fats;
  double? fiber;
  String? sId;

  NutritionPerServingModel({
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.sId,
  });

  NutritionPerServingModel.fromJson(Map<String, dynamic> json) {
    calories = json['calories']?.toDouble();
    protein = json['protein']?.toDouble();
    carbs = json['carbs']?.toDouble();
    fats = json['fats']?.toDouble();
    fiber = json['fiber']?.toDouble();
    sId = json['_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calories'] = calories;
    data['protein'] = protein;
    data['carbs'] = carbs;
    data['fats'] = fats;
    data['fiber'] = fiber;
    data['_id'] = sId;
    return data;
  }
}


/*
{
    "calories": 350,
    "protein": 25,
    "carbs": 15,
    "fats": 20,
    "fiber": 5,
}
*/