import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/add_or_update_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/habits/model/habit_model.dart';
import 'package:barbell/features/habits/view/create_habit_view.dart';
import 'package:barbell/features/habits/view/create_or_update_my_habit.dart';
import 'package:barbell/features/habits/widget/habbit_button.dart';
import 'package:barbell/features/habits/widget/habit_tab_bar_buttons.dart';
import 'package:barbell/features/habits/widget/habit_tile.dart';
import 'package:barbell/features/habits/widget/my_habit_card.dart';
import 'package:shimmer/shimmer.dart';

class HabitsScreen extends StatelessWidget {
  static const String routeName = '/habits';
  HabitsScreen({super.key});

  final chooseHabitController = Get.put(AddOrUpdateMyHabitController());
  final getHabitController = Get.find<GetHabitController>();

  @override
  Widget build(BuildContext context) {
    _getHabitData();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Habits',
        showBackButton: true,
        showNotification: true,
        actions: [
          if (StorageService.role == 'admin')
            Tooltip(
              message: 'Create new Habit for all users',
              child: GestureDetector(
                onTap: () => Get.to(() => const CreateHabitView()),
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 16,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getHabitController.getHabits();
          await Get.find<GetMyHabitController>().getMyHabits();
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              HabitTabBarButtons(chooseHabitController: chooseHabitController),
              const SizedBox(),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    if (chooseHabitController.selectedTabIndex.value == 1) {
                      return _buildMyHabitSection(context);
                    }

                    return _buildChooseHabitSection(context);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChooseHabitSection(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GetBuilder<GetHabitController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return Shimmer.fromColors(
                      baseColor: AppColors.primary,
                      highlightColor: AppColors.secondary,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 10),
                        itemCount: 10, // Show 10 shimmer
                      ),
                    );
                  }
                  if (controller.habits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            color: AppColors.secondary,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits found',
                            style: AppTextStyle.f16W600().copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.habits.length,
                    itemBuilder: (context, index) {
                      if (index >= controller.habits.length) {
                        return const SizedBox.shrink();
                      }
                      final habit = controller.habits[index];
                      return HabitTile(
                        index: index,
                        habit: habit,
                        controller: chooseHabitController,
                      );
                    },
                  );
                },
              ),

              Positioned(
                bottom: 10,
                right: (MediaQuery.of(context).size.width * 0.5) - 108,
                child: Obx(
                  () => CustomHabitButton(
                    showButton: chooseHabitController.showNextButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const CreateOrUpdateMyHabitScreen(),
                        ),
                      );
                    },
                    buttonText: 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMyHabitSection(BuildContext context) {
    return GetBuilder<GetMyHabitController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Shimmer.fromColors(
            baseColor: AppColors.primary,
            highlightColor: AppColors.secondary,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 5, // Show 10 shimmer
            ),
          );
        }
        if (controller.myHabits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: AppColors.secondary,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  'No habits added',
                  style: AppTextStyle.f16W600().copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.myHabits.length,
          itemBuilder: (context, index) {
            final habit = controller.myHabits[index];
            final habitDetails = getHabitController.habits.firstWhere(
              (element) => element.id == habit.habitId,
              orElse:
                  () => HabitModel(
                    id: '',
                    name: 'Unknown Habit',
                    img: '',
                    description: 'Habit details not available',
                  ),
            );
            return MyHabitCard(myHabit: habit, habit: habitDetails);
          },
        );
      },
    );
  }

  void _getHabitData() async {
    final habitController = Get.find<GetHabitController>();
    final myHabitController = Get.find<GetMyHabitController>();
    if (habitController.habits.isEmpty) {
      await habitController.getHabits();
    }
    if (myHabitController.myHabits.isEmpty) {
      await myHabitController.getMyHabits();
    }
  }
}
