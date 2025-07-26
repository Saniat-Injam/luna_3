import 'package:barbell/core/models/response_data.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/profile/models/privacy_policy_model.dart';
import 'package:logger/logger.dart';

/// Service for handling Privacy Policy API operations
///
/// API Endpoints:
/// - GET /privacy-policy/get - Retrieve current privacy policy
/// - PATCH /privacy-policy/update/{id} - Update privacy policy (admin only)
/// - POST /privacy-policy/create - Create a new privacy policy (admin only)
/// - DELETE /privacy-policy/delete/{id} - Delete a privacy policy (admin only)
///
/// Response format:
/// ```json
/// {
///   "success": true,
///   "data": [
///     {
///       "_id": "686e42145018f1f3b3fe1f9d",
///       "title": "Privacy Policy",
///       "content": "<html>...</html>",
///       "version": "1.0",
///       "createdAt": "2025-07-09T10:19:00.184Z",
///       "updatedAt": "2025-07-15T08:44:21.962Z"
///     }
///   ]
/// }
/// ```
class PrivacyPolicyService {
  static final NetworkCaller _networkCaller = NetworkCaller();
  static final Logger _logger = Logger();

  /// Get Privacy Policy
  static Future<ResponseData> getPrivacyPolicy() async {
    try {
      final response = await _networkCaller.getRequest(
        url: Urls.getPrivacyPolicy,
      );

      if (response.isSuccess && response.responseData != null) {
        try {
          final privacyPolicyResponse = PrivacyPolicyResponse.fromJson(
            response.responseData,
          );

          return ResponseData(
            statusCode: response.statusCode,
            isSuccess: true,
            responseData: privacyPolicyResponse,
          );
        } catch (parseError) {
          _logger.e('Error parsing privacy policy response: $parseError');
          return ResponseData(
            statusCode: response.statusCode,
            isSuccess: false,
            errorMessage: 'Failed to parse privacy policy data',
          );
        }
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: response.errorMessage ?? 'Failed to get privacy policy',
        );
      }
    } catch (e) {
      _logger.e('Error getting privacy policy: $e');
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update Privacy Policy (Admin only)
  static Future<ResponseData> updatePrivacyPolicy({
    required String id,
    required String title,
    required String content,
    String? version,
  }) async {
    try {
      final body = {
        'title': title,
        'content': content,
        if (version != null) 'version': version,
      };

      final response = await _networkCaller.patchRequest(
        url: Urls.updatePrivacyPolicy(id),
        body: body,
      );

      if (response.isSuccess) {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: response.responseData,
        );
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:
              response.errorMessage ?? 'Failed to update privacy policy',
        );
      }
    } catch (e) {
      _logger.e('Error updating privacy policy: $e');
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Create Privacy Policy (Admin only)
  static Future<ResponseData> createPrivacyPolicy({
    required String title,
    required String content,
    String? version,
  }) async {
    try {
      final body = {
        'title': title,
        'content': content,
        if (version != null) 'version': version,
      };

      final response = await _networkCaller.postRequest(
        url: Urls.createPrivacyPolicy,
        body: body,
      );

      if (response.isSuccess) {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: response.responseData,
        );
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:
              response.errorMessage ?? 'Failed to create privacy policy',
        );
      }
    } catch (e) {
      _logger.e('Error creating privacy policy: $e');
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Delete Privacy Policy (Admin only)
  static Future<ResponseData> deletePrivacyPolicy(String id) async {
    try {
      final response = await _networkCaller.deleteRequest(
        Urls.deletePrivacyPolicy(id),
      );

      if (response.isSuccess) {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: response.responseData,
        );
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:
              response.errorMessage ?? 'Failed to delete privacy policy',
        );
      }
    } catch (e) {
      _logger.e('Error deleting privacy policy: $e');
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
