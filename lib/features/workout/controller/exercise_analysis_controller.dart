import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/workout/model/exercise_analysis_model.dart';

class ExerciseAnalysisController extends GetxController {
  bool isLoading = false;
  ExerciseAnalysisModel analysisData = ExerciseAnalysisModel();
  var errorMessage = ''.obs;

  // Tab selection state: 0 = Today, 1 = Total
  int selectedStatsTab = 0;

  Future<bool> fetchExerciseAnalysis({
    required String exerciseId,
    String timeSpan = '7_days',
  }) async {
    isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.runAnalysis(timeSpan, exerciseId),
    );
    if (response.isSuccess) {
      analysisData = ExerciseAnalysisModel.fromJson(
        response.responseData['data'],
      );
      isSuccess = true;
    } else {
      errorMessage.value = response.errorMessage ?? 'Failed to fetch analysis';
    }
    isLoading = false;
    update();
    return isSuccess;
  }

  /// Switch between Today and Total stats
  void switchStatsTab(int index) {
    selectedStatsTab = index;
    update();
  }

  /// Get today's stats from chart data
  Map<String, dynamic> getTodayStats() {
    final chart = analysisData.chart;
    if (chart == null || chart.isEmpty) {
      return {
        'sets': 0,
        'weight': 0.0,
        'reps': 0,
        'calories': 0.0,
      };
    }

    // Find today's data by comparing dates
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    
    final todayEntry = chart.firstWhere(
      (entry) => entry.date?.startsWith(todayString) ?? false,
      orElse: () => chart.last, // Fallback to last entry if today not found
    );

    return {
      'sets': todayEntry.set ?? 0,
      'weight': todayEntry.weightLifted ?? 0.0,
      'reps': todayEntry.reps ?? 0,
      'calories': todayEntry.totalCaloryBurn ?? 0.0,
    };
  }

  /// Get total stats from totals data
  Map<String, dynamic> getTotalStats() {
    final totals = analysisData.totals;
    if (totals == null) {
      return {
        'sets': 0,
        'weight': 0.0,
        'reps': 0,
        'calories': 0.0,
      };
    }

    return {
      'sets': totals.set ?? 0,
      'weight': totals.weightLifted?.toDouble() ?? 0.0,
      'reps': totals.reps ?? 0,
      'calories': totals.totalCaloryBurn?.toDouble() ?? 0.0,
    };
  }

  /// Get current stats based on selected tab
  Map<String, dynamic> getCurrentStats() {
    return selectedStatsTab == 0 ? getTodayStats() : getTotalStats();
  }
}
