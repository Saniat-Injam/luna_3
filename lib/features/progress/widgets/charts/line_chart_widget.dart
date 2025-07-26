import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

/// Line chart widget for displaying nutrition trends over time
/// Shows daily values connected by lines for easy trend visualization
/// Supports interactive data point selection to view exact values
class NutritionLineChartWidget extends StatefulWidget {
  const NutritionLineChartWidget({super.key});

  @override
  State<NutritionLineChartWidget> createState() =>
      _NutritionLineChartWidgetState();
}

class _NutritionLineChartWidgetState extends State<NutritionLineChartWidget> {
  /// Index of the currently selected data point (-1 means no selection)
  int selectedPointIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ProgressController>();
      final rawChartData = controller.getChartData();

      if (rawChartData.isEmpty) {
        return _buildEmptyChart();
      }

      // Process data for optimal display
      final chartData = _processChartData(rawChartData, controller);

      return SizedBox(
        height: 250,
        child: Column(
          children: [
            // Chart legend
            _buildLegend(controller),
            const SizedBox(height: 16),

            // Line chart area with interaction
            Expanded(child: _buildInteractiveLineChart(chartData, controller)),

            // X-axis labels
            _buildXAxisLabels(chartData),
          ],
        ),
      );
    });
  }

  /// Process chart data for optimal display based on dataset size
  List<Map<String, dynamic>> _processChartData(
    List<Map<String, dynamic>> rawData,
    ProgressController controller,
  ) {
    // For large datasets, sample data intelligently
    if (rawData.length > 14) {
      return _sampleDataForDisplay(rawData, controller.selectedTimeRange.value);
    }

    return rawData;
  }

  /// Sample data intelligently based on time range
  List<Map<String, dynamic>> _sampleDataForDisplay(
    List<Map<String, dynamic>> data,
    int timeRange,
  ) {
    if (timeRange >= 365) {
      // For yearly view, show 12 monthly averages with smart labeling
      return _createYearlyMonthlyData(data);
    } else if (timeRange >= 30) {
      // For monthly view, show 30 days with smart labeling (show every 3rd day)
      return _createMonthlyDailyData(data);
    } else {
      // For smaller ranges, show all data
      return data;
    }
  }

  /// Create 12 monthly data points for yearly view
  List<Map<String, dynamic>> _createYearlyMonthlyData(
    List<Map<String, dynamic>> data,
  ) {
    final Map<String, List<double>> monthlyData = {};
    final Map<String, String> monthLabels = {};
    final Map<String, String> fullDateMap = {};

    // Group data by month
    for (final item in data) {
      final date = DateTime.tryParse(item['fullDate'] ?? '');
      if (date != null) {
        final monthKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}';
        final monthLabel = _getMonthLabel(date.month);

        monthlyData[monthKey] ??= [];
        monthlyData[monthKey]!.add(item['value'] as double);
        monthLabels[monthKey] = monthLabel;
        fullDateMap[monthKey] = item['fullDate'] ?? '';
      }
    }

    // Sort and get last 12 months
    final sortedEntries =
        monthlyData.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    final recentEntries =
        sortedEntries.length > 12
            ? sortedEntries.sublist(sortedEntries.length - 12)
            : sortedEntries;

    // Create smart labels to avoid overlap (show every 2nd month)
    final result = <Map<String, dynamic>>[];
    for (int i = 0; i < recentEntries.length; i++) {
      final entry = recentEntries[i];
      final values = entry.value;
      final average =
          values.isNotEmpty
              ? values.reduce((a, b) => a + b) / values.length
              : 0.0;

      // Show label every 2nd month to avoid overlap
      final showLabel = i % 2 == 0 || i == recentEntries.length - 1;
      final displayLabel = showLabel ? (monthLabels[entry.key] ?? '') : '';

      result.add({
        'day': displayLabel,
        'value': average,
        'date': entry.key,
        'fullDate': fullDateMap[entry.key] ?? '',
        'fullLabel':
            monthLabels[entry.key] ?? '', // Keep full label for tooltip
        'isAverage': true,
      });
    }

    return result;
  }

  /// Create 30 daily data points for monthly view with smart labeling
  List<Map<String, dynamic>> _createMonthlyDailyData(
    List<Map<String, dynamic>> data,
  ) {
    // Take last 30 days of data
    final last30Days = data.length > 30 ? data.sublist(data.length - 30) : data;

    // Create smart labels to avoid overlap (show every 5th day)
    final result = <Map<String, dynamic>>[];
    for (int i = 0; i < last30Days.length; i++) {
      final item = last30Days[i];

      // Show label every 5th day to avoid overlap, plus first and last
      final showLabel = i % 5 == 0 || i == last30Days.length - 1;

      // Parse date for better labeling
      final date = DateTime.tryParse(item['fullDate'] ?? '');
      final dayLabel =
          date != null ? '${date.day}/${date.month}' : (item['day'] ?? '');

      final displayLabel = showLabel ? dayLabel : '';

      result.add({
        'day': displayLabel,
        'value': item['value'],
        'date': item['date'],
        'fullDate': item['fullDate'] ?? '',
        'fullLabel': dayLabel, // Keep full label for tooltip
        'isAverage': false,
      });
    }

    return result;
  }

  /// Get month label from month number
  String _getMonthLabel(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  /// Build chart legend
  Widget _buildLegend(ProgressController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${controller.selectedNutrient.value.capitalize} (${controller.getNutrientUnit(controller.selectedNutrient.value)})',
          style: getTextStyleInter(
            color: AppColors.textSub,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build the interactive line chart with tap-to-view functionality
  Widget _buildInteractiveLineChart(
    List<Map<String, dynamic>> chartData,
    ProgressController controller,
  ) {
    final maxValue = chartData
        .map((e) => e['value'] as double)
        .reduce((a, b) => a > b ? a : b);
    final minValue = chartData
        .map((e) => e['value'] as double)
        .reduce((a, b) => a < b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown:
                (details) =>
                    _handleTapDown(details, chartData, constraints.biggest),
            child: CustomPaint(
              size: Size.infinite,
              painter: InteractiveLineChartPainter(
                data: chartData,
                maxValue: maxValue,
                minValue: minValue,
                lineColor: AppColors.secondary,
                gridColor: AppColors.border,
                pointColor: AppColors.secondary,
                selectedPointIndex: selectedPointIndex,
                nutrientUnit: controller.getNutrientUnit(
                  controller.selectedNutrient.value,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Handle tap down events to detect data point selection
  void _handleTapDown(
    TapDownDetails details,
    List<Map<String, dynamic>> chartData,
    Size containerSize,
  ) {
    if (chartData.isEmpty) return;

    // Account for container padding
    final double chartWidth =
        containerSize.width - 32; // 16 padding on each side
    final double chartHeight =
        containerSize.height - 32; // 16 padding on each side

    // Adjust tap position for padding
    final double tapX = details.localPosition.dx - 16;
    final double tapY = details.localPosition.dy - 16;

    // Ensure tap is within chart bounds
    if (tapX < 0 || tapX > chartWidth || tapY < 0 || tapY > chartHeight) {
      return;
    }

    // Make clicking much easier - find the closest point by X position only
    double closestXDistance = double.infinity;
    int closestIndex = -1;

    for (int i = 0; i < chartData.length; i++) {
      // Calculate point position
      final double pointX =
          chartData.length > 1
              ? (i * chartWidth) / (chartData.length - 1)
              : chartWidth / 2;

      // Only consider X distance for much easier clicking
      final double xDistance = (tapX - pointX).abs();

      if (xDistance < closestXDistance) {
        closestXDistance = xDistance;
        closestIndex = i;
      }
    }

    // Always select the closest point (no tolerance limit)
    setState(() {
      selectedPointIndex = closestIndex;
    });

    // Auto-deselect after 6 seconds (longer for better UX)
    if (closestIndex != -1) {
      Future.delayed(const Duration(seconds: 6), () {
        if (mounted && selectedPointIndex == closestIndex) {
          setState(() {
            selectedPointIndex = -1;
          });
        }
      });
    }
  }

  /// Build X-axis labels (days)
  /// Build X-axis labels with smart spacing
  Widget _buildXAxisLabels(List<Map<String, dynamic>> chartData) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            chartData.map((data) {
              final dayText = data['day'] ?? '';
              final isAverage = data['isAverage'] == true;

              return Text(
                dayText,
                style: getTextStyleInter(
                  color: isAverage ? AppColors.textSub : AppColors.textSub,
                  fontSize: 10,
                  fontWeight: isAverage ? FontWeight.w600 : FontWeight.w500,
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Build empty chart state
  Widget _buildEmptyChart() {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Text(
        'No data available for line chart',
        style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
      ),
    );
  }
}

/// Custom painter for drawing the interactive line chart
class InteractiveLineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final double minValue;
  final Color lineColor;
  final Color gridColor;
  final Color pointColor;
  final int selectedPointIndex;
  final String nutrientUnit;

  InteractiveLineChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.lineColor,
    required this.gridColor,
    required this.pointColor,
    required this.selectedPointIndex,
    required this.nutrientUnit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final pointPaint =
        Paint()
          ..color = pointColor
          ..style = PaintingStyle.fill;

    final gridPaint =
        Paint()
          ..color = gridColor.withValues(alpha: 0.3)
          ..strokeWidth = 0.5;

    // Draw grid lines
    _drawGrid(canvas, size, gridPaint);

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final value = data[i]['value'] as double;
      final x = (i * size.width) / (data.length - 1);
      final normalizedValue =
          maxValue > minValue
              ? (value - minValue) / (maxValue - minValue)
              : 0.5;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    // Draw regular points
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final isSelected = i == selectedPointIndex;

      if (isSelected) {
        // Draw larger selected point with glow effect
        final glowPaint =
            Paint()
              ..color = pointColor.withValues(alpha: 0.3)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(point, 12, glowPaint);

        // Draw selected point
        canvas.drawCircle(point, 6, pointPaint);
        canvas.drawCircle(point, 3, Paint()..color = Colors.white);

        // Draw tooltip for selected point
        _drawTooltip(canvas, point, data[i], size);
      } else {
        // Draw regular point
        canvas.drawCircle(point, 4, pointPaint);
        canvas.drawCircle(point, 2, Paint()..color = Colors.white);
      }
    }
  }

  /// Draw grid lines
  void _drawGrid(Canvas canvas, Size size, Paint gridPaint) {
    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (i * size.height) / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = (i * size.width) / (data.length - 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  /// Draw tooltip for selected data point
  void _drawTooltip(
    Canvas canvas,
    Offset point,
    Map<String, dynamic> dataPoint,
    Size size,
  ) {
    final value = dataPoint['value'] as double;
    // Use fullLabel if available, otherwise use day
    final day = dataPoint['fullLabel'] ?? dataPoint['day'] ?? '';

    // Format the tooltip text
    final valueText = value.toStringAsFixed(1);
    final tooltipText = '$day\n$valueText $nutrientUnit';

    final textPainter = TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // Calculate tooltip position
    double tooltipX = point.dx - (textPainter.width / 2);
    double tooltipY = point.dy - textPainter.height - 20;

    // Keep tooltip within bounds
    if (tooltipX < 8) tooltipX = 8;
    if (tooltipX + textPainter.width + 8 > size.width) {
      tooltipX = size.width - textPainter.width - 8;
    }
    if (tooltipY < 8) tooltipY = point.dy + 20;

    final tooltipOffset = Offset(tooltipX, tooltipY);

    // Draw tooltip background
    final tooltipBg =
        Paint()
          ..color = AppColors.background.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        tooltipOffset.dx - 8,
        tooltipOffset.dy - 4,
        textPainter.width + 16,
        textPainter.height + 8,
      ),
      const Radius.circular(8),
    );

    // Draw shadow
    canvas.drawRRect(tooltipRect.shift(const Offset(0, 2)), shadowPaint);

    // Draw background
    canvas.drawRRect(tooltipRect, tooltipBg);

    // Draw border
    final borderPaint =
        Paint()
          ..color = AppColors.secondary.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    canvas.drawRRect(tooltipRect, borderPaint);

    // Draw text
    textPainter.paint(canvas, tooltipOffset);

    // Draw arrow pointing to the data point
    _drawTooltipArrow(canvas, point, tooltipRect);
  }

  /// Draw arrow from tooltip to data point
  void _drawTooltipArrow(Canvas canvas, Offset point, RRect tooltipRect) {
    final arrowPaint =
        Paint()
          ..color = AppColors.background.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill;

    final tooltipCenter = tooltipRect.center;
    final isAbove = tooltipRect.bottom < point.dy;

    if (isAbove) {
      // Arrow pointing down to the point
      final arrowPath = Path();
      arrowPath.moveTo(tooltipCenter.dx - 6, tooltipRect.bottom);
      arrowPath.lineTo(tooltipCenter.dx + 6, tooltipRect.bottom);
      arrowPath.lineTo(tooltipCenter.dx, tooltipRect.bottom + 8);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    } else {
      // Arrow pointing up to the point
      final arrowPath = Path();
      arrowPath.moveTo(tooltipCenter.dx - 6, tooltipRect.top);
      arrowPath.lineTo(tooltipCenter.dx + 6, tooltipRect.top);
      arrowPath.lineTo(tooltipCenter.dx, tooltipRect.top - 8);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
