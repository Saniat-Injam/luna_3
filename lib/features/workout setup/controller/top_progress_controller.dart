// features/workout setup/controller/top_progress_controller.dart
import 'package:get/get.dart';

class TopProgressController extends GetxController {
  RxInt currentStep = 1.obs;

  void goToNextStep() {
    if (currentStep < 6) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep > 1) {
      currentStep.value--;
    }
  }
}