import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/workout%20setup/model/workout_setup_model.dart';

class GetWorkoutSetupController extends GetxController {
  bool _isLoading = false;
  String _message = '';
  WorkoutSetupModel? _workoutSetupModel;

  bool get isLoading => _isLoading;
  String get message => _message;
  WorkoutSetupModel? get workoutSetupModel => _workoutSetupModel;

  //* --------------- Retrive workout setup ----------------
  Future<bool> getWorkoutSetup() async {
    _isLoading = true;
    bool isSuccess = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getWorkoutSetup,
    );

    if (response.isSuccess) {
      _workoutSetupModel = WorkoutSetupModel.fromJson(
        response.responseData['data'],
      );
      await StorageService.saveIsWorkoutSettedup(true);
      isSuccess = true;
    } else {
      await StorageService.saveIsWorkoutSettedup(false);
      _message = response.errorMessage ?? 'Something went wrong';
      isSuccess = false;
    }
    _isLoading = false;
    update();
    return isSuccess;
  }
}
