import 'package:barbell/core/models/response_data.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/progress/models/food_analysis_summary_model.dart';

/// Service class to handle progress-related API calls
/// Manages food analysis and progress data from the server
class ProgressService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Get food analysis summary from API
  /// [timeRange] - Number of days to analyze (7, 30, 365)
  /// [filters] - List of nutrients to include ['calories', 'protein', 'carbs', 'fats']
  /// Returns: FoodAnalysisSummaryModel with daily and total data
  Future<FoodAnalysisSummaryModel> getFoodAnalysisSummary({
    int? timeRange,
    List<String>? filters,
  }) async {
    try {
      // Build API URL with parameters
      final String url = Urls.getFoodAnalysisSummary(
        timeRange: timeRange,
        filter: filters,
      );

      // Make GET request to server
      final ResponseData response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess && response.responseData != null) {
        // Parse successful response
        return FoodAnalysisSummaryModel.fromJson(response.responseData);
      } else {
        // Return empty model with error for failed response
        throw Exception(
          response.errorMessage ?? 'Failed to fetch food analysis data',
        );
      }
    } catch (e) {
      // Handle any errors during API call
      throw Exception('Error fetching food analysis summary: ${e.toString()}');
    }
  }

  /// Get food analysis progress data
  /// [timeRange] - Number of days to analyze
  /// Returns: Progress data for charts and visualization
  Future<Map<String, dynamic>> getFoodAnalysisProgress({int? timeRange}) async {
    try {
      // Build API URL for progress endpoint
      final String url = Urls.getFoodAnalysisProgress(timeRange);

      // Make GET request to server
      final ResponseData response = await _networkCaller.getRequest(url: url);

      if (response.isSuccess && response.responseData != null) {
        // Return progress data
        return response.responseData;
      } else {
        // Throw error for failed response
        throw Exception(
          response.errorMessage ?? 'Failed to fetch progress data',
        );
      }
    } catch (e) {
      // Handle any errors during API call
      throw Exception('Error fetching food analysis progress: ${e.toString()}');
    }
  }
}
