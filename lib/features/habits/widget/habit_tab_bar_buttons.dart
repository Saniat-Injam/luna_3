import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/add_or_update_my_habit_controller.dart';

class HabitTabBarButtons extends StatelessWidget {
  const HabitTabBarButtons({super.key, required this.chooseHabitController});

  final AddOrUpdateMyHabitController chooseHabitController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => chooseHabitController.selectTab(0),
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        chooseHabitController.selectedTabIndex.value == 0
                            ? AppColors.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Choose Habit',
                      style: TextStyle(
                        color:
                            chooseHabitController.selectedTabIndex.value == 0
                                ? Colors.white
                                : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => chooseHabitController.selectTab(1),
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        chooseHabitController.selectedTabIndex.value == 1
                            ? AppColors.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'My habits',
                      style: TextStyle(
                        color:
                            chooseHabitController.selectedTabIndex.value == 1
                                ? Colors.white
                                : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
