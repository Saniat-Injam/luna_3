import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/barbell_llm/controllers/barbell_llm_controller.dart';

class WorkoutPlanForm extends StatelessWidget {
  final BarbellLLMController controller;

  const WorkoutPlanForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        children: [
          // Fitness Goal Field
          _buildInputField(
            controller: controller.fitnessGoalController,
            hintText: 'e.g. strength, hypertrophy, endurance',
            label: 'Fitness goal',
            icon: SvgPath.fitnessgoalSvg,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Fitness goal is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Experience Level Dropdown
          _buildExperienceLevelDropdown(controller),
          const SizedBox(height: 20),

          // Available Equipment Field
          _buildInputField(
            controller: controller.equipmentController,
            hintText: 'e.g. dumbbells, barbell,bands',
            label: 'Available equipment',
            icon: SvgPath.availableEquipmentSvg,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Equipment is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Days Per Week Dropdown
          _buildDaysPerWeekDropdown(controller),
          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.generatePlan();
              }
            },
            child: const Text(
              'Generate Plan',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required String icon,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyleWorkSans(color: AppColors.textWhite, fontSize: 18),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          style: getTextStyleWorkSans(color: AppColors.textWhite, fontSize: 16),
          decoration: InputDecoration(
            fillColor: AppColors.background,
            hintText: hintText,
            hintStyle: getTextStyleWorkSans(
              color: const Color(0xff8B8B8B),
              fontSize: 14,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(icon, width: 24, height: 24),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.border, width: 0.9),
              gapPadding: 0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.border, width: 0.9),
              gapPadding: 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.border, width: 0.9),
              gapPadding: 0,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 0.9),
              gapPadding: 0,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 0.9),
              gapPadding: 0,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          ),
        ),
      ],
    );
  }

  /// Build experience level dropdown widget
  Widget _buildExperienceLevelDropdown(BarbellLLMController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience level',
          style: getTextStyleWorkSans(color: AppColors.textWhite, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textWhite,
                  size: 26,
                ),
                value: controller.selectedExperienceLevel.value,
                isExpanded: true,

                dropdownColor: AppColors.background,
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 16,
                ),
                items:
                    controller.experienceLevelOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.substring(0, 1).toUpperCase() +
                              value.substring(1),
                          style: getTextStyleWorkSans(
                            color: AppColors.textWhite,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.updateExperienceLevel(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build days per week dropdown widget
  Widget _buildDaysPerWeekDropdown(BarbellLLMController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Days per week',
          style: getTextStyleWorkSans(color: AppColors.textWhite, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textWhite,
                  size: 26,
                ),
                value: controller.selectedDaysPerWeek.value,
                isExpanded: true,
                dropdownColor: AppColors.background,
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 16,
                ),
                items:
                    controller.daysPerWeekOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value days',
                          style: getTextStyleWorkSans(
                            color: AppColors.textWhite,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.updateDaysPerWeek(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
