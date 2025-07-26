import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerUIController extends GetxController {
  late MobileScannerController cameraController;
  final isInitialized = false.obs;
  final isFlashOn = false.obs;
  final isFrontCamera = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeScanner();
  }

  @override
  void onClose() {
    if (isInitialized.value) {
      cameraController.dispose();
    }
    super.onClose();
  }

  Future<void> initializeScanner() async {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    isInitialized.value = true;
  }

  void toggleFlash() {
    if (isInitialized.value) {
      cameraController.toggleTorch();
      isFlashOn.toggle();
    }
  }

  void toggleCamera() {
    if (isInitialized.value) {
      cameraController.switchCamera();
      isFrontCamera.toggle();
    }
  }
}
