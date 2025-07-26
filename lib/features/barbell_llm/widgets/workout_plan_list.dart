import 'package:flutter/material.dart';
import 'package:barbell/core/models/UserModel.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';
import 'package:barbell/features/barbell_llm/widgets/day_card.dart';

/// Workout plan list widget that displays the weekly schedule
class WorkoutPlanList extends StatelessWidget {
  final WorkoutPlan workoutPlan;
  final BarbellLLMController controller;

  const WorkoutPlanList({
    super.key,
    required this.workoutPlan,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Create a complete week with rest days
    final List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final Map<String, WorkoutDay> workoutMap = {
      for (var day in workoutPlan.plan) day.day: day,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Week overview header

          // Days list
          Expanded(
            child: ListView.builder(
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                final dayName = weekDays[index];
                final workoutDay = workoutMap[dayName];
                final isRestDay = workoutDay == null;

                return DayCard(
                  dayName: dayName,
                  workoutDay: workoutDay,
                  isRestDay: isRestDay,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
