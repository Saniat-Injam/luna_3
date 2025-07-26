import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:barbell/features/main_layout/view/main_layout.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomBottomNavBarController controller = Get.find();
    return Container(
      height: 108,
      decoration: const BoxDecoration(
        color: Color(0xFF1C2227),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: SafeArea(
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                'Home',
                'assets/icons/home.png',
                0,
                controller.selectedIndex.value,
                controller,
              ),
              _buildNavItem(
                'Tips',
                'assets/icons/tipstab.png',
                1,
                controller.selectedIndex.value,
                controller,
              ),
              _buildAddButton(controller),
              _buildNavItem(
                'Progress',
                'assets/icons/progress.png',
                3,
                controller.selectedIndex.value,
                controller,
              ),
              _buildNavItem(
                'Profile',
                'assets/icons/profile.png',
                4,
                controller.selectedIndex.value,
                controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    String imagePath,
    int index,
    int selectedIndex,
    CustomBottomNavBarController controller,
  ) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        controller.changePage(index);
        if (!isSelected) {
          Get.to(() => MainLayout());
        }
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEAFF55) : Color(0xFF2B2F33),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.black : Colors.white,
              fit: BoxFit.contain,
            ),
          ).paddingOnly(top: 15),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(CustomBottomNavBarController controller) {
    return InkWell(
      onTap: () => controller.changePage(2),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 40),
      ),
    );
  }
}
