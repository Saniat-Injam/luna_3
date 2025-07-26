import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BarcodeScannerDialogs {
  /// Shows a dialog when no nutrition data is found for a generic barcode
  static void showNoNutritionFoundDialog(String barcode) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade500,
            size: 32,
          ),
        ),
        title: const Text(
          'Barcode Not Supported',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This type of barcode is not supported for nutrition lookup.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Code: $barcode',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }

  /// Shows a dialog when nutrition data is found for a barcode
  static void showNutritionDataDialog({
    required String productName,
    required Map<String, dynamic> nutriments,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 600,
            maxWidth: 380,
            minWidth: 320,
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with success icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green.shade500,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Product name
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    'Nutrition Facts (per 100g)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Modern nutrition grid
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildModernNutritionCard(
                              'Calories',
                              '${nutriments['energy-kcal_100g'] ?? 0}',
                              'kcal',
                              Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            _buildModernNutritionCard(
                              'Carbs',
                              '${nutriments['carbohydrates_100g'] ?? 0}',
                              'g',
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildModernNutritionCard(
                              'Protein',
                              '${nutriments['proteins_100g'] ?? 0}',
                              'g',
                              Colors.red,
                            ),
                            const SizedBox(width: 8),
                            _buildModernNutritionCard(
                              'Fat',
                              '${nutriments['fat_100g'] ?? 0}',
                              'g',
                              Colors.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildModernNutritionCard(
                              'Fiber',
                              '${nutriments['fiber_100g'] ?? 0}',
                              'g',
                              Colors.green,
                            ),
                            const SizedBox(width: 8),
                            // Empty expanded to center the fiber card
                            Expanded(child: Container()),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            EasyLoading.showSuccess(
                              'Food added to your log successfully!',
                              duration: const Duration(seconds: 2),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Added!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a simple dialog when nutrition data is not found for a barcode
  static void showSimpleNoNutritionFoundDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.info_outline_rounded,
            color: Colors.orange.shade500,
            size: 32,
          ),
        ),
        title: const Text(
          'No Nutrition Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'No nutrition information found for this barcode.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }

  /// Helper method to build modern nutrition cards
  static Widget _buildModernNutritionCard(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getNutritionIcon(label), color: color, size: 14),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to get appropriate icons for nutrition types
  static IconData _getNutritionIcon(String label) {
    switch (label.toLowerCase()) {
      case 'calories':
        return Icons.local_fire_department_rounded;
      case 'carbs':
        return Icons.grain_rounded;
      case 'protein':
        return Icons.fitness_center_rounded;
      case 'fat':
        return Icons.water_drop_rounded;
      case 'fiber':
        return Icons.eco_rounded;
      default:
        return Icons.circle;
    }
  }
}
