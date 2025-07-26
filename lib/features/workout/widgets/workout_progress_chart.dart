import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/workout/controller/exercise_analysis_controller.dart';
import 'package:barbell/features/workout/controller/get_workout_by_id_controller.dart';
import 'package:barbell/features/workout/model/analysis_days_model.dart';

class WorkoutProgressChart extends StatefulWidget {
  final ProgressController controller;

  const WorkoutProgressChart({super.key, required this.controller});

  @override
  State<WorkoutProgressChart> createState() => _WorkoutProgressChartState();
}

class _WorkoutProgressChartState extends State<WorkoutProgressChart> {
  final analysisController = Get.find<ExerciseAnalysisController>();
  int selectedIndex = 0; // 0: Sets, 1: lbs, 2: Reps, 3: Calories Burned
  final List<String> tabs = ['Sets', 'Lbs', 'REPS', "Cals"];
  String selectedView = 'WEEKLY VIEW';
  bool isLineChart = false; // false = Bar Chart, true = Line Chart
  final List<String> viewOptions = [
    'WEEKLY VIEW',
    'MONTHLY VIEW',
    'YEARLY VIEW',
  ];

  /// Get the timeSpan parameter for API call based on selected view
  String get timeSpanForView {
    switch (selectedView) {
      case 'WEEKLY VIEW':
        return AnalysisDaysModel.last7Days; // '7_days'
      case 'MONTHLY VIEW':
        return AnalysisDaysModel.last30Days; // '30_days'
      case 'YEARLY VIEW':
        return 'yearly'; // For yearly view
      default:
        return AnalysisDaysModel.last7Days;
    }
  }

  /// Get the current workout ID
  String get workoutId {
    final workoutController = Get.find<GetWorkoutByIdController>();
    return workoutController.workout?.id ?? '';
  }

  /// Fetch data for the selected view
  Future<void> _fetchDataForView() async {
    if (workoutId.isNotEmpty) {
      await analysisController.fetchExerciseAnalysis(
        exerciseId: workoutId,
        timeSpan: timeSpanForView,
      );
    }
  }

  List<Map<String, dynamic>>? get chartData {
    final chart = analysisController.analysisData.chart;
    if (chart == null || chart.isEmpty) {
      return [];
    }

    if (selectedView == 'WEEKLY VIEW') {
      return chart.map((e) {
        // Convert date string to day name
        String dayName = _getDayNameFromDate(e.date ?? '');

        switch (selectedIndex) {
          case 0: // Sets
            return {'day': dayName, 'value': (e.set ?? 0).toDouble()};
          case 1: // Weight (lbs)
            return {'day': dayName, 'value': e.weightLifted ?? 0.0};
          case 2: // Reps
            return {'day': dayName, 'value': (e.reps ?? 0).toDouble()};
          case 3: // Calories Burned
            return {'day': dayName, 'value': e.totalCaloryBurn ?? 0.0};
          default:
            return {'day': dayName, 'value': 0.0};
        }
      }).toList();
    } else if (selectedView == 'MONTHLY VIEW') {
      return chart.map((e) {
        // Convert date string to day number for monthly view
        String dayNumber = _getDayNumberFromDate(e.date ?? '');

        switch (selectedIndex) {
          case 0: // Sets
            return {'day': dayNumber, 'value': (e.set ?? 0).toDouble()};
          case 1: // Weight (lbs)
            return {'day': dayNumber, 'value': e.weightLifted ?? 0.0};
          case 2: // Reps
            return {'day': dayNumber, 'value': (e.reps ?? 0).toDouble()};
          case 3: // Calories Burned
            return {'day': dayNumber, 'value': e.totalCaloryBurn ?? 0.0};
          default:
            return {'day': dayNumber, 'value': 0.0};
        }
      }).toList();
    } else {
      // YEARLY VIEW - Format as months
      return chart.map((e) {
        // Convert date string to month abbreviation for yearly view
        String monthName = _getMonthNameFromDate(e.date ?? '');

        switch (selectedIndex) {
          case 0: // Sets
            return {'day': monthName, 'value': (e.set ?? 0).toDouble()};
          case 1: // Weight (lbs)
            return {'day': monthName, 'value': e.weightLifted ?? 0.0};
          case 2: // Reps
            return {'day': monthName, 'value': (e.reps ?? 0).toDouble()};
          case 3: // Calories Burned
            return {'day': monthName, 'value': e.totalCaloryBurn ?? 0.0};
          default:
            return {'day': monthName, 'value': 0.0};
        }
      }).toList();
    }
  }

