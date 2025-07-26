import 'dart:convert';

import 'package:barbell/core/utils/logging/logger.dart';
import 'package:http/http.dart' as http;
import 'package:barbell/features/food_logging/models/barcode_response.dart';
import 'package:barbell/features/food_logging/models/food_item.dart';

class FoodDataService {
  static const String _baseUrl =
      'https://world.openfoodfacts.org/api/v0/product';

  Future<FoodItem?> getFoodByBarcode(String barcode) async {
    try {
      AppLoggerHelper.debug('Attempting to fetch food data for barcode: $barcode');

      final url = '$_baseUrl/$barcode.json';
      AppLoggerHelper.debug('Making API request to: $url');

      final response = await http.get(Uri.parse(url));
      AppLoggerHelper.info('API Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final barcodeResponse = BarcodeResponse.fromJson(data);

        if (barcodeResponse.status == 1 && barcodeResponse.product != null) {
          final product = barcodeResponse.product!;
          AppLoggerHelper.info('Found product data: ${product.productName}');

          final nutritionValues = product.getNutritionValues();

          return FoodItem(
            name: product.productName,
            barcode: barcode,
            brand: product.brands,
            servingSize: product.servingSize,
            servingUnit: product.servingUnit,
            calories: nutritionValues['calories'] ?? 0,
            carbs: nutritionValues['carbs'] ?? 0,
            protein: nutritionValues['protein'] ?? 0,
            fat: nutritionValues['fat'] ?? 0,
            fiber: nutritionValues['fiber'] ?? 0,
            description: product.ingredients,
            ingredients: product.ingredients,
            imageUrls: product.imageUrls,
          );
        } else {
          AppLoggerHelper.warning('No product data found in the response');
          return null;
        }
      } else {
        AppLoggerHelper.error('API request failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      AppLoggerHelper.error('Error fetching food data', e);
      AppLoggerHelper.debug('Stack trace: $stackTrace');
      return null;
    }
  }
}
