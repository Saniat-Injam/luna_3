import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout setup/controller/workout_setup_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CalorieScreen extends StatelessWidget {
  const CalorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutSetupController controller = Get.find();

    return Obx(() {
      final value = controller.calories.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            NumberFormat('#,###').format(value.round()), // Format with commas
            style: getTextStyle1(
              fontSize: 96,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              lineHeight: 70,
              height: 1,
            ),
          ),
          Text(
            'calories daily',
            style: getTextStyle1(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              lineHeight: 100,
              height: 0.5,
            ),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              final gaugeWidth = constraints.maxWidth;

              return Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SfLinearGauge(
                  minimum: controller.minCalories,
                  maximum: controller.maxCalories,
                  showLabels: false,
                  showTicks: false,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 10,
                    color: AppColors.textSub,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    borderColor: AppColors.textSub,
                    borderWidth: 2,
                  ),
                  barPointers: [
                    LinearBarPointer(
                      value: value,
                      thickness: 10,
                      color: AppColors.secondary,
                    ),
                  ],
                  markerPointers: [
                    LinearWidgetPointer(
                      value: value,
                      position: LinearElementPosition.cross,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final box = context.findRenderObject() as RenderBox;
                          final dx = box
                              .globalToLocal(details.globalPosition)
                              .dx
                              .clamp(0.0, gaugeWidth);
                          final newValue =
                              controller.minCalories +
                              (dx / gaugeWidth) *
                                  (controller.maxCalories -
                                      controller.minCalories);

                          controller.updateCalories(newValue);
                        },
                        child: Container(
                          height: 40,
                          width: 10,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                            // border: Border.all(color: Colors.white, width: 2),
                          ),
                          // child: Icon(Icons.drag_handle, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