  double? get maxValue {
    if (chartData == null || chartData!.isEmpty) return 10;

    final maxVal =
        chartData
            ?.map((e) => e['value'] as num)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() ??
        0;

    // Ensure minimum height for better visualization
    return maxVal > 0 ? maxVal : 10;
  }

  String get chartTitle {
    switch (selectedIndex) {
      case 0:
        return 'Sets';
      case 1:
        return 'KG';
      case 2:
        return 'REPS';
      case 3:
        return 'Calories Burned';
      default:
        return 'Sets';
    }
  }

  /// Helper method to convert date string to day name
  String _getDayNameFromDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';

      final date = DateTime.parse(dateString);
      final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      return dayNames[date.weekday - 1];
    } catch (e) {
      return 'N/A';
    }
  }

  /// Helper method to convert date string to day number for monthly view
  String _getDayNumberFromDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';

      final date = DateTime.parse(dateString);
      return date.day.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  /// Helper method to convert date string to month abbreviation for yearly view
  String _getMonthNameFromDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';

      // Handle yearly format "YYYY-MM" (e.g., "2024-08")
      if (dateString.length == 7 && dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 2) {
          final monthNumber = int.tryParse(parts[1]);
          if (monthNumber != null && monthNumber >= 1 && monthNumber <= 12) {
            final monthNames = [
              'JAN',
              'FEB',
              'MAR',
              'APR',
              'MAY',
              'JUN',
              'JUL',
              'AUG',
              'SEP',
              'OCT',
              'NOV',
              'DEC',
            ];
            return monthNames[monthNumber - 1];
          }
        }
      }

      // Fallback to regular date parsing for full date formats
      final date = DateTime.parse(dateString);
      final monthNames = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC',
      ];
      return monthNames[date.month - 1];
    } catch (e) {
      return 'N/A';
    }
  }

  /// Get formatted value with unit for display
  String getFormattedValue(double value) {
    switch (selectedIndex) {
      case 0: // Sets
        return value.toInt().toString();
      case 1: // KG
        return value == 0 ? '0 kg' : '${value.toStringAsFixed(1)} kg';
      case 2: // Reps
        return value.toInt().toString();
      case 3: // Calories
        return value == 0 ? '0 cal' : '${value.toStringAsFixed(1)} cal';
      default:
        return value.toString();
    }
  }

  /// Get chart color based on selected metric
  Color getChartColor() {
    switch (selectedIndex) {
      case 0: // Sets
        return const Color.fromARGB(255, 49, 95, 234);
      case 1: // KG
        return const Color(0xFF4CAF50); // Green for weight
      case 2: // Reps
        return const Color.fromARGB(255, 89, 19, 242); // Blue for reps
      case 3: // Calories
        return const Color.fromARGB(255, 129, 21, 231); // Orange for calories
      default:
        return AppColors.primary;
    }
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExerciseAnalysisController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(
            left: 16,
            right: 12,
            top: 20,
            bottom: 4,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xff2A2F37), const Color(0xff1F242A)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              /// Chart Title and View Selector
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    chartTitle,
                    style: getTextStyleWorkSans(
                      color: AppColors.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              /// Chart Type Selector and View Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  /// Chart Type Selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xff1A1F25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isLineChart = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  !isLineChart
                                      ? const Color.fromARGB(255, 11, 223, 145)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bar_chart,
                              size: 16,
                              color:
                                  !isLineChart
                                      ? Colors.white
                                      : const Color(0xffA2A6AB),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isLineChart = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isLineChart
                                      ? const Color.fromARGB(255, 14, 232, 18)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.timeline,
                              size: 16,
                              color:
                                  isLineChart
                                      ? Colors.white
                                      : const Color(0xffA2A6AB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// View Selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xff1A1F25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.zero,
                      isDense: true,
                      value: selectedView,
                      dropdownColor: const Color(0xff1A1F25),
                      style: getTextStyleWorkSans(
                        color: const Color(0xffA2A6AB),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xffA2A6AB),
                        size: 16,
                      ),
                      items:
                          viewOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.split(' ')[0]),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedView = newValue;
                          });
                          // Fetch new data for the selected view
                          _fetchDataForView();
                        }
                      },
                    ),
                  ),
                ],
              ),

              /// Chart Container
              SizedBox(
                height: 200,
                child:
                    (chartData == null || chartData!.isEmpty)
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart_outlined,
                                size: 48,
                                color: const Color(
                                  0xffA2A6AB,
                                ).withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No data available',
                                style: getTextStyleWorkSans(
                                  color: const Color(0xffA2A6AB),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Start tracking your workouts',
                                style: getTextStyleWorkSans(
                                  color: const Color(
                                    0xffA2A6AB,
                                  ).withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                        : isLineChart
                        ? _buildLineChart()
                        : _buildBarChart(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xff1A1F25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(tabs.length, (i) {
                    final isSelected = selectedIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? getChartColor()
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: getChartColor().withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Text(
                            tabs[i],
                            textAlign: TextAlign.center,
                            style: getTextStyleWorkSans(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xffA2A6AB),
                              fontSize: 13,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build modern bar chart
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxValue ?? 10) * 1.2,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => const Color(0xff1A1F25),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String unit = '';
              switch (selectedIndex) {
                case 1:
                  unit = ' kg';
                  break;
                case 2:
                  unit = ' reps';
                  break;
                case 3:
                  unit = ' cal';
                  break;
                default:
                  unit = '';
              }
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(rod.toY % 1 == 0 ? 0 : 1)}$unit',
                getTextStyleWorkSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx < 0 || idx >= chartData!.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    chartData?[idx]['day'] ?? '',
                    style: getTextStyleWorkSans(
                      color: const Color(0xffA2A6AB),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: (maxValue ?? 10) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff434B53).withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(chartData!.length, (i) {
          final value = chartData?[i]['value'] as num;
          final actualValue = value.toDouble();

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY:
                    actualValue > 0
                        ? actualValue
                        : 0.1, // Show minimum bar for zero values
                color:
                    actualValue > 0
                        ? getChartColor()
                        : getChartColor().withValues(alpha: 0.3),
                width: 24,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors:
                      actualValue > 0
                          ? [
                            getChartColor(),
                            getChartColor().withValues(alpha: 0.8),
                          ]
                          : [
                            getChartColor().withValues(alpha: 0.2),
                            getChartColor().withValues(alpha: 0.1),
                          ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Build modern line chart
  Widget _buildLineChart() {
    final spots =
        chartData!.asMap().entries.map((entry) {
          final value = entry.value['value'] as num;
          return FlSpot(entry.key.toDouble(), value.toDouble());
        }).toList();

    return LineChart(
      LineChartData(
        maxY: (maxValue ?? 10) * 1.2,
        minY: 0,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => const Color(0xff1A1F25),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String unit = '';
                switch (selectedIndex) {
                  case 1:
                    unit = ' kg';
                    break;
                  case 2:
                    unit = ' reps';
                    break;
                  case 3:
                    unit = ' cal';
                    break;
                  default:
                    unit = '';
                }
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(spot.y % 1 == 0 ? 0 : 1)}$unit',
                  getTextStyleWorkSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx < 0 || idx >= chartData!.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    chartData?[idx]['day'] ?? '',
                    style: getTextStyleWorkSans(
                      color: const Color(0xffA2A6AB),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: (maxValue ?? 10) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff434B53).withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: getChartColor(),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: getChartColor(),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  getChartColor().withValues(alpha: 0.3),
                  getChartColor().withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
