class FoodAnalysisSummaryResponse {
  final List<FoodAnalysisSummary> daily;
  final FoodAnalysisTotal total;

  FoodAnalysisSummaryResponse({required this.daily, required this.total});

  factory FoodAnalysisSummaryResponse.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisSummaryResponse(
      daily:
          (json['daily'] as List<dynamic>)
              .map(
                (e) => FoodAnalysisSummary.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      total: FoodAnalysisTotal.fromJson(json['total'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'daily': daily.map((e) => e.toJson()).toList(),
    'total': total.toJson(),
  };
}

class FoodAnalysisTotal {
  final num totalCalories;
  final num totalProtein;
  final num totalCarbs;
  final num totalFats;
  final num totalFiber;

  FoodAnalysisTotal({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.totalFiber,
  });

  factory FoodAnalysisTotal.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisTotal(
      totalCalories: json['totalCalories'] as num,
      totalProtein: json['totalProtein'] as num,
      totalCarbs: json['totalCarbs'] as num,
      totalFats: json['totalFats'] as num,
      totalFiber: json['totalFiber'] as num,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalCalories': totalCalories,
    'totalProtein': totalProtein,
    'totalCarbs': totalCarbs,
    'totalFats': totalFats,
    'totalFiber': totalFiber,
  };
}

class FoodAnalysisSummary {
  final String date;
  final num totalCalories;
  final num totalProtein;
  final num totalCarbs;
  final num totalFats;
  final num totalFiber;
  final ConsumedMeals consumedMeals;

  FoodAnalysisSummary({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.totalFiber,
    required this.consumedMeals,
  });

  factory FoodAnalysisSummary.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisSummary(
      date: json['date'] as String,
      totalCalories: json['totalCalories'] as num,
      totalProtein: json['totalProtein'] as num,
      totalCarbs: json['totalCarbs'] as num,
      totalFats: json['totalFats'] as num,
      totalFiber: json['totalFiber'] as num,
      consumedMeals: ConsumedMeals.fromJson(
        json['consumedMeals'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'totalCalories': totalCalories,
    'totalProtein': totalProtein,
    'totalCarbs': totalCarbs,
    'totalFats': totalFats,
    'totalFiber': totalFiber,
    'consumedMeals': consumedMeals.toJson(),
  };
}

class ConsumedMeals {
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;
  final Meal snack;

  ConsumedMeals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snack,
  });

  factory ConsumedMeals.fromJson(Map<String, dynamic> json) {
    return ConsumedMeals(
      breakfast: Meal.fromJson(json['breakfast'] as Map<String, dynamic>),
      lunch: Meal.fromJson(json['lunch'] as Map<String, dynamic>),
      dinner: Meal.fromJson(json['dinner'] as Map<String, dynamic>),
      snack: Meal.fromJson(json['snack'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'breakfast': breakfast.toJson(),
    'lunch': lunch.toJson(),
    'dinner': dinner.toJson(),
    'snack': snack.toJson(),
  };
}

class Meal {
  final num totalCalories;
  final num totalProtein;
  final num totalCarbs;
  final num totalFats;
  final num totalFiber;

  Meal({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.totalFiber,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      totalCalories: json['totalCalories'] as num,
      totalProtein: json['totalProtein'] as num,
      totalCarbs: json['totalCarbs'] as num,
      totalFats: json['totalFats'] as num,
      totalFiber: json['totalFiber'] as num,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalCalories': totalCalories,
    'totalProtein': totalProtein,
    'totalCarbs': totalCarbs,
    'totalFats': totalFats,
    'totalFiber': totalFiber,
  };
}
