class BarcodeResponse {
  final String code;
  final int status;
  final String statusVerbose;
  final Product? product;

  BarcodeResponse({
    required this.code,
    required this.status,
    required this.statusVerbose,
    this.product,
  });

  factory BarcodeResponse.fromJson(Map<String, dynamic> json) {
    return BarcodeResponse(
      code: json['code'] ?? '',
      status: json['status'] ?? 0,
      statusVerbose: json['status_verbose'] ?? '',
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }
}

class Product {
  final String id;
  final String productName;
  final String brands;
  final Map<String, dynamic> nutriments;
  final List<String> imageUrls;
  final String ingredients;
  final double servingSize;
  final String servingUnit;

  Product({
    required this.id,
    required this.productName,
    required this.brands,
    required this.nutriments,
    required this.imageUrls,
    required this.ingredients,
    required this.servingSize,
    required this.servingUnit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Extract image URLs
    List<String> images = [];
    if (json['image_front_url'] != null &&
        json['image_front_url'].toString().isNotEmpty) {
      images.add(json['image_front_url']);
    }
    if (json['image_ingredients_url'] != null &&
        json['image_ingredients_url'].toString().isNotEmpty) {
      images.add(json['image_ingredients_url']);
    }
    if (json['image_nutrition_url'] != null &&
        json['image_nutrition_url'].toString().isNotEmpty) {
      images.add(json['image_nutrition_url']);
    }

    // Extract serving size and unit
    double servingSize = 100.0; // Default to 100g if not specified
    String servingUnit = 'g';

    if (json['serving_quantity'] != null) {
      servingSize =
          double.tryParse(json['serving_quantity'].toString()) ?? 100.0;
    }
    if (json['serving_size'] != null) {
      final servingSizeStr = json['serving_size'].toString();
      final RegExp regExp = RegExp(r'(\d+\.?\d*)\s*([a-zA-Z]+)');
      final match = regExp.firstMatch(servingSizeStr);
      if (match != null) {
        servingSize = double.tryParse(match.group(1) ?? '100') ?? 100.0;
        servingUnit = match.group(2) ?? 'g';
      }
    }

    // Extract ingredients
    String ingredients = '';
    if (json['ingredients_text'] != null &&
        json['ingredients_text'].toString().isNotEmpty) {
      ingredients = json['ingredients_text'];
    } else if (json['ingredients_text_en'] != null &&
        json['ingredients_text_en'].toString().isNotEmpty) {
      ingredients = json['ingredients_text_en'];
    } else if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredients = (json['ingredients'] as List)
          .map((i) => i['text'] ?? '')
          .where((text) => text.isNotEmpty)
          .join(', ');
    }

    return Product(
      id: json['_id']?.toString() ?? '',
      productName:
          json['product_name'] ??
          json['product_name_en'] ??
          json['generic_name'] ??
          json['generic_name_en'] ??
          'Unknown Product',
      brands: json['brands'] ?? '',
      nutriments: json['nutriments'] ?? {},
      imageUrls: images,
      ingredients: ingredients,
      servingSize: servingSize,
      servingUnit: servingUnit,
    );
  }

  Map<String, double> getNutritionValues() {
    double getValuePer100g(String key) {
      final per100g = nutriments['${key}_100g'];
      if (per100g != null) {
        return double.tryParse(per100g.toString()) ?? 0.0;
      }
      final value = nutriments[key];
      if (value != null) {
        return double.tryParse(value.toString()) ?? 0.0;
      }
      return 0.0;
    }

    return {
      'calories':
          getValuePer100g('energy-kcal') > 0
              ? getValuePer100g('energy-kcal')
              : getValuePer100g('energy') /
                  4.184, // Convert kJ to kcal if needed
      'carbs': getValuePer100g('carbohydrates'),
      'protein': getValuePer100g('proteins'),
      'fat': getValuePer100g('fat'),
      'fiber': getValuePer100g('fiber'),
    };
  }
}
