import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/features/food_logging/controllers/add_food_manually_controller.dart';
import 'package:barbell/features/food_logging/controllers/delete_food_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/view/create_food_screen.dart';
import 'package:barbell/features/food_logging/view/food_details_screen.dart';
import 'package:barbell/features/food_logging/widgets/food_item_card.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';

class AllFoodListContantWidget extends StatelessWidget {
  const AllFoodListContantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetAllFoodsController>();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.foodsItems.length,
      itemBuilder: (context, index) {
        final item = controller.foodsItems[index];

        if (StorageService.role == 'admin' ||
            item.userId ==
                Get.find<ProfileController>().profileModel?.userId.id) {
          return Slidable(
            key: ValueKey(item.sId),
            // swipe actions from left to right (Edit)
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                // Action to edit food item
                SlidableAction(
                  onPressed: (context) {
                    Get.find<AddFoodManuallyController>().updateFoodItem(item);
                    // Navigate to edit screen with the food item details
                    Get.to(
                      () => CreateFoodScreen(
                        foodItem: controller.foodsItems[index],
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              dismissible: DismissiblePane(
                onDismissed: () async {
                  await Get.find<DeleteFoodController>().deleteFoodItem(
                    item.sId ?? '',
                  );
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await Get.find<DeleteFoodController>().deleteFoodItem(
                      item.sId ?? '',
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => Get.to(() => FoodDetailsScreen(foodItem: item)),
              child: FoodItemCard(
                foodItem: item,
                onAdd: () {},
                // () async => await Get.find<AddConsumedFoodController>()
                //     .addConsumedFood(
                //       consumedAs:
                //           Get.find<FoodLoggingController>()
                //               .consumedAs
                //               .value
                //               .name
                //               .toLowerCase(),
                //       foodId: item.sId ?? '',
                //     ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => Get.to(() => FoodDetailsScreen(foodItem: item)),
            child: FoodItemCard(
              foodItem: item,
              onAdd: () => controller.addFoodItem(item),
            ),
          );
        }
      },
    );
  }
}
