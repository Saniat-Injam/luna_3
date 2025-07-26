import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:barbell/core/utils/constants/colors.dart';

/// Shimmer effects specifically for nutrition card
/// Provides professional loading animations that match the card design
class HomeShimmerEffects {
  
  /// Creates a shimmer wrapper with nutrition card colors
  static Widget shimmerWrapper({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.08),
      highlightColor: Colors.white.withValues(alpha: 0.25),
      period: const Duration(milliseconds: 1000),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }

  /// Shimmer box with rounded corners matching nutrition card style
  static Widget shimmerBox({
    required double width,
    required double height,
    double borderRadius = 8.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Shimmer circle for progress indicators
  static Widget shimmerCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  /// Shimmer text line with nutrition card styling
  static Widget shimmerText({
    required double width,
    double height = 16.0,
  }) {
    return shimmerBox(
      width: width,
      height: height,
      borderRadius: 4.0,
    );
  }

  /// Shimmer card container matching nutrition card design
  static Widget shimmerCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  /// Shimmer for calories section with orange theme
  static Widget caloriesShimmerCard({required Widget child}) {
    return shimmerCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.textOrange.withValues(alpha: 0.1),
      borderColor: AppColors.textOrange.withValues(alpha: 0.2),
      child: child,
    );
  }

  /// Shimmer for macro cards with specific color themes
  static Widget macroShimmerCard({
    required Widget child,
    required Color color,
  }) {
    return shimmerCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.2),
      child: child,
    );
  }

  /// Shimmer wrapper with custom delay for staggered animations
  static Widget shimmerWrapperWithDelay({
    required Widget child,
    Duration delay = Duration.zero,
  }) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return shimmerWrapper(child: child);
        }
        return Opacity(
          opacity: 0.5,
          child: child,
        );
      },
    );
  }
}
