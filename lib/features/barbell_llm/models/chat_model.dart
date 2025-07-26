/// Chat session model for Barbell LLM chat
class ChatSessionModel {
  final String userId;
  final String id;
  final List<ChatMessageModel> chatList;
  final int v;

  const ChatSessionModel({
    required this.userId,
    required this.id,
    required this.chatList,
    required this.v,
  });

  /// Create ChatSession from JSON
  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      userId: json['user_id'] ?? '',
      id: json['_id'] ?? '',
      chatList:
          (json['chatList'] as List<dynamic>?)
              ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      v: json['__v'] ?? 0,
    );
  }

  /// Convert ChatSession to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      '_id': id,
      'chatList': chatList.map((e) => e.toJson()).toList(),
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'ChatSessionModel(id: $id, userId: $userId, chatCount: ${chatList.length})';
  }
}

/// Individual chat message model
class ChatMessageModel {
  final String responseId;
  final String userId;
  final String userMessage;
  final String aiResponse;
  final String timestamp;
  final String status;
  final String sessionId;

  const ChatMessageModel({
    required this.responseId,
    required this.userId,
    required this.userMessage,
    required this.aiResponse,
    required this.timestamp,
    required this.status,
    required this.sessionId,
  });

  /// Create ChatMessage from JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      responseId: json['response_id'] ?? '',
      userId: json['user_id'] ?? '',
      userMessage: json['user_feedback'] ?? '',
      aiResponse: json['ai_response'] ?? '',
      timestamp: json['timestamp'] ?? '',
      status: json['status'] ?? '',
      sessionId: json['session_id'] ?? '',
    );
  }

  /// Convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'response_id': responseId,
      'user_id': userId,
      'user_feedback': userMessage,
      'ai_response': aiResponse,
      'timestamp': timestamp,
      'status': status,
      'session_id': sessionId,
    };
  }

  @override
  String toString() {
    return 'ChatMessageModel(responseId: $responseId, timestamp: $timestamp)';
  }
}
