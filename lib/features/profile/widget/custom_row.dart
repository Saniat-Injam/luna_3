import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class ToggleController extends GetxController {
  var isOn = false.obs;

  void toggle() {
    isOn.value = !isOn.value;
  }
}

class CustomRow extends StatelessWidget {
  final String title;
  final String leadingIcon;
  final String? trailingIcon;
  final VoidCallback? onTap;
  const CustomRow({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingIcon,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final ToggleController controller = Get.put(ToggleController());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
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
              SizedBox(width: 12),
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
          Spacer(),
          if (trailingIcon != null && trailingIcon!.isNotEmpty)
            GestureDetector(
              onTap: onTap,
              child: Image.asset(trailingIcon!, height: 24, width: 24),
            )
          else
            GestureDetector(
              onTap: controller.toggle,
              child: Obx(() {
                return Container(
                  width: 40,
                  height: 22,
                  decoration: BoxDecoration(
                    color:
                        controller.isOn.value
                            ? Color(0xFFEAFF55)
                            : Colors.grey.withAlpha(128),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      if (controller.isOn.value) Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      if (!controller.isOn.value) Spacer(),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
