import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/add_or_update_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/delete_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_habit_controller.dart';
import 'package:barbell/features/habits/model/habit_model.dart';
import 'package:shimmer/shimmer.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.index,
    required this.habit,
    // required this.icon,
    // required this.title,
    // required this.subtitle,
    required this.controller,
  });

  final int index;
  final HabitModel habit;
  // final String icon;
  // final String title;
  // final String subtitle;
  final AddOrUpdateMyHabitController controller;

  @override
  Widget build(BuildContext context) {
    final deleteHabitController = Get.find<DeleteHabitController>();
    // final getHabitController = Get.find<GetHabitController>();
    return Obx(() {
      final isSelected = controller.selectedHabitId.value == habit.id;
      // final isSelected = controller.selectedHabitIndex.value == index;
      if (deleteHabitController.isLoading &&
          deleteHabitController.habitId == habit.id) {
        return Shimmer.fromColors(
          baseColor: AppColors.primary,
          highlightColor: AppColors.secondary,
          child: Container(height: 80, color: Colors.white),
        );
      }
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: isSelected ? AppColors.primary : AppColors.appbar,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: () => controller.selectHabit(habit.id),
            // onTap: () => controller.selectHabit(index),
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!habit.img.toLowerCase().endsWith('.svg'))
                        Image.network(
                          habit.img,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      if (habit.img.toLowerCase().endsWith('.svg'))
                        SvgPicture.network(habit.img, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(
                        habit.name,
                        style: getTextStyleInter(
                          color: AppColors.textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      if (StorageService.role == "admin" && isSelected)
                        GestureDetector(
                          onTap: () => _onClickDelete(context),
                          child: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        habit.description,
                        style: getTextStyleInter(
                          color: AppColors.habitSub,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          lineHeight: 10,
                        ),
                      ),
                    ),
                    crossFadeState:
                        isSelected
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onClickDelete(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final bool isSuccess = await Get.find<DeleteHabitController>()
          .deleteHabit(habit.id);
      if (isSuccess) {
        // Handle successful deletion (e.g., show a snackbar)
        EasyLoading.showSuccess(
          'Habit deleted successfully',
          duration: const Duration(seconds: 2),
        );
        // Optionally, you can refresh the habit list or update the UI
        Get.find<GetHabitController>().habits.removeWhere(
          (h) => h.id == habit.id,
        );
        Get.find<GetHabitController>().update();
      } else {
        // Handle deletion failure (e.g., show an error snackbar)
        EasyLoading.showError(
          'Failed to delete habit',
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}
