import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';

class NotificationToggleRow extends StatelessWidget {
  final String title;
  final String leadingIcon;

  const NotificationToggleRow({
    super.key,
    required this.title,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(
                leadingIcon,
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    leadingIcon,
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Obx(() {
            return GestureDetector(
              onTap:
                  profileController.isNotificationToggling.value
                      ? null
                      : () {
                        // Toggle the state immediately for smooth UI
                        final newState =
                            !profileController.isNotificationEnabled.value;
                        profileController.isNotificationEnabled.value =
                            newState;

                        // Call the API
                        profileController.toggleNotification(newState);
                      },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color:
                          profileController.isNotificationEnabled.value
                              ? const Color(0xFFEAFF55)
                              : Colors.grey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            profileController.isNotificationEnabled.value
                                ? const Color(0xFFEAFF55)
                                : Colors.grey.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (profileController.isNotificationEnabled.value)
                          const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!profileController.isNotificationEnabled.value)
                          const Spacer(),
                      ],
                    ),
                  ),
                  // Loading indicator overlay
                  if (profileController.isNotificationToggling.value)
                    Container(
                      width: 50,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
