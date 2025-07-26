import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/onbording_screen/controller/continue_button_controller.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool showLeftIcon;
  final bool showRightArrow;
  final bool enableSwipe;
  final bool useExternalSwipe;
  final double? width; // No default here, handled in build()
  final double? height;

  ContinueButton({
    super.key,
    required this.onPressed,
    this.buttonText,
    this.showLeftIcon = false,
    this.showRightArrow = false,
    this.enableSwipe = false,
    this.useExternalSwipe = false,
    this.width,
    this.height,
  });

  final controller = Get.put(ContinueButtonController());

  Widget _buildInternalSwipe(double calculatedWidth, double calculatedHeight) {
    controller.width = calculatedWidth;

    return GestureDetector(
      onHorizontalDragUpdate:
          enableSwipe
              ? (details) => controller.handleDragUpdate(details, onPressed)
              : null,
      onHorizontalDragEnd:
          enableSwipe ? (_) => controller.handleDragEnd() : null,
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, child) {
          return Container(
            width: calculatedWidth,
            height: calculatedHeight,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(29),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showLeftIcon)
                  Transform.translate(
                    offset: Offset(controller.iconOffset.value, 0),
                    child: Opacity(
                      opacity:
                          showLeftIcon && controller.iconOffset.value < -10
                              ? 0
                              : 1,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      buttonText ?? 'Next',
                      style: GoogleFonts.workSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  ),
                ),
                if (showRightArrow)
                  Transform.translate(
                    offset: Offset(controller.arrowOffset.value, 0),
                    child: Opacity(
                      opacity: controller.arrowOpacity.value,
                      child: Image.asset(
                        'assets/icons/right_arrow.png',
                        width: 34,
                        height: 34,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExternalSwipe(double calculatedWidth, double calculatedHeight) {
    return SizedBox(
      width: calculatedWidth,
      height: calculatedHeight,
      child: Obx(
        () => SwipeableButtonView(
          buttontextstyle: AppTextStyle.f16W600().copyWith(
            color: Color(0xFF1C2227),
          ),
          buttonText: "SLIDE TO CONTINUE",
          buttonWidget: AnimatedBuilder(
            animation: controller.hintAnimationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(controller.hintAnimation.value, 0),
                child: SvgPicture.asset(
                  'assets/svg/right_arrow.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              );
            },
          ),
          activeColor: AppColors.secondary, // Using project's theme color
          buttonColor: Color(0xFF1C2227), // Using project's theme color
          isFinished: controller.isFinished.value,
          onWaitingProcess: () {
            Future.delayed(const Duration(milliseconds: 10), () {
              controller.isFinished.value = true;
            });
          },
          onFinish: () => controller.finishExternalSwipe(onPressed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    // Default values as a percentage of screen size
    final double defaultWidth = mediaSize.width / 1.1; // 90% of screen width
    final double defaultHeight = mediaSize.height / 14; // ~7% of screen height

    final double calculatedWidth = width ?? defaultWidth;
    final double calculatedHeight = height ?? defaultHeight;

    return InkWell(
      onTap: () {
        if (!enableSwipe && !useExternalSwipe && onPressed != null) {
          onPressed!();
        }
      },
      borderRadius: BorderRadius.circular(29),
      child:
          useExternalSwipe
              ? _buildExternalSwipe(calculatedWidth, calculatedHeight)
              : _buildInternalSwipe(calculatedWidth, calculatedHeight),
    );
  }
}
