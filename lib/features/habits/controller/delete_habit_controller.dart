import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';

class DeleteHabitController extends GetxController {
  bool _isLoading = false;
  String _habitId = '';
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get habitId => _habitId;
  String get errorMessage => _errorMessage;

  Future<bool> deleteHabit(String habitId) async {
    _isLoading = true;
    _habitId = habitId;
    bool isSucces = false;
    update();

    final response = await Get.find<NetworkCaller>().deleteRequest(
      Urls.deleteHabit(habitId),
    );
    if (response.isSuccess) {
      isSucces = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Failed to delete habit';
      isSucces = false;
    }
    _isLoading = false;
    _habitId = '';
    update();
    return isSucces;
  }
}
