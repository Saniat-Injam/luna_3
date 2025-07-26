import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/controllers/chat_controller.dart';
import 'package:barbell/features/barbell_llm/widgets/chat_bubble.dart';

class AskBarbellChatScreen extends StatelessWidget {
  const AskBarbellChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final scrollController = ScrollController();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomAppBar(
                title: 'Ask Barbell AI',
                showNotification: true,
                showBackButton: true,
              ),
            ),
            const SizedBox(height: 16),

            // Chat Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF264A34),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Chat Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.smart_toy_rounded,
                                color: AppColors.secondary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Barbell AI Assistant',
                                    style: getTextStyleWorkSans(
                                      color: AppColors.textWhite,
                                      fontSize: 16,
                                      lineHeight: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.isSendingMessage.value
                                          ? 'Thinking...'
                                          : 'Online • Ready to help',
                                      style: getTextStyleWorkSans(
                                        color:
                                            controller.isSendingMessage.value
                                                ? AppColors.secondary
                                                : AppColors.textDescription,
                                        fontSize: 12,
                                        lineHeight: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.2),
                      ),

                      // Chat Messages
                      Expanded(
                        child: Obx(() {
                          // Auto-scroll to bottom when new messages are added
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (scrollController.hasClients) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          });

                          return controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : controller.chatMessages.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 16,
                                ),
                                itemCount: controller.chatMessages.length,
                                itemBuilder: (context, index) {
                                  final message =
                                      controller.chatMessages[index];
                                  return ChatBubble(
                                    message: message['text'] ?? '',
                                    isUser: message['isUser'] ?? false,
                                    messageIndex: message['index'] ?? index,
                                    isTyping: message['isTyping'] ?? false,
                                    isError: message['isError'] ?? false,
                                    onFeedback:
                                        !(message['isUser'] ?? false)
                                            ? (isPositive, comment) =>
                                                controller.handleFeedback(
                                                  message['index'] ?? index,
                                                  isPositive,
                                                  comment,
                                                )
                                            : null,
                                  );
                                },
                              );
                        }),
                      ),

                      // Message Input
                      _buildMessageInput(controller),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.chat, size: 40, color: AppColors.secondary),
          ),
          const SizedBox(height: 24),
          Text(
            'Start Your Conversation',
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ask me anything about fitness, workouts, nutrition, or health goals. I\'m here to help!',
            textAlign: TextAlign.center,
            style: getTextStyleWorkSans(
              color: AppColors.textDescription,
              fontSize: 14,
              lineHeight: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '💡 Try asking:',
                  style: getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 12,
                    lineHeight: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• "How do I lose weight safely?"\n• "What\'s the best workout for beginners?"\n• "How much protein should I eat?"',
                  style: getTextStyleWorkSans(
                    color: AppColors.textDescription,
                    fontSize: 12,
                    lineHeight: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              // Message input field with smart line expansion
              // Starts with 1 line, expands up to 4 lines, then becomes scrollable
              child: TextField(
                controller: controller.messageController,
                maxLines: 4,
                minLines: 1,
                maxLength: 1000,
                textInputAction: TextInputAction.send,
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 14,
                  lineHeight: 14,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  hintText: 'Ask me anything about fitness...',
                  hintStyle: getTextStyleWorkSans(
                    color: AppColors.textDescription,
                    fontSize: 14,
                    lineHeight: 14,
                  ),
                  border: InputBorder.none,
                  counterText: '', // Hide character counter
                  suffixIcon: Obx(
                    () => Container(
                      margin: const EdgeInsets.all(4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              controller.isSendingMessage.value
                                  ? AppColors.secondary.withValues(alpha: 0.7)
                                  : AppColors.secondary,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow:
                              controller.isSendingMessage.value
                                  ? []
                                  : [
                                    BoxShadow(
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap:
                                controller.isSendingMessage.value
                                    ? null
                                    : controller.sendMessage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:
                                  controller.isSendingMessage.value
                                      ? Center(
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.black.withValues(
                                                    alpha: 0.8,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.send_rounded,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onSubmitted:
                    controller.isSendingMessage.value
                        ? null
                        : (_) => controller.sendMessage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
