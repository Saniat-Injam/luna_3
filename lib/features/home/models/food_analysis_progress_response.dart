import 'food_analysis_progress.dart';

/// API response wrapper for food analysis progress
/// Handles the standard API response format with success flag and data
class FoodAnalysisProgressResponse {
  final bool success;
  final String? message;
  final FoodAnalysisProgress? data;

  const FoodAnalysisProgressResponse({
    required this.success,
    this.message,
    this.data,
  });

  /// Create response from API JSON
  factory FoodAnalysisProgressResponse.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisProgressResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? FoodAnalysisProgress.fromJson(json) : null,
    );
  }

  /// Check if response is successful and has data
  bool get isSuccessful => success && data != null;

  @override
  String toString() {
    return 'FoodAnalysisProgressResponse(success: $success, message: $message, data: $data)';
  }
}
