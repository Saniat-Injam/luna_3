import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/widgets/typing_indicator.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final int messageIndex;
  final bool isTyping;
  final bool isError;
  final Function(bool isPositive, String? comment)? onFeedback;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.messageIndex,
    this.isTyping = false,
    this.isError = false,
    this.onFeedback,
  });

  /// Parses markdown text and returns a RichText widget with formatted text
  /// Supports **bold** formatting and proper line breaks
  Widget _buildFormattedText(String text, Color textColor) {
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');

    // Replace \n with actual line breaks
    text = text.replaceAll('\\n', '\n');

    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      // Add normal text before bold
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: getTextStyleWorkSans(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              lineHeight: 12,
            ),
          ),
        );
      }

      // Add bold text
      spans.add(
        TextSpan(
          text: match.group(1),
          style: getTextStyleWorkSans(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            lineHeight: 12,
          ),
        ),
      );

      lastEnd = match.end;
    }

    // Add remaining normal text
    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: getTextStyleWorkSans(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            lineHeight: 12,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans), textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    // Show typing indicator for AI typing
    if (isTyping && !isUser) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: TypingIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _getBubbleColor(),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft:
                            isUser
                                ? const Radius.circular(20)
                                : const Radius.circular(4),
                        bottomRight:
                            isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(20),
                      ),
                      border: Border.all(color: _getBorderColor(), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isError)
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Error',
                                style: getTextStyleWorkSans(
                                  color: AppColors.error,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        if (isError) const SizedBox(height: 8),
                        // Render text with markdown formatting support
                        _buildFormattedText(message, _getTextColor()),
                        if (!isUser && !isError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.smart_toy,
                                      color: AppColors.secondary,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AI Assistant',
                                      style: getTextStyleWorkSans(
                                        color: AppColors.textDescription,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                // Copy button for AI messages
                                Tooltip(
                                  message: 'Copy message',
                                  child: GestureDetector(
                                    onTap: () => _copyToClipboard(message),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.copy,
                                        color: AppColors.secondary,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          //TODO: Feedback buttons will here after Backend integration

          // if (!isUser && onFeedback != null && !isError && !isTyping) ...[
          //   const SizedBox(height: 8),
          //   FeedbackButtons(
          //     messageIndex: messageIndex,
          //     onFeedback: onFeedback!,
          //   ),
          // ],
        ],
      ),
    );
  }

  Color _getBubbleColor() {
    if (isError) return AppColors.error.withValues(alpha: 0.1);
    if (isUser) return AppColors.secondary;
    return AppColors.cardBackground;
  }

  Color _getBorderColor() {
    if (isError) return AppColors.error.withValues(alpha: 0.3);
    if (isUser) return AppColors.secondary.withValues(alpha: 0.3);
    return AppColors.border.withValues(alpha: 0.3);
  }

  Color _getTextColor() {
    if (isError) return AppColors.error;
    if (isUser) return Colors.black;
    return AppColors.textWhite;
  }

  /// Copy message to clipboard with feedback
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    Fluttertoast.showToast(
      backgroundColor: AppColors.secondary.withValues(alpha: 0.8),
      textColor: Colors.black,
      msg: 'Message copied to clipboard',
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
