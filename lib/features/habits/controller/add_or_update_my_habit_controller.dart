import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/habit_state_controller.dart';
import 'package:barbell/features/habits/controller/weekly_habits_controller.dart';

class AddOrUpdateMyHabitController extends GetxController {
  final WeeklyHabitsController weeklyHabitsController = Get.find();
  final HabitStateController habitStateController = Get.find();

  RxInt selectedTabIndex = 0.obs;
  RxString selectedHabitId = ''.obs;
  // final RxInt selectedHabitIndex = RxInt(-1);
  RxBool get showNextButton => (selectedHabitId.value.isNotEmpty).obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectHabit(String habitId) {
    if (selectedHabitId.value == habitId) {
      selectedHabitId.value = '';
      return;
    }
    selectedHabitId.value = habitId;
  }

  String getSelectedHabit() {
    return selectedHabitId.value;
  }

  Future<bool> addOrUpdateMyHabit({String? habitId}) async {
    if (habitId != null) {
      selectedHabitId.value = habitId;
    }
    if (selectedHabitId.value.isEmpty ||
        selectedHabitId.value == '' ||
        weeklyHabitsController.selectedDays.isEmpty ||
        weeklyHabitsController.reminderIntervalController.text.isEmpty ||
        weeklyHabitsController.reminderIntervalController.text == '') {
      EasyLoading.showError('Please fill all the fields');
      return false;
    }
    EasyLoading.show(status: 'Loading...');
    bool isSuccess = false;

    final now = DateTime.now();
    final time = weeklyHabitsController.selectedTime.value;
    final reminderDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final utcDateTime = reminderDateTime.toUtc();
    final requestBody = {
      "habit_id": selectedHabitId.value,
      "isPushNotification": weeklyHabitsController.isNotificationEnabled.value,
      "reminderTime": utcDateTime.toIso8601String(),
      "reminderInterval":
          weeklyHabitsController.reminderIntervalController.text,
      "reminderDays": weeklyHabitsController.selectedDays,
    };

    final response = await Get.find<NetworkCaller>().postRequest(
      url:
          habitId != null ? Urls.updateUserHabit(habitId) : Urls.addHabitToUser,
      body: requestBody,
    );

    EasyLoading.dismiss();

    if (response.isSuccess) {
      isSuccess = true;
      EasyLoading.showSuccess(
        'Habit ${habitId != null ? 'updated' : 'added'} successfully',
      );
      // habitStateController.addHabit(selectedHabitId.value);
      selectedTabIndex.value = 1;
      await Get.find<GetMyHabitController>().getMyHabits();
    } else {
      EasyLoading.showError(
        'Failed to ${habitId != null ? 'update' : 'add'} habit',
      );
    }
    EasyLoading.dismiss();
    update();
    return isSuccess;
  }

  // Habit data
  // final List<Map<String, String>> habits = [
  //   {
  //     'icon': SvgPath.protinSvg,
  //     'title': 'Eat more protein',
  //     'subtitle':
  //         'Hit my protein goal at least 3 days this week. Feed your muscles, skin, and bone health.',
  //   },
  //   {
  //     'icon': SvgPath.waterSvg,
  //     'title': 'Drink more water',
  //     'subtitle':
  //         'Stay hydrated throughout the day for better health and energy.',
  //   },
  //   {
  //     'icon': SvgPath.fruitSvg,
  //     'title': 'Eat more fruit',
  //     'subtitle': 'Add natural sweetness and essential vitamins to your diet.',
  //   },
  //   {
  //     'icon': SvgPath.vegetablesSvg,
  //     'title': 'Eat more vegetables',
  //     'subtitle': 'Boost your nutrition with colorful and healthy vegetables.',
  //   },
  //   {
  //     'icon': SvgPath.mealLogSvg,
  //     'title': 'Log a daily meal',
  //     'subtitle': 'Track your nutrition to make better food choices.',
  //   },
  //   {
  //     'icon': SvgPath.fiberSvg,
  //     'title': 'Eat more fiber',
  //     'subtitle': 'Improve digestion and feel fuller for longer.',
  //   },
  //   {
  //     'icon': SvgPath.exerciseSvg,
  //     'title': 'Get more exercise',
  //     'subtitle': 'Move more to feel better and boost your energy.',
  //   },
  //   {
  //     'icon': SvgPath.alcoholSvg,
  //     'title': 'Drink less alcohol',
  //     'subtitle': 'Cut back on alcohol for better sleep and health.',
  //   },
  //   {
  //     'icon': SvgPath.sugerSvg,
  //     'title': 'Reduce added sugar',
  //     'subtitle':
  //         'Lower your sugar intake for better health and energy levels.',
  //   },
  // ];
}
