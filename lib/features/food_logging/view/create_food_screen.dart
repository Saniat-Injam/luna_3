import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/add_food_manually_controller.dart';
import 'package:barbell/features/food_logging/controllers/edit_food_controller.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/widgets/custom_text_field.dart';
import 'package:barbell/features/food_logging/widgets/food_image_upload_widget.dart';
import 'package:barbell/features/food_logging/widgets/food_name_field.dart';
import 'package:barbell/features/food_logging/widgets/ingredient_section.dart';
import 'package:barbell/features/food_logging/widgets/instructions_section.dart';
import 'package:barbell/features/food_logging/widgets/nutrients_per_serving_section.dart';

class CreateFoodScreen extends GetView<AddFoodManuallyController> {
  static const routeName = '/add-food-manually';
  const CreateFoodScreen({
    super.key,
    this.isCreate = true,
    this.isForAllUsers = false,
    this.foodItem,
  });

  final bool isCreate;
  final bool isForAllUsers;
  final FoodCaloriesModel? foodItem;

  @override
  Widget build(BuildContext context) {
    final addFoodManuallyController = Get.put(AddFoodManuallyController());
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),

      appBar: AppBarWidget(
        title:
            isCreate
                ? 'Create Food ${isForAllUsers ? 'for all' : 'for you'}'
                : 'Add Nutrients',
        showNotification: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (isCreate)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      //* ------------------ Image Upload Section ------------------
                      FoodImageUploadWidget(
                        controller: addFoodManuallyController.imageController,
                        imageUrl: foodItem?.img,
                      ),
                      const SizedBox(height: 20),

                      //* ------------------ Name Field ------------------
                      FoodNameField(
                        controller: addFoodManuallyController.nameController,
                      ),
                      const SizedBox(height: 20),

                      //* ------------------ Ingredient Section ------------------
                      IngredientSection(
                        controller:
                            addFoodManuallyController.ingredientsController,
                      ),
                      const SizedBox(height: 20),

                      //* ------------------ Instructions Section ------------------
                      InstructionsSection(
                        controller:
                            addFoodManuallyController.instructionsController,
                        onChanged: (value) {
                          addFoodManuallyController
                              .instructionsController
                              .text = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      //* ------------------ Servings Field ------------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appbar,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Servings',
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: CustomTextField(
                                hintText: '01',
                                controller:
                                    addFoodManuallyController
                                        .servingsController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      //* ------------------ Preparation Time Field ------------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appbar,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Preparation Time',
                              style: getTextStyleWorkSans(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: CustomTextField(
                                hintText: '0 Min',
                                controller:
                                    addFoodManuallyController
                                        .prepTimeController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                //* ------------------ Nutrients Per Serving Section ------------------
                if (!isCreate && foodItem == null) SizedBox(height: 20),
                NutrientsPerServingSection(
                  // controllers: addFoodManuallyController.nutrientControllers,
                  // onChanged: addFoodManuallyController.nutrientOnChange,
                ),
                const SizedBox(height: 30),

                //* ------------------ Save Button ------------------
                FilledButton(
                  onPressed: () async {
                    if (foodItem != null) {
                      await Get.find<EditFoodController>().editFoodItem(
                        foodItem!.sId!,
                      );
                    } else if (isCreate) {
                      addFoodManuallyController.createPersonalFoodItem(
                        isForAllUsers: isForAllUsers,
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    fixedSize: const Size(double.maxFinite, 50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    foodItem != null
                        ? 'Update'
                        : isCreate
                        ? 'Create ${isForAllUsers ? 'for all users' : 'for yourself'}'
                        : 'Add',
                    style: getTextStyleWorkSans(
                      color: AppColors.textfieldBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
