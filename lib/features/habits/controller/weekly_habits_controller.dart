import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/features/habits/model/my_habit_model.dart';

class WeeklyHabitsController extends GetxController {
  // Notification toggle state
  final RxBool isNotificationEnabled = true.obs;

  // Selected time
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  // Selected days for notifications
  final RxList<String> selectedDays = <String>[].obs;

  final reminderIntervalController = TextEditingController(text: "60");

  // Toggle notification
  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  // Update selected time
  void updateTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  // Toggle day selection
  void toggleDaySelection(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  // Format time for display
  String getFormattedTime() {
    final hour = selectedTime.value.hour;
    final minute = selectedTime.value.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour =
        hour > 12
            ? hour - 12
            : hour == 0
            ? 12
            : hour;
    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  void updateHabit(MyHabitModel myHabit) {
    isNotificationEnabled.value = myHabit.isPushNotification;
    final utcTime = DateTime.parse(myHabit.reminderTime);
    final localTime = utcTime.toLocal();
    selectedTime.value = TimeOfDay.fromDateTime(localTime);
    selectedDays.value = myHabit.reminderDays;
    reminderIntervalController.text = myHabit.reminderInterval.toString();
  }
}
