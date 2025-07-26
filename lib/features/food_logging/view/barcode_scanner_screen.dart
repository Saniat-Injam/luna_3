import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/barcode_scanner_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with TickerProviderStateMixin {
  Barcode? _barcode;
  final BarcodeScannerController _controller = Get.put(
    BarcodeScannerController(),
  );
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Scanning control
  bool _isScanning = true;
  bool _hasFoundData = false;

  // Timeout mechanism
  Timer? _timeoutTimer;
  static const int _scanTimeoutSeconds = 20;

  // Mobile scanner controller for flash and camera switching
  final MobileScannerController _mobileScannerController = MobileScannerController();
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.repeat(reverse: true);

    // Start timeout timer
    _startTimeoutTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeoutTimer() {
    // Start timeout timer
    _timeoutTimer = Timer(Duration(seconds: _scanTimeoutSeconds), () {
      if (mounted && !_hasFoundData) {
        EasyLoading.showError(
          'No product found. Please try again or add manually.',
          duration: const Duration(seconds: 2),
        );
        Get.back();
      }
    });
  }

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const SizedBox();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Barcode/QR Code Detected:',
          style: TextStyle(color: AppColors.textDescription, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    // Don't process if we're not scanning or already found data
    if (!_isScanning || _hasFoundData) return;

    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
        debugPrint('Barcode detected: ${_barcode?.displayValue}');

        if (_barcode != null &&
            _barcode!.displayValue != null &&
            _barcode!.displayValue!.isNotEmpty &&
            _barcode!.displayValue!.length >= 3) {
          // Stop scanning to prevent multiple calls
          _isScanning = false;
          _hasFoundData = true;

          // Cancel timers
          _timeoutTimer?.cancel();

          // Call the controller's method to handle the barcode
          _controller.handleBarcodeScan(_barcode!.displayValue!);
        } else {
          debugPrint('No valid code detected.');
          EasyLoading.showError(
            'Please scan a valid barcode or QR code',
            duration: const Duration(seconds: 2),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode or QR Code'),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textTitle,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _mobileScannerController,
            onDetect: _handleBarcode,
          ),

          // Scanning frame overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Align barcode or QR code within the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.secondary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          Positioned(
                            top: _animation.value * 130,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.secondary,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFlashOn = !_isFlashOn;
                            _mobileScannerController.toggleTorch();
                          });
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: Icon(
                          _isFrontCamera
                              ? Icons.camera_front
                              : Icons.camera_rear,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFrontCamera = !_isFrontCamera;
                            _mobileScannerController.switchCamera();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 300, child: _barcodePreview(_barcode)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class BarcodeScannerScreen extends GetView<BarcodeScannerController> {
//   static const routeName = '/barcode-scanner';
//   const BarcodeScannerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final scannerUIController = Get.put(ScannerUIController());
//     final controller = Get.put(BarcodeScannerController());
//     final screenSize = MediaQuery.of(context).size;
//     final scanWindow = screenSize.width * 0.85;

//     return Scaffold(
//       backgroundColor: AppColors.background,

//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: CustomAppBar(
//                 title: 'Scan Barcode',
//                 showBackButton: true,
//                 onBackPressed: () => Get.back(),
//                 actions: [
//                   Obx(() {
//                     if (!scannerUIController.isInitialized.value) {
//                       return const SizedBox();
//                     }
//                     return IconButton(
//                       icon: Icon(
//                         scannerUIController.isFlashOn.value
//                             ? Icons.flash_on
//                             : Icons.flash_off,
//                         color: Colors.white,
//                       ),
//                       onPressed: scannerUIController.toggleFlash,
//                     );
//                   }),
//                   Obx(() {
//                     if (!scannerUIController.isInitialized.value) {
//                       return const SizedBox();
//                     }
//                     return IconButton(
//                       icon: Icon(
//                         scannerUIController.isFrontCamera.value
//                             ? Icons.camera_front
//                             : Icons.camera_rear,
//                         color: Colors.white,
//                       ),
//                       onPressed: scannerUIController.toggleCamera,
//                     );
//                   }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Obx(() {
//                     if (!scannerUIController.isInitialized.value) {
//                       return const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       );
//                     }
//                     return MobileScanner(
//                       controller: scannerUIController.cameraController,
//                       onDetect: (capture) {
//                         final List<Barcode> barcodes = capture.barcodes;
//                         if (barcodes.isNotEmpty) {
//                           final String? code = barcodes.first.rawValue;
//                           if (code != null) {
//                             controller.handleBarcodeScan(code);
//                           }
//                         }
//                       },
//                     );
//                   }),
//                   CustomPaint(
//                     painter: ScannerOverlay(scanWindow),
//                     child: const SizedBox.expand(),
//                   ),
//                   Positioned(
//                     bottom: 40,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                         'Align barcode within the frame',
//                         style: TextStyle(
//                           color: Colors.white.withValues(alpha: 0.8),
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Obx(() {
//                     if (controller.isLoading) {
//                       return Container(
//                         color: Colors.black54,
//                         child: const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         ),
//                       );
//                     }
//                     return const SizedBox();
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ScannerOverlay extends CustomPainter {
//   final double scanWindow;

//   ScannerOverlay(this.scanWindow);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Colors.black54
//           ..style = PaintingStyle.fill;

//     final windowRect = Rect.fromCenter(
//       center: Offset(size.width / 2, size.height / 2),
//       width: scanWindow,
//       height: scanWindow / 2, // Make it rectangular for barcode scanning
//     );

//     // Draw semi-transparent overlay
//     canvas.drawPath(
//       Path.combine(
//         PathOperation.difference,
//         Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
//         Path()..addRRect(
//           RRect.fromRectAndRadius(windowRect, const Radius.circular(12)),
//         ),
//       ),
//       paint,
//     );

//     // Draw scan window border
//     final borderPaint =
//         Paint()
//           ..color = AppColors.secondary
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 3;

//     // Draw corner markers
//     final cornerLength = scanWindow * 0.1;
//     final cornerPath = Path();

//     // Top-left corner
//     cornerPath.moveTo(windowRect.left, windowRect.top + cornerLength);
//     cornerPath.lineTo(windowRect.left, windowRect.top);
//     cornerPath.lineTo(windowRect.left + cornerLength, windowRect.top);

//     // Top-right corner
//     cornerPath.moveTo(windowRect.right - cornerLength, windowRect.top);
//     cornerPath.lineTo(windowRect.right, windowRect.top);
//     cornerPath.lineTo(windowRect.right, windowRect.top + cornerLength);

//     // Bottom-left corner
//     cornerPath.moveTo(windowRect.left, windowRect.bottom - cornerLength);
//     cornerPath.lineTo(windowRect.left, windowRect.bottom);
//     cornerPath.lineTo(windowRect.left + cornerLength, windowRect.bottom);

//     // Bottom-right corner
//     cornerPath.moveTo(windowRect.right - cornerLength, windowRect.bottom);
//     cornerPath.lineTo(windowRect.right, windowRect.bottom);
//     cornerPath.lineTo(windowRect.right, windowRect.bottom - cornerLength);

//     canvas.drawPath(cornerPath, borderPaint);

//     // Draw scan line animation
//     final scanLinePaint =
//         Paint()
//           ..shader = LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.secondary.withValues(alpha: 0.0),
//               AppColors.secondary.withValues(alpha: 0.8),
//               AppColors.secondary.withValues(alpha: 0.0),
//             ],
//           ).createShader(windowRect);

//     canvas.drawRect(
//       Rect.fromLTWH(
//         windowRect.left,
//         windowRect.top + (windowRect.height * 0.5),
//         windowRect.width,
//         3,
//       ),
//       scanLinePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
