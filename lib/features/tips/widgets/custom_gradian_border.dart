import 'package:flutter/material.dart';

class CustomGradientOutlineInputBorder extends OutlineInputBorder {
  final double borderRadiusValue;
  final Gradient gradient;
  final double borderSideWidth;

  const CustomGradientOutlineInputBorder({
    required this.borderRadiusValue,
    required this.gradient,
    this.borderSideWidth = 2.0,
  }) : super(borderSide: BorderSide.none);

  @override
  BorderRadius get borderRadius => BorderRadius.circular(borderRadiusValue);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final roundedRect = RRect.fromRectAndRadius(
      rect.inflate(2.0),
      Radius.circular(borderRadiusValue),
    );

    final Paint paint = Paint();
    final Rect shaderRect = Rect.fromLTWH(
      0,
      0,
      roundedRect.width,
      roundedRect.height,
    );

    paint.shader = gradient.createShader(shaderRect);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = borderSideWidth; // Now works if defined in constructor

    canvas.drawRRect(roundedRect, paint);
  }
}

// class GradientOutlineInputBorder extends OutlineInputBorder {
//   final double borderRadiusValue;
//   final Gradient gradient;

//   const GradientOutlineInputBorder({
//     required this.borderRadiusValue,
//     required this.gradient,
//     double borderSideWidth = 2.0,
//   }) : super(
//           borderSide: BorderSide.none,
//         );

//   @override
//   BorderRadius get borderRadius => BorderRadius.circular(borderRadiusValue);

//   @override
//   void paint(
//     Canvas canvas,
//     Rect rect, {
//     double? gapStart,
//     double gapExtent = 0.0,
//     double gapPercentage = 0.0,
//     TextDirection? textDirection,
//   }) {
//     final roundedRect = RRect.fromRectAndRadius(rect.inflate(2.0), borderRadiusValue as Radius);
//     final Paint paint = Paint();
//     final Rect shaderRect = Rect.fromLTWH(0, 0, roundedRect.width(), roundedRect.height());

//     paint.shader = gradient.createShader(shaderRect);
//     paint.style = PaintingStyle.stroke;
//     paint.strokeWidth = borderSideWidth;

//     canvas.drawRRect(roundedRect, paint);
//   }
// }
