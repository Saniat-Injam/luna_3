import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/features/food_logging/models/food_item.dart';
import 'package:barbell/features/food_logging/models/scanned_product_response_model.dart';
import 'package:barbell/features/food_logging/widgets/barcode_scanner_dialogs.dart';

class BarcodeScannerController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  final logger = Logger();

  final _foodItem = Rxn<FoodItem>();
  FoodItem? get foodItem => _foodItem.value;

  final _isProcessing = false.obs;
  final _lastScannedBarcode = ''.obs;
  final _lastScanTime = 0.obs;

  static const int _minimumScanInterval = 2000; // 2 seconds in milliseconds

  Future<void> handleBarcodeScan(String code) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (code == _lastScannedBarcode.value &&
        currentTime - _lastScanTime.value < _minimumScanInterval) {
      logger.d('Ignoring duplicate scan within $_minimumScanInterval ms');
      return;
    }
    if (_isProcessing.value) {
      logger.d('Scan already in progress, ignoring new scan');
      return;
    }
    try {
      logger.d('Starting scan process for code: $code');
      _isProcessing.value = true;
      _lastScannedBarcode.value = code;
      _lastScanTime.value = currentTime;
      Get.back(); // Close scanner page
      if (_isNumericBarcode(code)) {
        EasyLoading.show(status: 'Fetching nutrition data...');
        final found = await getNutrationFromBarcode(
          code,
          showDialogOnNotFound: true,
        );
        if (!found) {
          // Already handled in getNutrationFromBarcode
        }
      } else {
        // Not a numeric barcode: show warning dialog and pop
        await Future.delayed(const Duration(milliseconds: 300));
        BarcodeScannerDialogs.showNoNutritionFoundDialog(code);
      }
    } catch (e, stackTrace) {
      logger.e('Error in handleBarcodeScan: $e');
      logger.e('Stack trace: $stackTrace');
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to process code. Please try again.');
    } finally {
      logger.d('Scan process completed');
      _isProcessing.value = false;
    }
  }

  bool _isNumericBarcode(String code) {
    // Check if the code is numeric and has a typical barcode length
    return int.tryParse(code) != null && code.length >= 8;
  }

  Future<bool> getNutrationFromBarcode(
    String barcode, {
    bool showDialogOnNotFound = false,
  }) async {
    final String url =
        'https://world.openfoodfacts.net/api/v3/product/$barcode?fields=product_name,image_url,product_quantity,quantity,nutrition_data_per,nutriments,serving_quantity';
    // final String url =
    //     'https://world.openfoodfacts.net/api/v2/product/$barcode';

    final response = await Get.find<NetworkCaller>().getRequest(url: url);
    EasyLoading.dismiss();
    if (response.isSuccess) {
      final ScannedProductResponseModel result =
          ScannedProductResponseModel.fromJson(response.responseData);
      // final data = response.responseData;
      if (result.status == 'success') {
        BarcodeScannerDialogs.showNutritionDataDialog(result);
        return true;
      } else if (showDialogOnNotFound) {
        // Not found: show warning dialog and pop
        await Future.delayed(const Duration(milliseconds: 300));
        BarcodeScannerDialogs.showSimpleNoNutritionFoundDialog();
        return false;
      }
    } else if (showDialogOnNotFound) {
      await Future.delayed(const Duration(milliseconds: 300));
      BarcodeScannerDialogs.showSimpleNoNutritionFoundDialog();
      return false;
    }
    return false;
  }
}
