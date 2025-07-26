import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MacroGoalSlider extends StatelessWidget {
  final String label;
  final RxDouble valueRx;
  final double? width; // allows Wrap grid
  final double min;
  final double max;
  final Color barColor;
  final Function(double) onChanged;

  const MacroGoalSlider({
    super.key,
    required this.label,
    required this.valueRx,
    required this.min,
    required this.max,
    required this.barColor,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cardWidth = width ?? MediaQuery.of(context).size.width - 32;
      final value = valueRx.value;
      return Container(
        width: cardWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ), // reduced padding
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12), // smaller radius
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              NumberFormat('#,###').format(value.round()),
              style: getTextStyle1(
                fontSize: 24, // smaller font
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$label (g)',
              style: getTextStyle1(
                fontSize: 14, // smaller font
                fontWeight: FontWeight.w500,
                color: Colors.white70, // less prominent color
              ),
            ),
            const SizedBox(height: 16), // reduced space
            LayoutBuilder(
              builder: (context, constraints) {
                final gaugeWidth = constraints.maxWidth;

                void handleInteraction(Offset globalPosition) {
                  final box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(globalPosition);
                  final dx = localPosition.dx.clamp(0.0, gaugeWidth);
                  final newValue = min + (dx / gaugeWidth) * (max - min);
                  onChanged(newValue);
                }

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown:
                      (details) => handleInteraction(details.globalPosition),
                  onHorizontalDragStart:
                      (details) => handleInteraction(details.globalPosition),
                  onHorizontalDragUpdate:
                      (details) => handleInteraction(details.globalPosition),
                  child: AbsorbPointer(
                    child: SizedBox(
                      height: 30, // constrain height
                      child: SfLinearGauge(
                        minimum: min,
                        maximum: max,
                        showLabels: false,
                        showTicks: false,
                        axisTrackStyle: LinearAxisTrackStyle(
                          thickness: 6, // thinner
                          color: AppColors.textSub.withValues(alpha: 0.5),
                          edgeStyle: LinearEdgeStyle.bothCurve,
                        ),
                        barPointers: [
                          LinearBarPointer(
                            value: value,
                            thickness: 6, // thinner
                            color: barColor,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                          ),
                        ],
                        markerPointers: [
                          LinearWidgetPointer(
                            value: value,
                            position: LinearElementPosition.cross,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: barColor, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
