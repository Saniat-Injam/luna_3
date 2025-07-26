import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/models/response_data.dart';
import 'package:barbell/core/services/storage_service.dart';

// ignore: constant_identifier_names
enum MultipartRequestType { POST, PUT, PATCH }

class NetworkCaller {
  final Logger _logger = Logger();

  //? ------------------------------------------------
  //* Get Request
  //? ------------------------------------------------
  Future<ResponseData> getRequest({
    required String url,
    String? accessToken,
  }) async {
    try {
      // parse url
      final uri = Uri.parse(url);
      // create header
      Map<String, String> headers = {"content-type": "application/json"};
      if (accessToken != null) {
        headers["Authorization"] = accessToken; // Use the provided token
      } else {
        if (StorageService.accessToken != null) {
          headers["Authorization"] = StorageService.accessToken!;
        }
      }
      _logger.i("url: $url \n headers: $headers");
      // call http get
      final response = await http.get(uri, headers: headers);
      _logger.i(
        "url: $url \n statusCode: ${response.statusCode} \n headers: $headers \n body: ${response.body}",
      );

      // check is success
      if (response.statusCode == 200) {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: jsonDecode(response.body),
        );
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: jsonDecode(response.body)["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e("url: $url \n status code: -1 \n error: $e");
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //* Post Request
  //? ------------------------------------------------
  Future<ResponseData> postRequest({
    required String url,
    Map<String, dynamic>? body,
    String? accessToken,
    bool needToken = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      Map<String, String> headers = {"content-type": "application/json"};
      if (accessToken != null) {
        headers["Authorization"] = accessToken;
      } else if (StorageService.accessToken != null) {
        headers["Authorization"] = StorageService.accessToken!;
      } else if (needToken) {
        return ResponseData(
          statusCode: -1,
          isSuccess: false,
          errorMessage: "No token found",
        );
      }
      _logger.i("url: $url \n headers: $headers \n body: $body");
      // call http post
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _logger.i(
        "url: $url \n statusCode: ${response.statusCode} \n headers: $headers \n response: ${response.body}",
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: data,
          errorMessage: data["message"],
        );
      } else {
        return ResponseData(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage: data["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e("url: $url \n status code: -1 \n error: $e");
      return ResponseData(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //* Multipart Request
  //? ------------------------------------------------
  Future<ResponseData> multipartRequest({
    required String url,
    required Map<String, dynamic> jsonData,
    required XFile? image,
    String? accessToken,
    bool? isPatchRequest = false,
    String fileName = "file",
    String fieldName = "data",
  }) async {
    if (image == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: "Image is null",
      );
    }
    try {
      final file = File(image.path);
      final uri = Uri.parse(url);

      // Create the multipart request
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      final token = StorageService.accessToken;
      if (token != null) {
        request.headers['Authorization'] = token;
      }
      // Don't set Content-Type for multipart, let http package handle it

      // Add file
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        fileName,
        http.ByteStream(file.openRead()),
        length,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add JSON data as a field
      request.fields[fieldName] = jsonEncode(jsonData);

      _logger.i("Sending request to: $url");
      _logger.i("Headers: ${request.headers}");
      _logger.i("JSON Data: $jsonData");
      _logger.i("Form Fields: ${request.fields}");
      _logger.i("File size: ${await file.length()} bytes");

      // Send the request with extended timeout for large files
      final response = await request.send().timeout(
        const Duration(minutes: 10), // Extended timeout for large video files
        onTimeout: () {
          throw Exception(
            'Upload timeout: The file is taking too long to upload. Please try with a smaller file or check your internet connection.',
          );
        },
      );

      final responseBody = await response.stream.bytesToString();

      _logger.i("Response status: ${response.statusCode}");
      _logger.i("Response body: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logger.i('Url => $url\nResponse => $responseBody');
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(responseBody),
        );
      } else {
        _logger.e('Url => $url\nResponse => $responseBody');

        // Handle specific error cases
        String errorMessage;
        if (response.statusCode == 520) {
          errorMessage =
              "Server error (520): The server returned an unknown error. The video file might be too large. Please try compressing the video or select a smaller file.";
        } else if (response.statusCode == 502) {
          errorMessage =
              "Server error (502): The video file might be too large for the server to process. Please try compressing the video or select a smaller file.";
        } else if (response.statusCode == 413) {
          errorMessage =
              "File too large (413): Please select a smaller video file.";
        } else if (response.statusCode == 408 || response.statusCode == 504) {
          errorMessage =
              "Upload timeout: The file is taking too long to upload. Please try with a smaller file or check your internet connection.";
        } else if (response.statusCode == 503) {
          errorMessage =
              "Service unavailable (503): The server is temporarily overloaded. Please try again in a few minutes.";
        } else {
          // Try to parse error message from response
          try {
            final errorData = jsonDecode(responseBody);
            errorMessage =
                errorData["message"] ??
                "Upload failed with status ${response.statusCode}";
          } catch (e) {
            // If response is not JSON (like HTML error page)
            if (responseBody.contains("502 Bad Gateway")) {
              errorMessage =
                  "Server error: The file might be too large or the server is temporarily unavailable.";
            } else {
              errorMessage = "Upload failed with status ${response.statusCode}";
            }
          }
        }

        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      _logger.e('Url => $url\nError => $e');
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //* Form Data Request (without file)
  //? ------------------------------------------------
  Future<ResponseData> formDataRequest({
    required String url,
    required Map<String, dynamic> jsonData,
    String? accessToken,
    String fieldName = "data",
  }) async {
    try {
      final uri = Uri.parse(url);

      // Create the multipart request
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      final token = StorageService.accessToken;
      if (token != null) {
        request.headers['Authorization'] = token;
      }

      // Add JSON data as a field
      request.fields[fieldName] = jsonEncode(jsonData);

      _logger.i("Sending form-data request to: $url");
      _logger.i("Headers: ${request.headers}");
      _logger.i("JSON Data: $jsonData");
      _logger.i("Form Fields: ${request.fields}");

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      _logger.i("Response status: ${response.statusCode}");
      _logger.i("Response body: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logger.i('Url => $url\nResponse => $responseBody');
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(responseBody),
        );
      } else {
        _logger.e('Url => $url\nResponse => $responseBody');
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonDecode(responseBody)["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e('Url => $url\nError => $e');
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  /// Multipart Request
  /// This method allows you to send a multipart PUT request with optional JSON data and a file.
  /// It can be used for updating resources on the server.
  Future<ResponseData> multipart({
    required String url,

    /// The type of multipart request (POST, PUT, PATCH).
    /// This is used to determine the HTTP method for the request.
    required MultipartRequestType type,

    /// Default is "data".
    /// If you want to change the field name for the JSON data, you can pass it as [fieldName].
    /// This is used to send JSON data in the request.
    String fieldName = "data",

    /// fields like : {"key": "value", "key2": "value2"}
    Map<String, dynamic>? fieldsData,

    /// If you want to upload a file, you can pass it as [files].
    /// If you do not want to upload a file, you can skip this parameter.
    XFile? file,

    /// Default is "file".
    /// If you want to change the field name for the file, you can pass it as [fileName].
    String fileName = "file",

    /// If you want to use seperate accessToken than pass [accessToken].
    String? accessToken,
  }) async {
    try {
      // final file = File(image.path);
      final uri = Uri.parse(url);

      // Create the multipart request
      var request = http.MultipartRequest(type.name, uri);

      if (accessToken != null) {
        request.headers['Authorization'] = accessToken;
      } else if (StorageService.accessToken != null) {
        request.headers['Authorization'] = StorageService.accessToken!;
      }

      request.headers['Content-Type'] = 'application/json';

      // Add files to upload
      // If file is null, we skip adding the file to the request
      if (file != null) {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          fileName,
          file.path,
        );
        _logger.i("Adding file: ${file.path}");
        request.files.add(multipartFile);
      }

      // add Other fields
      // If jsonData is null, we skip adding the JSON data to the request
      if (fieldsData != null) {
        _logger.i("Adding JSON data: $fieldsData");
        // Convert the JSON data to a string and add it to the request fields
        request.fields[fieldName] = jsonEncode(fieldsData);
      }

      _logger.i(
        "URL: $url,"
        "\nRequest Type: ${type.name},"
        "\nHeaders: ${request.headers},"
        "\nFields: ${request.fields},"
        "\nFiles: ${request.files.map((f) => f.filename).join(', ')}",
      );
      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      _logger.i(
        "Response status: ${response.statusCode}"
        "\nResponse body: $responseBody",
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _logger.i('Url => $url\nResponse => $responseBody');
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(responseBody),
        );
      } else {
        _logger.e('Url => $url\nResponse => $responseBody');
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody,
        );
      }
    } catch (e) {
      _logger.e('Url => $url\nError => $e');
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //* patch request
  //? ------------------------------------------------
  Future<ResponseData> patchRequest({
    required String url,
    required Map<String, dynamic> body,
    String? accessToken,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {"Content-Type": "application/json"};

      if (accessToken != null) {
        headers['Authorization'] = accessToken;
      } else if (StorageService.accessToken != null) {
        headers['Authorization'] = StorageService.accessToken!;
      }

      http.Response response = await http.patch(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      _logger.i(
        "url: $url \n statusCode: ${response.statusCode} \n headers: $headers \n response: ${response.body}",
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonDecode(response.body)["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e("url: $url \n status code: -1 \n error: $e");
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //* put request
  //? ------------------------------------------------
  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {"Content-Type": "application/json"};

      if (accessToken != null) {
        headers['Authorization'] = accessToken;
      } else if (StorageService.accessToken != null &&
          StorageService.accessToken!.isNotEmpty) {
        headers['Authorization'] = StorageService.accessToken!;
      }

      _logger.i("url: $url \n headers: $headers \n body: $body");

      http.Response response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      _logger.i(
        "url: $url \n statusCode: ${response.statusCode} \n headers: $headers \n response: ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonDecode(response.body)["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e("url: $url \n status code: -1 \n error: $e");
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //? ------------------------------------------------
  //! delete request
  //? ------------------------------------------------
  Future<ResponseData> deleteRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {"Content-Type": "application/json"};
      if (StorageService.accessToken != null &&
          StorageService.accessToken!.isNotEmpty) {
        headers['Authorization'] = StorageService.accessToken!;
      }

      _logger.i("url: $url \n headers: $headers");

      final http.Response response = await http.delete(uri, headers: headers);

      _logger.i(
        "url: $url \n statusCode: ${response.statusCode} \n headers: $headers \n body: ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonDecode(response.body)["message"] ?? "Unknown error",
        );
      }
    } catch (e) {
      _logger.e("url: $url \n status code: -1 \n error: $e");
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
