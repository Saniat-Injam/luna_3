import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';

import '../models/food_analysis_summary_model.dart';

class FoodAnalysisSummaryController extends GetxController {
  bool isLoading = false;
  FoodAnalysisSummaryResponse? summary;
  String? error;

  // Example: Replace with your actual data source (API, local, etc.)
  Future<bool> fetchFoodAnalysisSummary() async {
    isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getFoodAnalysisSummary(timeRange: 1),
    );

    if (response.isSuccess && response.responseData != null) {
      summary = FoodAnalysisSummaryResponse.fromJson(
        response.responseData["data"],
      );
      error = null; // Clear any previous error
      isSuccess = true;
    } else {
      error = response.errorMessage ?? 'Failed to fetch summary';
    }

    isLoading = false;
    update();
    return isSuccess;
  }
}
