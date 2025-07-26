import 'dart:math';

import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class CustomCircularProgress extends StatelessWidget {
  final double percentage;
  final double size;
  final Color progressColor;
  final Color backgroundColor;
  final Animation<double> animation;
  final double textSize;
  final double percentageSize;

  const CustomCircularProgress({
    super.key,
    required this.percentage,
    this.size = 200,
    this.progressColor = AppColors.secondary,
    this.backgroundColor = const Color(0xFF272F36),
    required this.animation,
    this.textSize = 14,
    this.percentageSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              percentage: animation.value * percentage,
              progressColor: progressColor,
              backgroundColor: backgroundColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(percentage).toInt()}%',
                    style: getTextStyleWorkSans(
                      color: AppColors.textOrange,
                      fontSize: percentageSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Net carbs intake',
                    style: getTextStyleWorkSans(
                      color: AppColors.textWhite.withValues(alpha: 0.6),
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.percentage,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = radius * 0.2;

    // Draw background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2, // Start from top
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      percentage != oldDelegate.percentage;
}
