import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

class AgeArcSlider extends StatefulWidget {
  final double initialAge;
  final Function(double) onChanged;

  const AgeArcSlider({
    super.key,
    this.initialAge = 38,
    required this.onChanged,
  });

  @override
  State<AgeArcSlider> createState() => _AgeArcSliderState();
}

class _AgeArcSliderState extends State<AgeArcSlider> {
  late double _currentAge;
  late double _angle;
  bool _isDragging = false;
  final double _minAge = 18;
  final double _maxAge = 80;

  @override
  void initState() {
    super.initState();
    _currentAge = widget.initialAge;
    _angle = (_currentAge - _minAge) / (_maxAge - _minAge) * (pi / 2);
  }

  void _updateAge(Offset position) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = Offset(size.width, size.height * 0.9);
    final touchPosition = position - center;

    // Calculate angle from touch position
    double angle = atan2(touchPosition.dy, touchPosition.dx);

    // Normalize angle to 0-pi/2 range for the bottom-left to right arc
    if (angle < -pi / 2) angle += 2 * pi;
    angle = (angle - pi).clamp(0, pi / 2);

    // Map angle back to age (18-80)
    double newAge = _minAge + (angle / (pi / 2)) * (_maxAge - _minAge);
    newAge = newAge.clamp(_minAge, _maxAge).roundToDouble();

    if (newAge != _currentAge) {
      setState(() {
        _currentAge = newAge;
        _angle = angle;
      });
      widget.onChanged(_currentAge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final radius = size.width * 0.85;
        final center = Offset(size.width, size.height * 0.9);
        final buttonSize = 80.0;

        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: AgeArcPainter(
                age: _currentAge,
                angle: _angle,
                isDragging: _isDragging,
              ),
            ),
            Positioned(
              // Center the button by offsetting half its size
              left: center.dx + radius * cos(pi + _angle) - (buttonSize / 2),
              top: center.dy + radius * sin(pi + _angle) - (buttonSize / 2),
              child: GestureDetector(
                onPanStart: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(
                    details.globalPosition,
                  );
                  _isDragging = true;
                  _updateAge(localPosition);
                },
                onPanUpdate: (details) {
                  if (_isDragging) {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(
                      details.globalPosition,
                    );
                    _updateAge(localPosition);
                  }
                },
                onPanEnd: (details) {
                  _isDragging = false;
                },
                child: SvgPicture.asset(
                  SvgPath.dragButtonSvg,
                  width: buttonSize,
                  height: buttonSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AgeArcPainter extends CustomPainter {
  final double age;
  final double angle;
  final bool isDragging;
  static const double strokeWidth = 8.0;

  AgeArcPainter({
    required this.age,
    required this.angle,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width, size.height * 0.9);
    final radius = size.width * 0.85;

    // Draw tick marks
    _drawTickMarks(canvas, center, radius);

    // Draw background arc
    final backgroundPaint =
        Paint()
          ..color = Color(0xff393C43)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi / 2,
      false,
      backgroundPaint,
    );

    // Draw progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [AppColors.secondary, AppColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, angle, false, progressPaint);
  }

  void _drawTickMarks(Canvas canvas, Offset center, double radius) {
    final tickPaint =
        Paint()
          ..color = Color(0xff5E5F52)
          ..strokeWidth = 0.9
          ..strokeCap = StrokeCap.round;

    const totalTicks = 5;
    const tickLength = 20.0;

    // Draw ticks below the arc
    for (int i = 0; i <= totalTicks; i++) {
      final tickAngle = pi + (pi / 2 / totalTicks) * i;
      final startPoint = Offset(
        center.dx + (radius - tickLength) * cos(tickAngle),
        center.dy + (radius - tickLength) * sin(tickAngle),
      );
      final endPoint = Offset(
        center.dx + radius * cos(tickAngle),
        center.dy + radius * sin(tickAngle),
      );
      canvas.drawLine(startPoint, endPoint, tickPaint);
    }

    // Draw ticks above the arc
    for (int i = 0; i <= totalTicks; i++) {
      final tickAngle = pi + (pi / 2 / totalTicks) * i;
      final startPoint = Offset(
        center.dx + (radius + tickLength) * cos(tickAngle),
        center.dy + (radius + tickLength) * sin(tickAngle),
      );
      final endPoint = Offset(
        center.dx + radius * cos(tickAngle),
        center.dy + radius * sin(tickAngle),
      );
      canvas.drawLine(startPoint, endPoint, tickPaint);
    }
  }

  @override
  bool shouldRepaint(AgeArcPainter oldDelegate) {
    return oldDelegate.age != age ||
        oldDelegate.angle != angle ||
        oldDelegate.isDragging != isDragging;
  }
}
