import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/barbell_llm/models/chat_model.dart';
import 'package:barbell/features/barbell_llm/models/chat_response_model.dart';

/// chat controller for Barbell LLM chat functionality
class ChatController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Text controller for message input
  final TextEditingController messageController = TextEditingController();

  // Observable variables for reactive UI updates
  final RxList<Map<String, dynamic>> chatMessages =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSendingMessage = false.obs;
  final RxString currentSessionId = ''.obs;

  // Chat session data
  ChatSessionModel? currentChatSession;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  @override
  void onClose() {
    endChatSession();
    messageController.dispose();
    super.onClose();
  }

  //---------------- Initialize chat session by calling startChat API--------------//
  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Starting chat...');

      final response = await _networkCaller.postRequest(
        url: Urls.startChat,
        body: {},
      );

      EasyLoading.dismiss();

      if (response.isSuccess && response.responseData != null) {
        final startChatResponse = StartChatResponse.fromJson(
          response.responseData!,
        );

        if (startChatResponse.success) {
          currentChatSession = startChatResponse.data;
          currentSessionId.value = startChatResponse.data.id;

          // Load existing chat messages if any
          _loadExistingMessages();

          Logger().i(
            '✅ Chat session started successfully: ${currentSessionId.value}',
          );
        } else {
          EasyLoading.showError('Failed to start chat session');
        }
      } else {
        EasyLoading.showError('Failed to connect to chat service');
      }
    } catch (e) {
      EasyLoading.showError('Error starting chat');
      Logger().e('❌ Error initializing chat: $e');
    } finally {
      isLoading.value = false;
    }
  }
  //---------------- End chat session----------------//

  //---------------- Load existing chat messages from session----------------//
  void _loadExistingMessages() {
    if (currentChatSession?.chatList.isNotEmpty == true) {
      chatMessages.clear();

      for (var chatMessage in currentChatSession!.chatList) {
        // Add user message
        chatMessages.add({
          'text': chatMessage.userMessage,
          'isUser': true,
          'timestamp': chatMessage.timestamp,
          'index': chatMessages.length,
        });

        // Add AI response
        chatMessages.add({
          'text': chatMessage.aiResponse,
          'isUser': false,
          'timestamp': chatMessage.timestamp,
          'index': chatMessages.length,
          'responseId': chatMessage.responseId,
        });
      }
    }
  }
  //---------------- Load existing chat messages from session----------------//

  //---------------- Send message to AI and get response----------------//
  Future<void> sendMessage() async {
    final message = messageController.text.trim();

    if (message.isEmpty) {
      EasyLoading.showInfo('Please enter a message');
      return;
    }

    try {
      isSendingMessage.value = true;

      // Add user message to chat immediately for better UX
      chatMessages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now().toIso8601String(),
        'index': chatMessages.length,
      });

      // Clear input field
      messageController.clear();

      // Show typing indicator
      chatMessages.add({
        'text': 'AI is typing...',
        'isUser': false,
        'isTyping': true,
        'timestamp': DateTime.now().toIso8601String(),
        'index': chatMessages.length,
      });

      final response = await _networkCaller.postRequest(
        url: Urls.sendMessageAndGetReply,
        body: {'message': message},
      );

      // Remove typing indicator
      chatMessages.removeWhere((msg) => msg['isTyping'] == true);

      if (response.isSuccess && response.responseData != null) {
        final sendMessageResponse = SendMessageResponse.fromJson(
          response.responseData!,
        );

        if (sendMessageResponse.success) {
          // Add AI response to chat
          chatMessages.add({
            'text': sendMessageResponse.data.aiResponse,
            'isUser': false,
            'timestamp': sendMessageResponse.data.timestamp,
            'index': chatMessages.length,
            'responseId': sendMessageResponse.data.responseId,
          });

          Logger().i('✅ Message sent and response received');
        } else {
          EasyLoading.showError('Failed to get AI response');
          _addErrorMessage();
        }
      } else {
        EasyLoading.showError('Failed to send message');
        _addErrorMessage();
      }
    } catch (e) {
      EasyLoading.showError('Error sending message');
      Logger().e('❌ Error sending message: $e');
      _addErrorMessage();
    } finally {
      isSendingMessage.value = false;
      // Remove typing indicator if still there
      chatMessages.removeWhere((msg) => msg['isTyping'] == true);
    }
  }

  //---------------- Add error message to chat----------------//
  void _addErrorMessage() {
    chatMessages.add({
      'text': 'Sorry, I encountered an error. Please try again.',
      'isUser': false,
      'timestamp': DateTime.now().toIso8601String(),
      'index': chatMessages.length,
      'isError': true,
    });
  }

  /// Handle user feedback for AI responses
  Future<void> handleFeedback(
    int messageIndex,
    bool isPositive,
    String? comment,
  ) async {
    try {
      final message = chatMessages.firstWhere(
        (msg) => msg['index'] == messageIndex,
        orElse: () => {},
      );

      if (message.isNotEmpty && message['responseId'] != null) {
        Logger().i('📝 Feedback submitted: ${isPositive ? 'Positive' : 'Negative'}');
        if (comment?.isNotEmpty == true) {
          Logger().i('💬 Comment: $comment');
        }

        // Here you can implement feedback API call if needed
        EasyLoading.showSuccess(
          isPositive
              ? 'Thank you for your feedback!'
              : 'Feedback recorded. We\'ll improve!',
        );
      }
    } catch (e) {
      EasyLoading.showError('Error handling feedback');
      Logger().e('❌ Error handling feedback: $e');
    }
  }

 

  //---------------- End chat session----------------//
  Future<void> endChatSession() async {
    if (currentSessionId.value.isEmpty) return;

    try {
      Logger().i('🔚 Ending chat session: ${currentSessionId.value}');

      final response = await _networkCaller.postRequest(
        url: Urls.endChat,
        body: {},
      );

      if (response.isSuccess && response.responseData != null) {
        final endChatResponse = EndChatResponse.fromJson(
          response.responseData!,
        );

        if (endChatResponse.success) {
          Logger().i('✅ Chat session ended successfully');
          currentSessionId.value = '';
          currentChatSession = null;
          chatMessages.clear();
        }
      }
    } catch (e) {
      EasyLoading.showError('Error ending chat session');
      Logger().e('❌ Error ending chat session: $e');
    }
  }

  //---------------- Clear chat messages (for UI purposes)----------------//
  void clearChat() {
    chatMessages.clear();
  }

  /// Retry sending last message
  void retryLastMessage() {
    if (chatMessages.isNotEmpty) {
      final lastUserMessage = chatMessages.lastWhere(
        (msg) => msg['isUser'] == true,
        orElse: () => {},
      );

      if (lastUserMessage.isNotEmpty) {
        messageController.text = lastUserMessage['text'] ?? '';
        sendMessage();
      }
    }
  }
}
