import 'package:get/get.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';

class HabitStateController extends GetxController {
  final GetMyHabitController getMyHabitController = Get.find();

  final RxInt habitsCount = 0.obs;
  final RxString selectedHabit = ''.obs;

  void addHabit(String habitTitle) {
    habitsCount.value++;
    selectedHabit.value = habitTitle;
  }

  String getHabitCardTitle() {
    if (getMyHabitController.myHabits.isEmpty) {
      return 'Choose your next habits';
    }
    return '${getMyHabitController.myHabits.length} Habits added';
  }

  String getHabitCardSubtitle() {
    if (getMyHabitController.myHabits.isEmpty) {
      return 'Big goals start with small habits.';
    }
    return getMyHabitController.myHabits.last.habitId;
  }
}
