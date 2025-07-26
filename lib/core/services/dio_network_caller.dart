import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/models/response_data.dart';

/// Dio-based network caller optimized for large file uploads
/// Provides better handling of multipart uploads, progress tracking, and timeouts
class DioNetworkCaller {
  static final DioNetworkCaller _instance = DioNetworkCaller._internal();
  factory DioNetworkCaller() => _instance;
  DioNetworkCaller._internal();

  late Dio _dio;

  /// Initialize Dio with optimized settings for file uploads
  void initialize() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 15), // Extended for large files
        sendTimeout: const Duration(minutes: 15), // Extended for large files
        validateStatus:
            (status) => status! < 500, // Accept all status codes below 500
        headers: {'Accept': 'application/json'},
      ),
    );

    // Add interceptors for logging and authentication
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createAuthInterceptor());
  }

  /// Create logging interceptor for debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('🚀 DIO REQUEST: ${options.method} ${options.uri}');
        debugPrint('📤 Headers: ${options.headers}');
        if (options.data is FormData) {
          final formData = options.data as FormData;
          debugPrint(
            '📎 Form fields: ${formData.fields.map((e) => '${e.key}: ${e.value}').join(', ')}',
          );
          debugPrint('📁 Files: ${formData.files.length} file(s)');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
          '✅ DIO RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
        );
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
          '❌ DIO ERROR: ${error.response?.statusCode} ${error.message}',
        );
        debugPrint('🔍 Error data: ${error.response?.data}');
        handler.next(error);
      },
    );
  }

  /// Create authentication interceptor
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = StorageService.accessToken;
        if (token != null) {
          options.headers['Authorization'] = token;
        }
        handler.next(options);
      },
    );
  }

  /// Upload file with multipart form data using Dio
  /// Provides better handling for large files and progress tracking
  Future<ResponseData> uploadFile({
    required String url,
    required Map<String, dynamic> data,
    required XFile file,
    String fileName = 'file',
    String fieldName = 'data',
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      // Create form data
      final formData = FormData();

      // Add JSON data as a field
      formData.fields.add(MapEntry(fieldName, _mapToJsonString(data)));

      // Add file
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.name.isNotEmpty ? file.name : 'video.mp4',
      );
      formData.files.add(MapEntry(fileName, multipartFile));

      // Log file information
      final fileSize = await File(file.path).length();
      debugPrint(
        '📊 File size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB',
      );
      debugPrint('📝 File name: ${file.name}');
      debugPrint('🎯 Upload URL: $url');

      // Make the request with progress tracking
      final response = await _dio.post(
        url,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          validateStatus: (status) => status! < 600, // Accept most status codes
        ),
      );

      // Handle successful response
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode!,
          responseData:
              response.data is Map<String, dynamic>
                  ? response.data
                  : {'data': response.data},
        );
      } else {
        // Handle error responses
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode!,
          errorMessage: _extractErrorMessage(response),
        );
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Handle Dio-specific exceptions with detailed error messages
  ResponseData _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ResponseData(
          isSuccess: false,
          statusCode: 408,
          errorMessage:
              'Connection timeout. Please check your internet connection and try again.',
        );

      case DioExceptionType.sendTimeout:
        return ResponseData(
          isSuccess: false,
          statusCode: 408,
          errorMessage:
              'Upload timeout. The file might be too large or your connection is slow. Try compressing the video.',
        );

      case DioExceptionType.receiveTimeout:
        return ResponseData(
          isSuccess: false,
          statusCode: 408,
          errorMessage: 'Server response timeout. Please try again later.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        return ResponseData(
          isSuccess: false,
          statusCode: statusCode,
          errorMessage: _getStatusCodeMessage(statusCode, e.response?.data),
        );

      case DioExceptionType.cancel:
        return ResponseData(
          isSuccess: false,
          statusCode: 499,
          errorMessage: 'Upload cancelled by user.',
        );

      case DioExceptionType.connectionError:
        return ResponseData(
          isSuccess: false,
          statusCode: 500,
          errorMessage:
              'Connection error. Please check your internet connection.',
        );

      default:
        return ResponseData(
          isSuccess: false,
          statusCode: e.response?.statusCode ?? 500,
          errorMessage: 'Network error: ${e.message}',
        );
    }
  }

  /// Get user-friendly error message based on status code
  String _getStatusCodeMessage(int statusCode, dynamic responseData) {
    switch (statusCode) {
      case 413:
        return 'File too large (413). The video file exceeds the server limit. Please compress the video or select a smaller file.';

      case 502:
        return 'Server error (502). The server cannot process large files right now. Please try compressing the video to reduce its size.';

      case 520:
        return 'Server error (520). Unknown server error occurred. The file might be too large. Please try compressing the video.';

      case 503:
        return 'Service unavailable (503). The server is temporarily overloaded. Please try again in a few minutes.';

      case 504:
        return 'Gateway timeout (504). The upload took too long. Please try with a smaller or compressed video file.';

      case 400:
        return 'Bad request (400). Invalid file format or missing required data. Please check your video file.';

      case 401:
        return 'Authentication failed (401). Please log in again.';

      case 403:
        return 'Access denied (403). You don\'t have permission to upload files.';

      case 404:
        return 'Upload endpoint not found (404). Please contact support.';

      case 422:
        return 'Validation error (422). ${_extractValidationMessage(responseData)}';

      default:
        return 'Upload failed with status $statusCode. ${_extractErrorMessage(null, responseData)}';
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(Response? response, [dynamic fallbackData]) {
    final data = response?.data ?? fallbackData;

    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['detail'] ??
          'Server returned an error';
    } else if (data is String) {
      return data.length > 200 ? '${data.substring(0, 200)}...' : data;
    }

    return 'Unknown server error';
  }

  /// Extract validation error messages
  String _extractValidationMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final messages = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              messages.addAll(value.map((e) => '$key: $e'));
            } else {
              messages.add('$key: $value');
            }
          });
          return messages.join(', ');
        }
      }
      return data['message'] ?? 'Validation failed';
    }
    return 'Invalid data provided';
  }

  /// Convert map to JSON string for form data
  String _mapToJsonString(Map<String, dynamic> map) {
    try {
      // Use proper JSON encoding
      final jsonString =
          '{${map.entries.map((entry) {
            final key = '"${entry.key}"';
            final value = _encodeValue(entry.value);
            return '$key:$value';
          }).join(',')}}';
      return jsonString;
    } catch (e) {
      debugPrint('Error converting map to JSON: $e');
      return '{}';
    }
  }

  /// Encode a value for JSON
  String _encodeValue(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is String) {
      return '"${_escapeString(value)}"';
    } else if (value is List) {
      return '[${value.map(_encodeValue).join(',')}]';
    } else if (value is Map) {
      return '{${(value as Map<String, dynamic>).entries.map((e) => '"${e.key}":${_encodeValue(e.value)}').join(',')}}';
    } else {
      return value.toString();
    }
  }

  /// Escape string for JSON
  String _escapeString(String str) {
    return str
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Create cancel token for cancelling requests
  CancelToken createCancelToken() => CancelToken();

  /// Cancel all pending requests
  void cancelAll() {
    _dio.close(force: true);
    initialize(); // Reinitialize after closing
  }
}
