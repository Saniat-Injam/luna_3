import 'package:flutter/material.dart';
import 'package:barbell/features/food_logging/models/food_calories_model.dart';
import 'package:barbell/features/food_logging/models/food_item.dart';
import 'package:barbell/features/food_logging/view/create_food_screen.dart';
import 'package:barbell/features/food_logging/view/food_details_screen.dart';
import 'package:barbell/features/food_logging/view/food_scan_details_screen.dart';
import 'package:barbell/features/habits/view/create_or_update_my_habit.dart';
import 'package:barbell/features/home/view/home_screen.dart';

class HomeNavigation extends StatelessWidget {
  const HomeNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget screen;
        if (settings.name == HomeScreen.routeName) {
          screen = HomeScreen();
          // } else if (settings.name == ChooseHabitsScreen.routeName) {
          //   screen = ChooseHabitsScreen();
        } else if (settings.name == CreateOrUpdateMyHabitScreen.routeName) {
          screen = CreateOrUpdateMyHabitScreen();
        } else if (settings.name == FoodDetailsScreen.routeName) {
          final foodItem = settings.arguments as FoodCaloriesModel;
          screen = FoodDetailsScreen(foodItem: foodItem);
        } else if (settings.name == FoodScanDetailsScreen.routeName) {
          final foodItem = settings.arguments as FoodItem;
          screen = FoodScanDetailsScreen(foodItem: foodItem);
        } else if (settings.name == CreateFoodScreen.routeName) {
          screen = CreateFoodScreen();
        } else {
          screen = HomeScreen();
        }
        return MaterialPageRoute(builder: (context) => screen);
      },
    );
  }
}
