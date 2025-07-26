import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Professional typing indicator for AI responses
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12, right: 50),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smart_toy, color: AppColors.secondary, size: 16),
          const SizedBox(width: 8),
          Text(
            'AI is thinking',
            style: getTextStyleWorkSans(
              color: AppColors.textDescription,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                children: [
                  _buildDot(0),
                  const SizedBox(width: 3),
                  _buildDot(1),
                  const SizedBox(width: 3),
                  _buildDot(2),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = (_controller.value - (index * 0.2)) % 1.0;
        final double opacity =
            progress < 0.5
                ? (progress * 2).clamp(0.3, 1.0)
                : ((1.0 - progress) * 2).clamp(0.3, 1.0);

        return Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
