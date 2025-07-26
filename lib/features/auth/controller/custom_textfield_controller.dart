import 'package:get/get.dart';

class CustomTextFieldController extends GetxController {
  var isObscured = true.obs;

  void toggleObscured() {
    isObscured.value = !isObscured.value;
  }
}