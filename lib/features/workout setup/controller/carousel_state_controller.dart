import 'package:get/get.dart';

class CarouselStateController extends GetxController {
  var currentIndex = 0.obs;

  final List<String> imageList = [
    'assets/images/gym1.png',
    'assets/images/gym1.png',
    'assets/images/gym1.png',
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
