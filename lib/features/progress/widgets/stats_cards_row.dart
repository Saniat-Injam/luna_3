import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';

class StatsCardsRow extends StatelessWidget {
  final ProgressController controller;

  const StatsCardsRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(
          icon: SvgPath.caloriesSvg,
          label: 'CALORIES',
          value: controller.calories,
          unit: '',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          icon: SvgPath.fatsSvg,
          label: 'FATS',
          value: controller.fats,
          unit: 'g',
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          icon: SvgPath.proteinsSvg,
          label: 'PROTEINS',
          value: controller.proteins,
          unit: 'g',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String label,
    required RxInt value,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border, width: .52),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            SvgPicture.asset(icon, width: 60, height: 60),
            Obx(
              () => Text(
                '${value.value}$unit',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: getTextStyleWorkSans(
                color: const Color(0xffA2A6AB),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
