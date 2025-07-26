import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class WeeklyProgressChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const WeeklyProgressChart({super.key, required this.data});

  @override
  State<WeeklyProgressChart> createState() => _WeeklyProgressChartState();
}

class _WeeklyProgressChartState extends State<WeeklyProgressChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  String? selectedDay;
  double? selectedValue;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ), // Increased duration for smoother animation
    );

    // Create individual animations for each bar with smoother curve
    _animations = List.generate(
      widget.data.length,
      (index) => Tween<double>(
        begin: 0.0,
        end: widget.data[index]['value'] as double,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0), // Increased interval spacing
            ((index + 1) * 0.15).clamp(0.0, 1.0),
            curve: Curves.linear, // Changed to easeInOut for smoother animation
          ),
        ),
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _showOverlay(
    BuildContext context,
    String day,
    double value,
    Offset position,
  ) {
    _hideOverlay();

    // Calculate calories (assuming value is percentage, adjust calculation as needed)
    final int calories = (value * 2500).round(); // Example calculation

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: position.dy - 60, // Position above the bar
            left: position.dx,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
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
                      day,
                      style: getTextStyleWorkSans(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$calories cal',
                      style: getTextStyleWorkSans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          children: List.generate(
            widget.data.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // Day label
                  SizedBox(
                    width: 40,
                    child: Text(
                      widget.data[index]['day'] as String,
                      style: getTextStyleWorkSans(
                        color: const Color(0xffA2A6AB),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        lineHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Animated Progress bar with tap detection
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (details) {
                        final day = widget.data[index]['day'] as String;
                        final value = widget.data[index]['value'] as double;
                        _showOverlay(
                          context,
                          day,
                          value,
                          details.globalPosition,
                        );
                      },
                      onTapUp: (_) => _hideOverlay(),
                      onTapCancel: _hideOverlay,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xff434B53),
                            border: Border.all(
                              color: AppColors.border,
                              width: .52,
                            ),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: (_animations[index].value * 100).toInt(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex:
                                    (100 - (_animations[index].value * 100))
                                        .toInt(),
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
