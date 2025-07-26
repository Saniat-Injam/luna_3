import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/food_analysis_summary_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_logging_controller.dart';
import 'package:barbell/features/food_logging/controllers/logged_food_controller.dart';
import 'package:barbell/features/food_logging/enums/food_loggin_enums.dart';
import 'package:barbell/features/food_logging/view/add_consumed_food_screen.dart';
import 'package:barbell/features/food_logging/widgets/meal_section.dart';
import 'package:barbell/features/food_logging/widgets/nutrition_card.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class FoodLoggingScreen extends StatelessWidget {
  static const String routeName = '/food-logging';

  const FoodLoggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodLoggingController());
    final summaryController = Get.put(FoodAnalysisSummaryController());
    Get.put(LoggedFoodController());
    // Ensure HomeController is available for nutrition data
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      appBar: AppBarWidget(title: 'Today', showNotification: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Get.find<HomeController>().getFoodAnalysisProgress();
                    await summaryController.fetchFoodAnalysisSummary();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: GetBuilder<FoodAnalysisSummaryController>(
                      builder: (ctrl) {
                        if (ctrl.isLoading) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.primary,
                            highlightColor: AppColors.secondary,
                            child: Column(
                              children: [
                                // Nutrition Card
                                const NutritionCard(),
                                const SizedBox(height: 24),

                                // Placeholder for meal sections
                                ...List.generate(
                                  4,
                                  (index) => Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.appbar,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final mealSummary =
                            ctrl.summary?.daily[0].consumedMeals;
                        return Column(
                          children: [
                            // Nutrition Card
                            NutritionCard(
                              analysisSummary: ctrl.summary?.daily.first,
                            ),
                            const SizedBox(height: 24),

                            // Meal Sections
                            MealSection(
                              title:
                                  FoodLogginEnums.breakfast.name.toUpperCase(),
                              calories:
                                  mealSummary?.breakfast.totalCalories
                                      .toDouble() ??
                                  0.0,
                              onTap: () async {
                                controller.consumedAs =
                                    FoodLogginEnums.breakfast.name;

                                Get.to(() => const AddConsumedFoodScreen());
                              },
                            ),
                            const SizedBox(height: 16),
                            MealSection(
                              title: FoodLogginEnums.lunch.name.toUpperCase(),
                              calories:
                                  mealSummary?.lunch.totalCalories.toDouble() ??
                                  0.0,
                              onTap: () async {
                                controller.consumedAs =
                                    FoodLogginEnums.lunch.name;
                                Get.to(() => const AddConsumedFoodScreen());
                              },
                            ),
                            const SizedBox(height: 16),
                            MealSection(
                              title: FoodLogginEnums.dinner.name.toUpperCase(),
                              calories:
                                  mealSummary?.dinner.totalCalories
                                      .toDouble() ??
                                  0.0,
                              onTap: () async {
                                controller.consumedAs =
                                    FoodLogginEnums.dinner.name;
                                Get.to(() => const AddConsumedFoodScreen());
                              },
                            ),
                            const SizedBox(height: 16),
                            MealSection(
                              title: FoodLogginEnums.snack.name.toUpperCase(),
                              calories:
                                  mealSummary?.snack.totalCalories.toDouble() ??
                                  0.0,
                              // title: 'Snacks',
                              onTap: () async {
                                controller.consumedAs =
                                    FoodLogginEnums.snack.name;
                                Get.to(() => const AddConsumedFoodScreen());
                              },
                            ),

                            const SizedBox(height: 80),
                          ],
                        );
                      },
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
}
