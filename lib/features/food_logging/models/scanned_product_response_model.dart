class ScannedProductResponseModel {
  final String code;
  final List<ErrorDetail> errors;
  final Product? product;
  final Result? result;
  final String status;
  final List<dynamic> warnings;

  ScannedProductResponseModel({
    required this.code,
    required this.errors,
    this.product,
    this.result,
    required this.status,
    required this.warnings,
  });

  factory ScannedProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ScannedProductResponseModel(
      code: json['code'] as String,
      errors:
          (json['errors'] as List<dynamic>? ?? [])
              .map(
                (e) =>
                    e is String
                        ? ErrorDetail(message: e)
                        : ErrorDetail.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      status: json['status'] as String,
      warnings: json['warnings'] ?? [],
    );
  }
}

class ErrorDetail {
  final String? message;
  final Map<String, dynamic>? field;
  final Map<String, dynamic>? impact;
  final Map<String, dynamic>? messageObj;

  ErrorDetail({this.message, this.field, this.impact, this.messageObj});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      field: json['field'] as Map<String, dynamic>?,
      impact: json['impact'] as Map<String, dynamic>?,
      messageObj: json['message'] as Map<String, dynamic>?,
    );
  }
}

class Product {
  final String? imageUrl;
  final Nutriments? nutriments;
  final String? nutritionDataPer;
  final String? productName;
  final String? productQuantity;
  final String? servingQuantity;
  final String? quantity;

  Product({
    this.imageUrl,
    this.nutriments,
    this.nutritionDataPer,
    this.productName,
    this.productQuantity,
    this.servingQuantity,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      imageUrl: json['image_url'] as String?,
      nutriments:
          json['nutriments'] != null
              ? Nutriments.fromJson(json['nutriments'])
              : null,
      nutritionDataPer: json['nutrition_data_per'] as String?,
      productName: json['product_name'] as String?,
      productQuantity: json['product_quantity'] as String?,
      servingQuantity: json['serving_quantity'] as String?,
      quantity: json['quantity'] as String?,
    );
  }
}

class Nutriments {
  final double? carbohydrates;
  final double? carbohydrates100g;
  final double? carbohydratesServing;
  final String? carbohydratesUnit;
  final double? carbohydratesValue;
  final double? energy;
  final double? energyKcal;
  final double? energyKcal100g;
  final double? energyKcalServing;
  final String? energyKcalUnit;
  final double? energyKcalValue;
  final double? energyKcalValueComputed;
  final double? energy100g;
  final double? energyServing;
  final String? energyUnit;
  final double? energyValue;
  final double? fat;
  final double? fat100g;
  final double? fatServing;
  final String? fatUnit;
  final double? fatValue;
  final double? fiber;
  final double? fiber100g;
  final double? fiberServing;
  final String? fiberUnit;
  final double? fiberValue;
  final double? fruitsVegetablesLegumesEstimateFromIngredients100g;
  final double? fruitsVegetablesLegumesEstimateFromIngredientsServing;
  final double? fruitsVegetablesNutsEstimateFromIngredients100g;
  final double? fruitsVegetablesNutsEstimateFromIngredientsServing;
  final int? novaGroup;
  final int? novaGroup100g;
  final int? novaGroupServing;
  final int? nutritionScoreFr;
  final int? nutritionScoreFr100g;
  final double? proteins;
  final double? proteins100g;
  final double? proteinsServing;
  final String? proteinsUnit;
  final double? proteinsValue;
  final double? salt;
  final double? salt100g;
  final double? saltServing;
  final String? saltUnit;
  final double? saltValue;
  final double? saturatedFat;
  final double? saturatedFat100g;
  final double? saturatedFatServing;
  final String? saturatedFatUnit;
  final double? saturatedFatValue;
  final double? sodium;
  final double? sodium100g;
  final double? sodiumServing;
  final String? sodiumUnit;
  final double? sodiumValue;
  final double? sugars;
  final double? sugars100g;
  final double? sugarsServing;
  final String? sugarsUnit;
  final double? sugarsValue;

  Nutriments({
    this.carbohydrates,
    this.carbohydrates100g,
    this.carbohydratesServing,
    this.carbohydratesUnit,
    this.carbohydratesValue,
    this.energy,
    this.energyKcal,
    this.energyKcal100g,
    this.energyKcalServing,
    this.energyKcalUnit,
    this.energyKcalValue,
    this.energyKcalValueComputed,
    this.energy100g,
    this.energyServing,
    this.energyUnit,
    this.energyValue,
    this.fat,
    this.fat100g,
    this.fatServing,
    this.fatUnit,
    this.fatValue,
    this.fiber,
    this.fiber100g,
    this.fiberServing,
    this.fiberUnit,
    this.fiberValue,
    this.fruitsVegetablesLegumesEstimateFromIngredients100g,
    this.fruitsVegetablesLegumesEstimateFromIngredientsServing,
    this.fruitsVegetablesNutsEstimateFromIngredients100g,
    this.fruitsVegetablesNutsEstimateFromIngredientsServing,
    this.novaGroup,
    this.novaGroup100g,
    this.novaGroupServing,
    this.nutritionScoreFr,
    this.nutritionScoreFr100g,
    this.proteins,
    this.proteins100g,
    this.proteinsServing,
    this.proteinsUnit,
    this.proteinsValue,
    this.salt,
    this.salt100g,
    this.saltServing,
    this.saltUnit,
    this.saltValue,
    this.saturatedFat,
    this.saturatedFat100g,
    this.saturatedFatServing,
    this.saturatedFatUnit,
    this.saturatedFatValue,
    this.sodium,
    this.sodium100g,
    this.sodiumServing,
    this.sodiumUnit,
    this.sodiumValue,
    this.sugars,
    this.sugars100g,
    this.sugarsServing,
    this.sugarsUnit,
    this.sugarsValue,
  });

