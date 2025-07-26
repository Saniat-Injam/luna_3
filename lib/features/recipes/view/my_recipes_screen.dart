import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/view/create_food_screen.dart';
import 'package:barbell/features/food_logging/view/food_details_screen.dart';
import 'package:barbell/features/recipes/widgets/recipe_card.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FoodImageController());
    final foodCaloriesController = Get.find<GetAllFoodsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomAppBar(
                    title: 'My Recipes',
                    showBackButton: true,
                    showNotification: true,
                  ),
                ),
                const SizedBox(height: 20),
                // Recipe Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GetBuilder<GetAllFoodsController>(
                      builder: (controller) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                          itemCount:
                              foodCaloriesController.personalFoodItems.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(
                              recipe:
                                  foodCaloriesController
                                      .personalFoodItems[index],
                              onTap:
                                  () => Get.to(
                                    () => FoodDetailsScreen(
                                      foodItem:
                                          foodCaloriesController
                                              .personalFoodItems[index],
                                    ),
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Created Button at bottom
            Positioned(
              bottom: 46,
              right: 20,
              child: Center(
                child: GestureDetector(
                  onTap:
                      () =>
                          Get.to(() => const CreateFoodScreen(isCreate: true)),

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Create',
                      style: getTextStyleWorkSans(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
