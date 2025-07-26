class ExerciseAnalysisModel {
  final List<ExerciseAnalysisChart>? chart;
  final ExerciseAnalysisTotals? totals;

  ExerciseAnalysisModel({this.chart, this.totals});

  factory ExerciseAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ExerciseAnalysisModel(
      chart:
          (json['chart'] as List<dynamic>?)
              ?.map((e) => ExerciseAnalysisChart.fromJson(e))
              .toList(),
      totals:
          json['totals'] != null
              ? ExerciseAnalysisTotals.fromJson(json['totals'])
              : null,
    );
  }
}

class ExerciseAnalysisChart {
  final String? date;
  final int? set;
  final double? weightLifted;
  final int? reps;
  final double? totalCaloryBurn;

  ExerciseAnalysisChart({
    this.date,
    this.set,
    this.weightLifted,
    this.reps,
    this.totalCaloryBurn,
  });

  factory ExerciseAnalysisChart.fromJson(Map<String, dynamic> json) {
    return ExerciseAnalysisChart(
      date: json['date'] ?? '',
      set: json['set'] ?? 0,
      weightLifted: (json['weightLifted'] as num?)?.toDouble() ?? 0.0,
      reps: json['reps'] ?? 0,
      totalCaloryBurn: (json['totalCaloryBurn'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ExerciseAnalysisTotals {
  final int? set;
  final num? weightLifted;
  final int? reps;
  final num? totalCaloryBurn;

  ExerciseAnalysisTotals({
    this.set,
    this.weightLifted,
    this.reps,
    this.totalCaloryBurn,
  });

  factory ExerciseAnalysisTotals.fromJson(Map<String, dynamic> json) {
    return ExerciseAnalysisTotals(
      set: json['set'] ?? 0,
      weightLifted: json['weightLifted'] ?? 0,
      reps: json['reps'] ?? 0,
      totalCaloryBurn: json['totalCaloryBurn'] ?? 0,
    );
  }
}
