import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:barbell/features/food_logging/controllers/add_consumed_food_controller.dart';
import 'package:barbell/features/food_logging/models/scanned_product_response_model.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';

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
  static void showNutritionDataDialog(ScannedProductResponseModel data) {
    // Create a controller to get the quantity value
    final quantityController = TextEditingController(
      text:
          data.product?.productQuantity ?? data.product?.servingQuantity ?? '',
    );

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
                  // Header with image or success icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      data.product?.imageUrl ??
                          'https://via.placeholder.com/150',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green.shade500,
                            size: 24,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Product name
                  Text(
                    data.product?.productName ?? 'Unknown Product',
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
                        // Calories as header box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.orange,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                (data.product?.nutriments?.energyKcal100g ?? 0)
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'kcal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Protein & Carbs row
                        Row(
                          children: [
                            _buildModernNutritionCard(
                              'Protein',
                              ((data.product?.nutriments?.proteins100g ?? 0)
                                      .toDouble())
                                  .toStringAsFixed(2),
                              'g',
                              Colors.red,
                            ),
                            const SizedBox(width: 8),
                            _buildModernNutritionCard(
                              'Carbs',
                              ((data.product?.nutriments?.carbohydrates100g ??
                                          0)
                                      .toDouble())
                                  .toStringAsFixed(2),
                              'g',
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Fat & Fiber row
                        Row(
                          children: [
                            _buildModernNutritionCard(
                              'Fat',
                              ((data.product?.nutriments?.fat100g ?? 0)
                                      .toDouble())
                                  .toStringAsFixed(2),
                              'g',
                              Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            _buildModernNutritionCard(
                              'Fiber',
                              ((data.product?.nutriments?.fiber100g ?? 0)
                                      .toDouble())
                                  .toStringAsFixed(2),
                              'g',
                              Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Product quantity input
                  _ProductQuantityInput(
                    controller: quantityController,
                    initialValue:
                        data.product?.productQuantity ??
                        data.product?.servingQuantity ??
                        '',
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
                          onPressed: () async {
                            // Get the current quantity from the input field
                            final quantityInput = quantityController.text;
                            final quantity =
                                double.tryParse(quantityInput) ??
                                double.tryParse(
                                  data.product?.servingQuantity ?? '',
                                ) ??
                                100.0;

                            // Calculate nutrition values based on quantity (per 100g to actual quantity)
                            final multiplier = quantity / 100.0;

                            final nutritionPerServing = {
                              'calories':
                                  ((data.product?.nutriments?.energyKcal100g ??
                                              0) *
                                          multiplier)
                                      .round(),
                              'protein':
                                  ((data.product?.nutriments?.proteins100g ??
                                              0) *
                                          multiplier)
                                      .round(),
                              'carbs':
                                  ((data
                                                  .product
                                                  ?.nutriments
                                                  ?.carbohydrates100g ??
                                              0) *
                                          multiplier)
                                      .round(),
                              'fats':
                                  ((data.product?.nutriments?.fat100g ?? 0) *
                                          multiplier)
                                      .round(),
                              'fiber':
                                  ((data.product?.nutriments?.fiber100g ?? 0) *
                                          multiplier)
                                      .round(),
                            };

                            final servings =
                                1; // Since we're calculating for the exact quantity

                            // Call addConsumedFoodByScan
                            final addResult =
                                await Get.find<AddConsumedFoodController>()
                                    .addConsumedFoodByScan(
                                      nutritionPerServing: nutritionPerServing,
                                      servings: servings,
                                    );

                            if (addResult) {
                              // Reload nutrition data for NutritionCard
                              await Get.find<HomeController>()
                                  .getFoodAnalysisProgress();
                            }

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
                            'Add',
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

class _ProductQuantityInput extends StatefulWidget {
  final String initialValue;
  final TextEditingController? controller;

  const _ProductQuantityInput({
    required this.initialValue,
    this.controller,
  });

  @override
  State<_ProductQuantityInput> createState() => _ProductQuantityInputState();
}

class _ProductQuantityInputState extends State<_ProductQuantityInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _controller = widget.controller ?? TextEditingController();

    // Parse number from initial value if it exists and set it
    String parsedValue = widget.initialValue;
    if (parsedValue.isNotEmpty) {
      // Extract numbers from the string (e.g., "100g" -> "100")
      final regex = RegExp(r'\d+');
      final match = regex.firstMatch(parsedValue);
      if (match != null) {
        parsedValue = match.group(0)!;
      }
    }

    // Only set text if we're using our own controller
    if (widget.controller == null) {
      _controller.text = parsedValue;
    } else {
      // If external controller is provided, update its text
      _controller.text = parsedValue;
    }
  }

  @override
  void dispose() {
    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Quantity',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter quantity in grams',
              suffixText: 'g',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
