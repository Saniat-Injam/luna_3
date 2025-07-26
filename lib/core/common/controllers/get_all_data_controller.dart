import 'package:get/get.dart';
import 'package:barbell/features/food_logging/controllers/food_analysis_summary_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_favorites_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/habits/controller/get_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/workout/controller/get_all_workout_controller.dart';

class GetAllDataController extends GetxController {
  void fetchAllDataOneceAfterLoggedIn() async {
    await Get.find<ProfileController>().getProfileData();
    await Get.put(GetAllWorkoutController()).getAllWorkout();
    await Get.find<GetAllFoodsController>().getAllFoods();

    // Initialize and load favorites after food data is available
    final favoritesController = Get.put(FoodFavoritesController());
    await favoritesController.refreshFavorites();

    await Get.find<GetHabitController>().getHabits();
    await Get.find<GetMyHabitController>().getMyHabits();
    await Get.find<FoodAnalysisSummaryController>().fetchFoodAnalysisSummary();
  }
}
