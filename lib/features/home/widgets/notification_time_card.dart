import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/habits/controller/weekly_habits_controller.dart';

class NotificationAndTimeCard extends StatelessWidget {
  final WeeklyHabitsController controller;

  const NotificationAndTimeCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _buildNotificationToggle(),
          _buildDivider(),
          _buildReminderTime(),
          _buildDivider(),
          _buildReminderInterval(),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: AppColors.textWhite.withValues(alpha: .28),
      thickness: 0.9,
      height: 32,
    );
  }

  Widget _buildReminderInterval() {
    return Row(
      children: [
        Text(
          'reminderInterval',
          style: getTextStyleWorkSans(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: Sizer.wp(120),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controller.reminderIntervalController,
            textAlign: TextAlign.center,
            style: AppTextStyle.f16W400().copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              suffix: const Text('mins'),
              fillColor: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Push notifications',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Habit reminders turned on',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Notification toggle
          Switch.adaptive(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeTrackColor: AppColors.secondary.withValues(alpha: 0.5),
            activeColor: AppColors.secondary,
            inactiveTrackColor: AppColors.textWhite.withValues(alpha: 0.2),
            inactiveThumbColor: AppColors.textWhite.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.secondary;
              }
              return AppColors.textWhite;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
              return Colors.transparent;
            }),
            value: controller.isNotificationEnabled.value,
            onChanged: controller.toggleNotification,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTime() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reminder time',
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () => _showTimePicker(Get.context!, controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                controller.getFormattedTime(),
                style: getTextStyleWorkSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    WeeklyHabitsController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.appbar,
              hourMinuteTextColor: AppColors.textWhite,
              dialBackgroundColor: AppColors.background,
              dialTextColor: AppColors.textWhite,
              dialHandColor: AppColors.primary,
              entryModeIconColor: AppColors.textWhite,
              dayPeriodColor: AppColors.background,
              dayPeriodTextColor: AppColors.textWhite,
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(AppColors.textWhite),
                textStyle: WidgetStateProperty.all(
                  getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(AppColors.textWhite),
                textStyle: WidgetStateProperty.all(
                  getTextStyleWorkSans(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              dayPeriodTextStyle: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              helpTextStyle: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              hourMinuteTextStyle: getTextStyleWorkSans(
                color: AppColors.textWhite,
                fontSize: 38,
                fontWeight: FontWeight.w500,
              ),
              hourMinuteColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.updateTime(picked);
    }
  }
}
