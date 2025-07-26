import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/workout/model/all_workout_model.dart';
import 'package:logger/logger.dart';

class GetAllWorkoutController extends GetxController {
  List<WorkoutModel> _allWorkouts = <WorkoutModel>[];
  final List<WorkoutModel> _filteredWorkouts = <WorkoutModel>[];
  final RxString searchQuery = ''.obs;
  bool isLoading = false;

  List<WorkoutModel> get workoutList =>
      _filteredWorkouts.isNotEmpty || searchQuery.value.isNotEmpty
          ? _filteredWorkouts
          : _allWorkouts;
  List<WorkoutModel> get allWorkouts => _allWorkouts;

  Future<bool> getAllWorkout() async {
    isLoading = true;
    bool isSuccess = false;
    update(); // Notify listeners about loading state change

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getAllworkout,
    );

    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'];
      if (data.isEmpty) {
        EasyLoading.showInfo('No workouts found');
        isLoading = false;
        update(); // Notify listeners about data change
        return false;
      }

      _allWorkouts =
          data.map<WorkoutModel>((e) => WorkoutModel.fromJson(e)).toList();

      // Apply any existing search filter
      filterWorkouts();

      isSuccess = true;
    } else {
      isSuccess = false;
    }

    isLoading = false;
    update(); // Notify listeners about data change

    if (!isSuccess) {
      EasyLoading.showError('Failed to fetch workouts');
      Logger().e('Failed to fetch workouts: ${response.errorMessage}');
    }
    return isSuccess;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterWorkouts();
  }

  void filterWorkouts() {
    var workouts = _allWorkouts.toList();

    // Filter by search query (search in name, description, muscle group, and exercise type)
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      workouts =
          workouts.where((workout) {
            final name = (workout.name ?? '').toLowerCase();
            final description = (workout.description ?? '').toLowerCase();
            final muscleGroup =
                (workout.primaryMuscleGroup ?? '').toLowerCase();
            final exerciseType = (workout.exerciseType ?? '').toLowerCase();

            return name.contains(query) ||
                description.contains(query) ||
                muscleGroup.contains(query) ||
                exerciseType.contains(query);
          }).toList();
    }

    // Update filtered list
    _filteredWorkouts.clear();
    _filteredWorkouts.addAll(workouts);

    // Notify UI to update
    update();
  }

  void clearSearch() {
    searchQuery.value = '';
    filterWorkouts();
  }
}
