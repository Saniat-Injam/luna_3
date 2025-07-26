import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/habits/model/habit_model.dart';

class GetHabitController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<HabitModel> _habits = [];
  List<HabitModel> get habits => _habits;

  Future<bool> getHabits() async {
    _isLoading = true;
    bool isSucces = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getHabit,
    );
    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'];
      _habits.clear();
      _habits.addAll(data.map((e) => HabitModel.fromJson(e)).toList());
      isSucces = true;
    }
    _isLoading = false;
    update();
    return isSucces;
  }
}
