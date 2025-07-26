import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeightSlider extends StatelessWidget {
  const WeightSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutSetupController>();

    return Column(
      children: [
        Obx(() {
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: controller.displayedWeight.toInt().toString(),
                  style: getTextStyle1(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
                TextSpan(
                  text: controller.isKgSelected.value ? ' KG' : ' LB',
                  style: getTextStyle1(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final gaugeWidth = constraints.maxWidth;

            return Stack(
              children: [
                SizedBox(
                  width: gaugeWidth,
                  height: 100,
                  child: Obx(() {
                    final isKg = controller.isKgSelected.value;
                    return SfLinearGauge(
                      minimum: isKg ? 30 : 66,
                      maximum: isKg ? 150 : 330,
                      interval: isKg ? 15 : 33,
                      orientation: LinearGaugeOrientation.horizontal,
                      tickPosition: LinearElementPosition.cross,
                      axisTrackStyle: const LinearAxisTrackStyle(
                        color: Colors.transparent,
                      ),
                      markerPointers: [
                        LinearWidgetPointer(
                          value:
                              isKg
                                  ? controller.weightInKg.value
                                  : controller.weightInLbs,
                          position: LinearElementPosition.cross,
                          child: Image.asset(
                            IconPath.pointindicator,
                            height: 120,
                            width: 50,
                          ),
                        ),
                      ],
                      majorTickStyle: const LinearTickStyle(
                        length: 35,
                        thickness: 3,
                        color: AppColors.textweight,
                      ),
                      minorTicksPerInterval: 4,
                      minorTickStyle: const LinearTickStyle(
                        length: 17,
                        thickness: 1,
                        color: AppColors.textweight,
                      ),
                      axisLabelStyle: getTextStyle1(
                        color: AppColors.textweight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      double localDx = details.localPosition.dx;
                      double percent = localDx / gaugeWidth;

                      if (controller.isKgSelected.value) {
                        double weight = 30 + (120 * percent); // 30–150 KG
                        controller.updateWeight(weight);
                      } else {
                        double weightLb = 66 + (264 * percent); // 66–330 LB
                        controller.updateWeight(weightLb);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
