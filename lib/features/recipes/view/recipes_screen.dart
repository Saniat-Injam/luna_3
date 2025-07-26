import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/common/widgets/search_input_decoration.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/food_logging/controllers/food_favorites_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/view/food_details_screen.dart';
import 'package:barbell/features/recipes/controllers/recipes_controller.dart';
import 'package:barbell/features/recipes/view/my_recipes_screen.dart';
import 'package:barbell/features/recipes/widgets/recipe_card.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipesController());
    Get.put(FoodFavoritesController());
    final GetAllFoodsController foodCaloriesController =
        Get.find<GetAllFoodsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ///------------------ Header and searchbar ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'All Recipes',
                    showBackButton: true,
                    showNotification: true,
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    onChanged: controller.updateSearchQuery,
                    style: getTextStyleWorkSans(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                    decoration: searchTextfeildDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ///------------------ Recipe Grid ------------------
            Expanded(
              child: GetBuilder<GetAllFoodsController>(
                builder: (controller) {
                  return GridView.builder(
                    itemCount: controller.foodsItems.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () => Get.to(() => const MyRecipesScreen()),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              border: Border.all(
                                color: const Color(0xFF183021),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  SvgPath.myrecipessvg,
                                  width: 60,
                                  height: 60,
                                ),
                                Text(
                                  'My Recipes',
                                  style: getTextStyleWorkSans(
                                    color: AppColors.textWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return RecipeCard(
                        recipe: foodCaloriesController.foodsItems[index - 1],
                        onTap: () {
                          Get.to(
                            FoodDetailsScreen(
                              foodItem:
                                  foodCaloriesController.foodsItems[index - 1],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
