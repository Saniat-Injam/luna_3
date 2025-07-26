import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/habits/controller/delete_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/habits/model/habit_model.dart';
import 'package:barbell/features/habits/model/my_habit_model.dart';
import 'package:barbell/features/habits/util/utc_to_local_time.dart';
import 'package:barbell/features/habits/view/create_or_update_my_habit.dart';

class MyHabitCard extends StatelessWidget {
  const MyHabitCard({super.key, required this.myHabit, required this.habit});

  final MyHabitModel myHabit;
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Image and Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:
                      habit.img.toLowerCase().endsWith('.svg')
                          ? SvgPicture.network(
                            habit.img,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            placeholderBuilder:
                                (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          )
                          : Image.network(
                            habit.img,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(habit.name, style: AppTextStyle.f18W600()),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Middle: Reminder Days
            if (myHabit.reminderDays.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildInfoRow(
                  Icons.calendar_month_outlined,
                  myHabit.reminderDays.join(', '),
                ),
              ),

            // Bottom Row: Notification, Time, Interval
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  children: [
                    Icon(
                      myHabit.isPushNotification
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color:
                          myHabit.isPushNotification
                              ? Colors.blueAccent
                              : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      // _formatReminderTime(myHabit.reminderTime),
                      utcToLocalTime(DateTime.parse(myHabit.reminderTime)),
                      style: AppTextStyle.f14W400().copyWith(
                        color: AppColors.habitSub,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: AppColors.habitSub,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${myHabit.reminderInterval} min',
                      style: AppTextStyle.f14W400().copyWith(
                        color: AppColors.habitSub,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Edit delete buttons
                Wrap(
                  children: [
                    InkWell(
                      child: Icon(Icons.edit, color: AppColors.info),
                      onTap:
                          () => Get.to(
                            () => CreateOrUpdateMyHabitScreen(myHabit: myHabit),
                          ),
                    ),
                    const SizedBox(width: 8),
                    GetBuilder<DeleteMyHabitController>(
                      builder: (controller) {
                        if (controller.isLoading &&
                            controller.habitId == myHabit.habitId) {
                          return SizedBox(
                            width: 24,
                            height: 24,
                            child: const CircularProgressIndicator(),
                          );
                        }
                        return InkWell(
                          onTap: () => _onClickDelete(controller),
                          child: Icon(Icons.delete, color: Colors.red),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.habitSub.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.f14W400().copyWith(color: AppColors.habitSub),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatReminderTime(String? isoTime) {
    if (isoTime == null) return 'No time set';
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final period = dateTime.hour < 12 ? 'AM' : 'PM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } catch (e) {
      return 'Invalid time';
    }
  }

  void _onClickDelete(DeleteMyHabitController controller) async {
    final isSuccess = await controller.deleteMyHabit(myHabit.habitId);
    if (isSuccess) {
      EasyLoading.showSuccess(
        'Habit deleted successfully',
        duration: const Duration(seconds: 2),
      );
      await Get.find<GetMyHabitController>().getMyHabits();
    } else {
      EasyLoading.showError(
        'Failed to delete habit',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
