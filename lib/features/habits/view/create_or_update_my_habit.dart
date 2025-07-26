import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/custom_app_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/add_or_update_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/weekly_habits_controller.dart';
import 'package:barbell/features/habits/model/my_habit_model.dart';
import 'package:barbell/features/habits/widget/day_selector.dart';
import 'package:barbell/features/habits/widget/habbit_button.dart';
import 'package:barbell/features/habits/widget/habit_tip_section.dart';
import 'package:barbell/features/home/widgets/notification_time_card.dart';
import 'package:barbell/features/home/widgets/weekly_habits_header.dart';

class CreateOrUpdateMyHabitScreen extends StatelessWidget {
  static const String routeName = '/weekly_habits';
  const CreateOrUpdateMyHabitScreen({super.key, this.myHabit});

  final MyHabitModel? myHabit;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyHabitsController());
    final chooseHabitsController = Get.find<AddOrUpdateMyHabitController>();

    if (myHabit != null) {
      controller.updateHabit(myHabit!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBar(
                          title: 'Weekly habits',
                          showBackButton: true,
                        ),

                        // --------- Header with title and description ---------
                        const WeeklyHabitsHeader(),
                        const SizedBox(height: 12),

                        // --------- Notification settings card ---------
                        NotificationAndTimeCard(controller: controller),
                        const SizedBox(height: 12),

                        // --------- Reminder days section ---------
                        DaySelector(controller: controller),
                        const SizedBox(height: 12),

                        // --------- Tip section ---------
                        const HabitTipSection(),
                        const SizedBox(height: 12),

                        // --------- Bottom button section ---------
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 24,
                            ),
                            child: CustomHabitButton(
                              showButton: true.obs,
                              onPressed: () async {
                                bool isSuccess = await chooseHabitsController
                                    .addOrUpdateMyHabit(
                                      habitId: myHabit?.habitId,
                                    );
                                if (isSuccess) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              buttonText: myHabit != null ? 'Update' : 'Save',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
