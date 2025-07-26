import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';
import 'package:barbell/features/food_logging/view/barcode_scanner_screen.dart';
import 'package:barbell/features/food_logging/view/food_list_screen.dart';
import 'package:barbell/features/food_logging/widgets/food_entry_option_card.dart';

class AddConsumedFoodScreen extends StatelessWidget {
  const AddConsumedFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodImageController imageController = Get.find<FoodImageController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      appBar: AppBarWidget(title: 'Add Consumed Food', showNotification: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              FoodEntryOptionCard(
                isManualEntry: true,
                title: 'Add From Food List',
                description:
                    'Enter food details, calories, macros, and portion size.',
                iconPath: SvgPath.manualEntrySvg,
                buttonText: 'Go to Food List',
                onTap: () => Get.to(() => const FoodListScreen()),
              ),
              FoodEntryOptionCard(
                title: 'Snap Photo',
                description:
                    'Use your camera to log food. AI will estimate nutrition.',
                iconPath: SvgPath.cameraSvg,
                buttonText: 'Take Photo',
                onTap: () async {
                  await imageController.takePhoto();
                },
              ),
              FoodEntryOptionCard(
                title: 'Scan Barcode or QR Code',
                description:
                    'Scan food packaging barcode or QR code to auto-fill nutrition info.',
                iconPath: SvgPath.barcodeSvg,
                buttonText: 'Scan',
                onTap: () {
                  // Get.to(() => const BarQrCodeScanScreen());
                  Get.to(() => const BarcodeScannerScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
