import 'package:get/get.dart';
import 'package:barbell/core/common/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:barbell/core/common/widgets/custom_text_form_field.dart';
import 'package:barbell/core/controllers/notification_badge_controller.dart';
import 'package:barbell/core/services/app_service.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/features/auth/controller/create_account_controller.dart';
import 'package:barbell/features/auth/controller/login_controller.dart';
import 'package:barbell/features/food_logging/controllers/add_consumed_food_controller.dart';
import 'package:barbell/features/food_logging/controllers/add_food_manually_controller.dart';
import 'package:barbell/features/food_logging/controllers/delete_food_controller.dart';
import 'package:barbell/features/food_logging/controllers/edit_food_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_analysis_summary_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';
import 'package:barbell/features/food_logging/controllers/food_logging_controller.dart';
import 'package:barbell/features/food_logging/controllers/get_all_foods_controller.dart';
import 'package:barbell/features/food_logging/controllers/logged_food_controller.dart';
import 'package:barbell/features/habits/controller/add_or_update_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/create_habit_controller.dart';
import 'package:barbell/features/habits/controller/delete_habit_controller.dart';
import 'package:barbell/features/habits/controller/delete_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_habit_controller.dart';
import 'package:barbell/features/habits/controller/get_my_habit_controller.dart';
import 'package:barbell/features/habits/controller/habit_state_controller.dart';
import 'package:barbell/features/habits/controller/weekly_habits_controller.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';
import 'package:barbell/features/notification/controller/delete_notification_controller.dart';
import 'package:barbell/features/notification/controller/get_all_notification_controller.dart';
import 'package:barbell/features/notification/controller/get_notification_bell_controller.dart';
import 'package:barbell/features/notification/controller/notification_controller.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/tips/controllers/article_controller.dart';
import 'package:barbell/features/workout%20setup/controller/get_workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout/controller/delete_workout_controller.dart';
import 'package:barbell/features/workout/controller/exercise_analysis_controller.dart';
import 'package:barbell/features/workout/controller/get_all_workout_controller.dart';
import 'package:barbell/features/workout/controller/get_workout_by_id_controller.dart';
import 'package:barbell/features/workout/controller/workout_perform_controller.dart';
import 'package:barbell/features/workout/widgets/rest_timer_bottomsheet.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkCaller());
    AppService.initializeNetworkDependentServices();

    // Initialize notification badge controller early
    Get.put(NotificationBadgeController());

    // profile (must be registered before others that depend on it)
    Get.put(ProfileController());

    // workout setup
    Get.put(GetWorkoutSetupController());
    Get.put(WorkoutSetupController());

    // Initialize network-dependent services now that NetworkCaller is available

    // common controllers
    Get.put(ObscureController());

    // Home controllers
    Get.put(HomeController());

    // auth controllers
    Get.put(CreateAccountController());

    // tips tab
    Get.put(LoginController());
    Get.put(CustomBottomNavBarController());
    Get.put(ArticleController());

    // food logging
    Get.put(FoodImageController());
    Get.put(FoodLoggingController());
    Get.put(LoggedFoodController());
    Get.put(GetAllFoodsController());
    Get.put(AddConsumedFoodController());
    Get.put(AddFoodManuallyController());
    Get.put(DeleteFoodController());
    Get.put(EditFoodController());

    // food analysis
    Get.put(FoodAnalysisSummaryController());

    /// ---------- habits ----------
    Get.put(GetHabitController());
    Get.put(CreateHabitController());
    Get.put(GetMyHabitController());
    Get.put(WeeklyHabitsController());
    Get.put(HabitStateController());
    Get.put(AddOrUpdateMyHabitController());
    Get.put(DeleteHabitController());
    Get.put(DeleteMyHabitController());

    // workout
    Get.put(RestTimerController());
    Get.put(GetAllWorkoutController());
    Get.put(DeleteWorkoutController());
    Get.put(GetWorkoutByIdController());
    Get.put(WorkoutPerformController());
    Get.put(ExerciseAnalysisController());

    // Notification
    Get.put(GetNotificationBellController());
    Get.put(NotificationController());
    Get.put(GetAllNotificationController());
    Get.put(DeleteNotificationController());

    ///
    Get.put(CustomBottomNavBarController());
    Get.put(GetNotificationBellController());
    Get.put(WeeklyHabitsController());
    Get.put(HabitStateController());
    Get.put(GetHabitController());
  }
}
