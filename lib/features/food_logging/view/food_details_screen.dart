import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/add_consumed_food_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_favorites_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/widgets/food_info_row.dart';
import 'package:barbell/features/food_logging/widgets/ingredients_list.dart';

class FoodDetailsScreen extends StatelessWidget {
  final FoodCaloriesModel foodItem;
  static const routeName = '/food-details';
  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.put(FoodFavoritesController());

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      body: Stack(
        children: [
          // Image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Image.network(foodItem.img ?? '', fit: BoxFit.cover),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.appbar,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Favorite Button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                foodItem.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.f21W500(),
                              ),
                            ),
                            Obx(() {
                              final isFavorite = favoritesController.isFavorite(
                                foodItem,
                              );
                              return IconButton(
                                onPressed:
                                    () => favoritesController.toggleFavorite(
                                      foodItem,
                                    ),
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.secondary,
                                  size: 24,
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info Row
                        FoodInfoRow(foodItem: foodItem),
                        const SizedBox(height: 24),

                        // Ingredients
                        IngredientsList(
                          ingredients: foodItem.ingredients ?? [],
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Instructions',
                          style: getTextStyleWorkSans(
                            color: AppColors.textWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 12),
                        // Instructions Section
                        Text(
                          foodItem.instructions ?? '',
                          style: AppTextStyle.f14W400(),
                        ),

                        const SizedBox(height: 24),

                        // Track Button
                        Align(
                          alignment: Alignment.center,
                          child: FilledButton(
                            onPressed: () async {
                              await Get.find<AddConsumedFoodController>()
                                  .addConsumedFoodOnClickAdd(
                                    foodItem.sId ?? '',
                                  );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            ),
                            child: Text(
                              'Track',
                              style: getTextStyleWorkSans(
                                color: AppColors.textfieldBackground,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
