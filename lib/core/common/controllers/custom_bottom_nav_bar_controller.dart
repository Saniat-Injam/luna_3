import 'package:barbell/features/workout/view/all_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/features/home/view/home_navigation.dart';
import 'package:barbell/features/profile/view/profile_screen.dart';
import 'package:barbell/features/progress/views/nutrition_progress_screen.dart';
import 'package:barbell/features/tips/view/tips_screen.dart';

class CustomBottomNavBarController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomeNavigation(),
    TipsScreen(),
    AllWorkoutScreen(isBottomNav: false),
    NutritionProgressScreen(),
    ProfileScreen(),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
