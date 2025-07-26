import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';
import 'package:barbell/features/barbell_llm/widgets/ask_barbell_card.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_plan_card.dart';
import 'package:barbell/features/barbell_llm/widgets/workout_plan_form.dart';
import 'package:barbell/features/barbell_llm/view/ask_barbell_chat_screen.dart';
import 'package:barbell/features/barbell_llm/view/workout_plan_screen.dart';

class BarbellLLMScreen extends StatelessWidget {
  static const String routeName = '/barbell-llm';
  const BarbellLLMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbellLLMController());

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CustomAppBar(
                title: 'Barbell LLM',
                showNotification: true,
                showBackButton: true,
              ),

              const SizedBox(height: 20),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ask Barbell and Workout Plan Cards
                      Row(
                        children: [
                          Expanded(
                            child: AskBarbellCard(
                              onTap:
                                  () => Get.to(
                                    () => const AskBarbellChatScreen(),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: WorkoutPlanCard(
                              onTap:
                                  () async {
                                    if (controller.savedWorkoutPlan.value !=
                                        null) {
                                      Get.to(() => const WorkoutPlanScreen());
                                    } else {
                                      await controller.loadSavedWorkoutPlan();
                                      Get.to(() => const WorkoutPlanScreen());
                                    }
                                  },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Workout Plan Creation Form
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Workout Plan Creation',
                          style: getTextStyleWorkSans(
                            color: AppColors.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // workout plan form
                      WorkoutPlanForm(controller: controller),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
