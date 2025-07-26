import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

/// Interactive bar chart widget for displaying nutrition data
/// Shows daily values as vertical bars with tap-to-view functionality
/// Handles large datasets with smart sampling and professional labeling
class NutritionBarChartWidget extends StatefulWidget {
  const NutritionBarChartWidget({super.key});

  @override
  State<NutritionBarChartWidget> createState() =>
      _NutritionBarChartWidgetState();
}

class _NutritionBarChartWidgetState extends State<NutritionBarChartWidget> {
  /// Index of the currently selected bar (-1 means no selection)
  int selectedBarIndex = -1;

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

            // Interactive bar chart area
            Expanded(child: _buildInteractiveBarChart(chartData, controller)),

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
    // For large datasets, sample data intelligently like line chart
    if (rawData.length > 14) {
      return _sampleDataForDisplay(rawData, controller.selectedTimeRange.value);
    }

    return rawData;
  }

  /// Sample data intelligently based on time range (matching line chart logic)
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

    // Create smart labels to avoid overlap (show every 4th day for bars)
    final result = <Map<String, dynamic>>[];
    for (int i = 0; i < last30Days.length; i++) {
      final item = last30Days[i];

      // Show label every 4th day to avoid overlap, plus first and last
      final showLabel = i % 4 == 0 || i == last30Days.length - 1;

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
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary,
                AppColors.secondary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${controller.selectedNutrient.value.capitalize} (${controller.getNutrientUnit(controller.selectedNutrient.value)})',
          style: getTextStyleInter(
            color: AppColors.textTitle,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build the interactive bar chart with tap-to-view functionality
  Widget _buildInteractiveBarChart(
    List<Map<String, dynamic>> chartData,
    ProgressController controller,
  ) {
    if (chartData.isEmpty) return _buildEmptyChart();

    final maxValue = chartData
        .map((e) => e['value'] as double)
        .reduce((a, b) => a > b ? a : b);

    if (maxValue == 0) return _buildEmptyChart();

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
              painter: InteractiveBarChartPainter(
                data: chartData,
                maxValue: maxValue,
                selectedBarIndex: selectedBarIndex,
                barColor: AppColors.secondary,
                gridColor: AppColors.border,
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

  /// Handle tap down events to detect bar selection
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

    // Make clicking much easier - find the closest bar by X position
    final double barSpacing = chartWidth / chartData.length;
    int selectedIndex = (tapX / barSpacing).floor();

    // Ensure the index is within bounds
    if (selectedIndex < 0) selectedIndex = 0;
    if (selectedIndex >= chartData.length) selectedIndex = chartData.length - 1;

    setState(() {
      selectedBarIndex = selectedIndex;
    });

    // Auto-deselect after 6 seconds (longer for better UX)
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && selectedBarIndex == selectedIndex) {
        setState(() {
          selectedBarIndex = -1;
        });
      }
    });
  }

  /// Build X-axis labels with smart spacing to prevent overlap
  Widget _buildXAxisLabels(List<Map<String, dynamic>> chartData) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            chartData.map((data) {
              final dayText = data['day'] ?? '';
              return Text(
                dayText,
                style: getTextStyleInter(
                  color: AppColors.textSub,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, color: AppColors.textSub, size: 48),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: getTextStyleInter(
              color: AppColors.textTitle,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging meals to see your nutrition data',
            style: getTextStyleInter(color: AppColors.textSub, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing the interactive bar chart
class InteractiveBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final int selectedBarIndex;
  final Color barColor;
  final Color gridColor;
  final String nutrientUnit;

  InteractiveBarChartPainter({
    required this.data,
    required this.maxValue,
    required this.selectedBarIndex,
    required this.barColor,
    required this.gridColor,
    required this.nutrientUnit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxValue == 0) return;

    // Draw grid lines
    _drawGrid(canvas, size);

    // Calculate bar dimensions
    final double barSpacing = size.width / data.length;
    final double barWidth = barSpacing * 0.7; // 70% of spacing for bar width
    final double barMargin = barSpacing * 0.15; // 15% margin on each side

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final value = data[i]['value'] as double;
      final isSelected = i == selectedBarIndex;

      // Calculate bar dimensions
      final double barLeft = (i * barSpacing) + barMargin;
      final double barHeight = (value / maxValue) * size.height;
      final double barTop = size.height - barHeight;

      // Draw bar
      _drawBar(canvas, barLeft, barTop, barWidth, barHeight, isSelected);

      // Draw tooltip for selected bar
      if (isSelected) {
        _drawTooltip(canvas, barLeft + (barWidth / 2), barTop, data[i], size);
      }
    }
  }

  /// Draw grid lines
  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..color = gridColor.withValues(alpha: 0.3)
          ..strokeWidth = 0.5;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (i * size.height) / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  /// Draw individual bar
  void _drawBar(
    Canvas canvas,
    double left,
    double top,
    double width,
    double height,
    bool isSelected,
  ) {
    final barPaint = Paint()..style = PaintingStyle.fill;

    if (isSelected) {
      // Draw glow effect for selected bar
      final glowPaint =
          Paint()
            ..color = barColor.withValues(alpha: 0.3)
            ..style = PaintingStyle.fill;

      final glowRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left - 4, top - 4, width + 8, height + 8),
        const Radius.circular(8),
      );
      canvas.drawRRect(glowRect, glowPaint);

      // Selected bar with brighter color
      barPaint.color = barColor;
    } else {
      // Regular bar
      barPaint.color = barColor.withValues(alpha: 0.8);
    }

    // Draw the bar
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      const Radius.circular(4),
    );
    canvas.drawRRect(barRect, barPaint);

    // Draw top highlight
    final highlightPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, 8),
      const Radius.circular(4),
    );
    canvas.drawRRect(highlightRect, highlightPaint);
  }

  /// Draw tooltip for selected bar
  void _drawTooltip(
    Canvas canvas,
    double barCenterX,
    double barTop,
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
    double tooltipX = barCenterX - (textPainter.width / 2);
    double tooltipY = barTop - textPainter.height - 20;

    // Keep tooltip within bounds
    if (tooltipX < 8) tooltipX = 8;
    if (tooltipX + textPainter.width + 8 > size.width) {
      tooltipX = size.width - textPainter.width - 8;
    }
    if (tooltipY < 8) tooltipY = barTop + 20;

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
          ..color = barColor.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    canvas.drawRRect(tooltipRect, borderPaint);

    // Draw text
    textPainter.paint(canvas, tooltipOffset);

    // Draw arrow pointing to the bar
    _drawTooltipArrow(canvas, barCenterX, tooltipRect, barTop);
  }

  /// Draw arrow from tooltip to bar
  void _drawTooltipArrow(
    Canvas canvas,
    double barCenterX,
    RRect tooltipRect,
    double barTop,
  ) {
    final arrowPaint =
        Paint()
          ..color = AppColors.background.withValues(alpha: 0.95)
          ..style = PaintingStyle.fill;

    final isAbove = tooltipRect.bottom < barTop;

    if (isAbove) {
      // Arrow pointing down to the bar
      final arrowPath = Path();
      arrowPath.moveTo(barCenterX - 6, tooltipRect.bottom);
      arrowPath.lineTo(barCenterX + 6, tooltipRect.bottom);
      arrowPath.lineTo(barCenterX, tooltipRect.bottom + 8);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    } else {
      // Arrow pointing up to the bar
      final arrowPath = Path();
      arrowPath.moveTo(barCenterX - 6, tooltipRect.top);
      arrowPath.lineTo(barCenterX + 6, tooltipRect.top);
      arrowPath.lineTo(barCenterX, tooltipRect.top - 8);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
