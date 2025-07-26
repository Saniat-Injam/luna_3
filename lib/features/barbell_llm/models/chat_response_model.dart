import 'package:barbell/features/barbell_llm/models/chat_model.dart';

/// API response model for starting chat
class StartChatResponse {
  final bool success;
  final String message;
  final ChatSessionModel data;

  const StartChatResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Create StartChatResponse from JSON
  factory StartChatResponse.fromJson(Map<String, dynamic> json) {
    return StartChatResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatSessionModel.fromJson(json['data'] ?? {}),
    );
  }

  /// Convert StartChatResponse to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  String toString() {
    return 'StartChatResponse(success: $success, message: $message)';
  }
}

/// API response model for sending message and getting reply
class SendMessageResponse {
  final bool success;
  final String message;
  final ChatMessageModel data;

  const SendMessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Create SendMessageResponse from JSON
  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatMessageModel.fromJson(json['data'] ?? {}),
    );
  }

  /// Convert SendMessageResponse to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  String toString() {
    return 'SendMessageResponse(success: $success, message: $message)';
  }
}

/// API response model for ending chat
class EndChatResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  const EndChatResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Create EndChatResponse from JSON
  factory EndChatResponse.fromJson(Map<String, dynamic> json) {
    return EndChatResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }

  /// Convert EndChatResponse to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }

  @override
  String toString() {
    return 'EndChatResponse(success: $success, message: $message)';
  }
}
