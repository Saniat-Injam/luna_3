import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContinueButtonController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController hintAnimationController;
  late Animation<double> iconOffset;
  late Animation<double> arrowOpacity;
  late Animation<double> arrowOffset;
  late Animation<double> hintAnimation;

  var isSlid = false.obs;
  var isFinished = false.obs;
  var isProcessing =
      false.obs; // Add processing state to prevent multiple triggers

  double width = 352;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Faster animation
    );

    hintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(); // Make the animation repeat continuously

    hintAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: hintAnimationController, curve: Curves.easeInOut),
    );

    iconOffset = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    arrowOffset = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    arrowOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void handleDragUpdate(DragUpdateDetails details, VoidCallback? onPressed) {
    if (isSlid.value || isProcessing.value) return;

    double progress = details.localPosition.dx / width;
    if (progress > 0.8) {
      // Reduced threshold for easier sliding
      isSlid.value = true;
      isProcessing.value = true;
      animationController.forward().whenComplete(() {
        // Defer callback to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (onPressed != null) onPressed();
          isProcessing.value = false;
        });
      });
    }
  }

  void handleDragEnd() {
    if (!isSlid.value) {
      animationController.reverse();
    }
  }

  void finishExternalSwipe(VoidCallback? onPressed) {
    if (isProcessing.value) return; // Prevent multiple triggers

    isProcessing.value = true;
    // Defer both navigation and state update to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onPressed != null) {
        onPressed();
      }
      isFinished.value = false;
      isProcessing.value = false;
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    hintAnimationController.dispose();
    super.onClose();
  }
}
