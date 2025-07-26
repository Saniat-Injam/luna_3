import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/workout/model/all_workout_model.dart';
import 'package:logger/logger.dart';

class GetWorkoutByIdController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  WorkoutModel? workout;

  final RxList<String> performColumns = ['SET', 'lbs', 'REPS', 'START'].obs;

  Future<void> getWorkoutById(String id) async {
    _isLoading = true;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getExerciseById(id),
    );

    if (response.isSuccess) {
      workout = WorkoutModel.fromJson(response.responseData['data']);
      if (workout?.weightLifted == 'false') {
        performColumns.remove('lbs');
      } else if (!performColumns.contains('lbs')) {
        performColumns.insert(1, 'lbs');
      }
      update(); // Notify listeners about data change
    } else {
      EasyLoading.showError('Failed to fetch workout');
      Logger().e('Failed to fetch workout: ${response.errorMessage}');
    }

    _isLoading = false;
    update(); // Notify listeners about data change
  }
}
