import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_header_section.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_plan_empty_state.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_plan_list.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_plan_action_buttons.dart';

class WorkoutPlanScreen extends StatelessWidget {
  const WorkoutPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(BarbellLLMController());

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomAppBar(
                title: 'Weekly Workout Plan',
                showNotification: true,
                showBackButton: true,
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle with instructions
            GetBuilder<BarbellLLMController>(
              builder: (controller) {
                final workoutPlan = controller.displayWorkoutPlan;

                if (workoutPlan == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: WorkoutPlanHeader(workoutPlan: workoutPlan),
                );
              },
            ),
            const SizedBox(height: 20),

            // Main content area
            Expanded(
              child: GetBuilder<BarbellLLMController>(
                builder: (controller) {
                  final workoutPlan = controller.displayWorkoutPlan;

                  if (workoutPlan == null || workoutPlan.plan.isEmpty) {
                    return const WorkoutPlanEmptyState();
                  }

                  return WorkoutPlanList(
                    workoutPlan: workoutPlan,
                    controller: controller,
                  );
                },
              ),
            ),

            // Fixed action buttons at bottom (only show for generated plans)
            GetBuilder<BarbellLLMController>(
              builder: (controller) {
                // Only show action buttons for newly generated plans, not saved plans
                final hasGeneratedPlan =
                    controller.workoutPlanResponse.value?.data?.workoutPlan !=
                    null;

                if (!hasGeneratedPlan || controller.isDisplayingSavedPlan) {
                  return const SizedBox.shrink();
                }

                return WorkoutPlanActionButtons(controller: controller);
              },
            ),
          ],
        ),
      ),
    );
  }
}
