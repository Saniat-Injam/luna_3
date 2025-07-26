import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

/// Simple and professional pie chart widget for meal distribution
/// Clean design with clear data visualization
class NutritionPieChartWidget extends StatelessWidget {
  const NutritionPieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ProgressController>();
      final chartData = controller.getMealBreakdownData();

      if (chartData.isEmpty || chartData.every((data) => data['value'] == 0)) {
        return _buildEmptyChart();
      }

      return SizedBox(
        height: 280,
        child: Column(
          children: [
            // Simple title
            _buildSimpleTitle(controller),
            const SizedBox(height: 2),

            // Chart area with clean layout
            Expanded(
              child: Row(
                children: [
                  // Simple pie chart
                  Expanded(
                    flex: 4,
                    child: _buildSimplePieChart(chartData, controller),
                  ),

                  // Clean legend
                  Expanded(
                    flex: 4,
                    child: _buildCleanLegend(chartData, controller),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build simple title
  Widget _buildSimpleTitle(ProgressController controller) {
    return Text(
      '${controller.selectedNutrient.value.capitalize} by Meal',
      style: getTextStyleInter(
        color: AppColors.textTitle,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Build simple and clean pie chart
  Widget _buildSimplePieChart(
    List<Map<String, dynamic>> chartData,
    ProgressController controller,
  ) {
    final total = chartData.fold<double>(
      0,
      (sum, data) => sum + (data['value'] as double),
    );

    if (total == 0) return _buildEmptyChart();

    return Container(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: SimplePieChartPainter(data: chartData, total: total),
        ),
      ),
    );
  }

  /// Build clean and simple legend
  Widget _buildCleanLegend(
    List<Map<String, dynamic>> chartData,
    ProgressController controller,
  ) {
    final total = chartData.fold<double>(
      0,
      (sum, data) => sum + (data['value'] as double),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            chartData.map((data) {
              final value = data['value'] as double;
              final percentage = total > 0 ? (value / total * 100) : 0;
              final unit = controller.getNutrientUnit(
                controller.selectedNutrient.value,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Simple color dot
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(data['color'] as int),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Meal info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['meal'] as String,
                            style: getTextStyleInter(
                              color: AppColors.textTitle,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${value.toStringAsFixed(0)} $unit (${percentage.toStringAsFixed(1)}%)',
                            style: getTextStyleInter(
                              color: AppColors.textSub,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Build empty chart state
  Widget _buildEmptyChart() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline, color: AppColors.textSub, size: 48),
          const SizedBox(height: 16),
          Text(
            'No meal data available',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Simple custom painter for drawing a clean pie chart
class SimplePieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  SimplePieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 5;

    double startAngle = -math.pi / 2; // Start from top

    for (final item in data) {
      final value = item['value'] as double;
      if (value == 0) continue;

      final sweepAngle = (value / total) * 2 * math.pi;
      final color = Color(item['color'] as int);

      // Main slice
      final paint =
          Paint()
            ..color = color
            ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // White border between slices
      final borderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
