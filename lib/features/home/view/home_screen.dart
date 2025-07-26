import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/image_path.dart';
import 'package:barbell/features/barbell_llm/view/barbell_llm_screen.dart';
import 'package:barbell/features/food_logging/view/food_logging_screen.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/habits/view/habits_screen.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';
import 'package:barbell/features/home/widgets/habit_card.dart';
import 'package:barbell/features/home/widgets/home_header.dart';
import 'package:barbell/features/home/widgets/menu_item.dart';
import 'package:barbell/features/home/widgets/nutition_card.dart';
import 'package:barbell/features/notification/controller/get_notification_bell_controller.dart';
import 'package:barbell/features/recipes/view/recipes_screen.dart';
import 'package:barbell/features/workout/view/all_workout_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationBellController =
        Get.find<GetNotificationBellController>();

    final homeController = Get.find<HomeController>();
    _getFoodAnalysisProgress(homeController);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              HomeHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await homeController.getFoodAnalysisProgress();
                    await notificationBellController.getNotificationBell();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Polished Nutrition Card - Simple & Professional
                        const NutritionCard(),
                        const SizedBox(height: 32),

                        // Simplified Habits Card
                        GetBuilder<GetMyHabitController>(
                          builder: (controller) {
                            return HabitCard(
                              title:
                                  (controller.myHabits.isEmpty)
                                      ? 'Choose your next habits'
                                      : '${controller.myHabits.length} Habits added',
                              subtitle: 'Big goals start with small habits.',
                              onPressed: () {
                                Get.to(() => HabitsScreen());
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Menu Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                          children: [
                            MenuItem(
                              icon: ImagePath.workoutimage,
                              title: 'Workouts',
                              subtitle: 'Sweating is self-care',
                              onTap: () async {
                                Get.to(() => AllWorkoutScreen());
                              },
                            ),
                            MenuItem(
                              icon: ImagePath.foodeImage,
                              title: 'Food Logging',
                              subtitle: 'Select a meal',
                              onTap: () async {
                                Get.to(() => FoodLoggingScreen());
                              },
                            ),
                            MenuItem(
                              icon: ImagePath.recipeimage,
                              title: 'Recipes',
                              subtitle: 'Cook, eat, log, repeat',
                              onTap: () {
                                Get.to(() => const RecipesScreen());
                              },
                            ),
                            MenuItem(
                              icon: ImagePath.messageimage,
                              title: 'Barbell LLM',
                              subtitle: 'Ask Barbell',
                              onTap: () {
                                Get.to(() => const BarbellLLMScreen());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get food analysis progress
  void _getFoodAnalysisProgress(HomeController homeController) {
    if (homeController.foodAnalysisProgress.value == null) {
      homeController.getFoodAnalysisProgress();
    }
  }
}
