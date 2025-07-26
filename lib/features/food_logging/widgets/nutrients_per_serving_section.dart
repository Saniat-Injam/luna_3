import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/food_logging/controllers/add_food_manually_controller.dart';

class NutrientsPerServingSection extends StatelessWidget {
  const NutrientsPerServingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addFoodManuallyController = Get.find<AddFoodManuallyController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      // margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrients per serving',
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          _buildPerServicingRow(
            title: 'Energy',
            controller: addFoodManuallyController.energyController,
            isDisabled: true,
          ),
          Divider(color: const Color(0xff747474)),
          _buildPerServicingRow(
            title: 'Carbs',
            controller: addFoodManuallyController.carbsController,
          ),
          _buildPerServicingRow(
            title: 'Protein',
            controller: addFoodManuallyController.proteinController,
          ),
          _buildPerServicingRow(
            title: 'Fat',
            controller: addFoodManuallyController.fatController,
          ),
          _buildPerServicingRow(
            title: 'Fiber',
            controller: addFoodManuallyController.fiberController,
          ),
        ],
      ),
    );
  }

  Widget _buildPerServicingRow({
    required String title,
    required TextEditingController controller,
    bool isDisabled = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: getTextStyleWorkSans(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty && double.tryParse(value) == null) {
                controller.text = controller.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
              }
              Get.find<AddFoodManuallyController>().calculateEnergy();
            },
            textAlign: TextAlign.end,
            textAlignVertical: TextAlignVertical.center,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textDecoration: TextDecoration.none,
            ),
            controller: controller,
            readOnly: isDisabled,
            decoration: InputDecoration(
              hintText: '$title in grams',
              hintStyle: getTextStyleWorkSans(
                textAlign: TextAlign.end,
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              suffix: Text(
                isDisabled ? ' Cal' : ' g',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
