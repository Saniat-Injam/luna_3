import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';

class DeleteWorkoutController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _workoutId = '';
  String get workoutId => _workoutId;

  Future<bool> deleteWorkout(String workoutId) async {
    _isLoading = true;
    bool isSuccess = false;
    _workoutId = workoutId;
    update();

    // Simulate a network call
    final response = await Get.find<NetworkCaller>().deleteRequest(
      Urls.deleteExercise(workoutId),
    );

    if (response.isSuccess) {
      isSuccess = true;
      update();
    } else {
      _errorMessage = 'Failed to delete workout';
    }

    _isLoading = false;
    _workoutId = '';
    update();
    return isSuccess;
  }
}
