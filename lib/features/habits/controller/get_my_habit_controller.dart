import 'package:get/get.dart';
import 'package:barbell/core/services/network_caller.dart';
import 'package:barbell/core/utils/constants/api_constants.dart';
import 'package:barbell/features/habits/model/my_habit_model.dart';

class GetMyHabitController extends GetxController {
  final List<MyHabitModel> _myHabits = [];
  List<MyHabitModel> get myHabits => _myHabits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<bool> getMyHabits() async {
    _isLoading = true;
    bool isSucces = false;
    update();

    final response = await Get.find<NetworkCaller>().getRequest(
      url: Urls.getUserHabits,
    );
    if (response.isSuccess) {
      final List<dynamic> data = response.responseData['data'];
      _myHabits.clear();
      _myHabits.addAll(
        data.map<MyHabitModel>((e) => MyHabitModel.fromJson(e)).toList(),
      );
      isSucces = true;
    }
    _isLoading = false;
    update();
    return isSucces;
  }
}
