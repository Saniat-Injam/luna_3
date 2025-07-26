import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackButtons extends StatefulWidget {
  final int messageIndex;
  final Function(bool isPositive, String? comment) onFeedback;

  const FeedbackButtons({
    super.key,
    required this.messageIndex,
    required this.onFeedback,
  });

  @override
  State<FeedbackButtons> createState() => _FeedbackButtonsState();
}

class _FeedbackButtonsState extends State<FeedbackButtons> {
  final commentController = TextEditingController();
  final showCommentField = false.obs;
  bool? isLiked;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(
                  isLiked == true ? Icons.thumb_up : Icons.thumb_up_outlined,
                  color:
                      isLiked == true ? AppColors.secondary : AppColors.textSub,
                  size: 20,
                ),
                label: Text(
                  'Helpful',
                  style: getTextStyleWorkSans(
                    color:
                        isLiked == true
                            ? AppColors.secondary
                            : AppColors.textSub,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLiked = true;
                  });
                  showCommentField.value = true;
                  widget.onFeedback(true, null);
                  Fluttertoast.showToast(
                    gravity: ToastGravity.TOP,
                    msg: 'Thank you for your feedback!',
                    backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                    textColor: Colors.white,
                  );
                },
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                icon: Icon(
                  isLiked == false
                      ? Icons.thumb_down
                      : Icons.thumb_down_outlined,
                  color: isLiked == false ? Colors.red : AppColors.textSub,
                  size: 20,
                ),
                label: Text(
                  'Not Helpful',
                  style: getTextStyleWorkSans(
                    color: isLiked == false ? Colors.red : AppColors.textSub,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLiked = false;
                  });
                  showCommentField.value = true;
                  widget.onFeedback(false, null);
                  Fluttertoast.showToast(
                    gravity: ToastGravity.TOP,
                    msg: 'Thank you for your feedback!',
                    backgroundColor: Colors.red.withValues(alpha: 0.8),
                    textColor: Colors.white,
                  );
                },
              ),
            ],
          ),
          Obx(() {
            if (!showCommentField.value) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: commentController,
                      style: getTextStyleWorkSans(
                        color: AppColors.textWhite,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        hintText: 'Add a comment (optional)',
                        hintStyle: getTextStyleWorkSans(
                          color: AppColors.textSub,
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 0.4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: AppColors.border,
                            width: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final comment = commentController.text;
                      widget.onFeedback(
                        isLiked ?? true,
                        comment,
                      );
                      if (comment.isNotEmpty) {
                        Fluttertoast.showToast(
                          gravity: ToastGravity.TOP,
                          msg: 'Comment submitted successfully!',
                          backgroundColor: AppColors.secondary.withValues(
                            alpha: 0.8,
                          ),
                          textColor: Colors.black,
                        );
                      }
                      commentController.clear();
                      showCommentField.value = false;
                    },
                    child: Text(
                      'Submit',
                      style: getTextStyleWorkSans(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