  factory Nutriments.fromJson(Map<String, dynamic> json) {
    return Nutriments(
      carbohydrates: _parseDouble(json['carbohydrates']),
      carbohydrates100g: _parseDouble(json['carbohydrates_100g']),
      carbohydratesServing: _parseDouble(json['carbohydrates_serving']),
      carbohydratesUnit: json['carbohydrates_unit'] as String?,
      carbohydratesValue: _parseDouble(json['carbohydrates_value']),
      energy: _parseDouble(json['energy']),
      energyKcal: _parseDouble(json['energy-kcal']),
      energyKcal100g: _parseDouble(json['energy-kcal_100g']),
      energyKcalServing: _parseDouble(json['energy-kcal_serving']),
      energyKcalUnit: json['energy-kcal_unit'] as String?,
      energyKcalValue: _parseDouble(json['energy-kcal_value']),
      energyKcalValueComputed: _parseDouble(json['energy-kcal_value_computed']),
      energy100g: _parseDouble(json['energy_100g']),
      energyServing: _parseDouble(json['energy_serving']),
      energyUnit: json['energy_unit'] as String?,
      energyValue: _parseDouble(json['energy_value']),
      fat: _parseDouble(json['fat']),
      fat100g: _parseDouble(json['fat_100g']),
      fatServing: _parseDouble(json['fat_serving']),
      fatUnit: json['fat_unit'] as String?,
      fatValue: _parseDouble(json['fat_value']),
      fiber: _parseDouble(json['fiber']),
      fiber100g: _parseDouble(json['fiber_100g']),
      fiberServing: _parseDouble(json['fiber_serving']),
      fiberUnit: json['fiber_unit'] as String?,
      fiberValue: _parseDouble(json['fiber_value']),
      fruitsVegetablesLegumesEstimateFromIngredients100g: _parseDouble(
        json['fruits-vegetables-legumes-estimate-from-ingredients_100g'],
      ),
      fruitsVegetablesLegumesEstimateFromIngredientsServing: _parseDouble(
        json['fruits-vegetables-legumes-estimate-from-ingredients_serving'],
      ),
      fruitsVegetablesNutsEstimateFromIngredients100g: _parseDouble(
        json['fruits-vegetables-nuts-estimate-from-ingredients_100g'],
      ),
      fruitsVegetablesNutsEstimateFromIngredientsServing: _parseDouble(
        json['fruits-vegetables-nuts-estimate-from-ingredients_serving'],
      ),
      novaGroup: _parseInt(json['nova-group']),
      novaGroup100g: _parseInt(json['nova-group_100g']),
      novaGroupServing: _parseInt(json['nova-group_serving']),
      nutritionScoreFr: _parseInt(json['nutrition-score-fr']),
      nutritionScoreFr100g: _parseInt(json['nutrition-score-fr_100g']),
      proteins: _parseDouble(json['proteins']),
      proteins100g: _parseDouble(json['proteins_100g']),
      proteinsServing: _parseDouble(json['proteins_serving']),
      proteinsUnit: json['proteins_unit'] as String?,
      proteinsValue: _parseDouble(json['proteins_value']),
      salt: _parseDouble(json['salt']),
      salt100g: _parseDouble(json['salt_100g']),
      saltServing: _parseDouble(json['salt_serving']),
      saltUnit: json['salt_unit'] as String?,
      saltValue: _parseDouble(json['salt_value']),
      saturatedFat: _parseDouble(json['saturated-fat']),
      saturatedFat100g: _parseDouble(json['saturated-fat_100g']),
      saturatedFatServing: _parseDouble(json['saturated-fat_serving']),
      saturatedFatUnit: json['saturated-fat_unit'] as String?,
      saturatedFatValue: _parseDouble(json['saturated-fat_value']),
      sodium: _parseDouble(json['sodium']),
      sodium100g: _parseDouble(json['sodium_100g']),
      sodiumServing: _parseDouble(json['sodium_serving']),
      sodiumUnit: json['sodium_unit'] as String?,
      sodiumValue: _parseDouble(json['sodium_value']),
      sugars: _parseDouble(json['sugars']),
      sugars100g: _parseDouble(json['sugars_100g']),
      sugarsServing: _parseDouble(json['sugars_serving']),
      sugarsUnit: json['sugars_unit'] as String?,
      sugarsValue: _parseDouble(json['sugars_value']),
    );
  }

  // Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to safely parse int values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Result {
  final String? id;
  final String? lcName;
  final String? name;

  Result({this.id, this.lcName, this.name});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'] as String?,
      lcName: json['lc_name'] as String?,
      name: json['name'] as String?,
    );
  }
}
