import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppHelperFunctions {
  AppHelperFunctions._();
  // Show Error Snackbar
  static void showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  //show snack bar
  static void showSnackBar(String message) {
    Get.snackbar(
      'Message',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 3),
    );
  }

  //show alert
  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //navigate to screen
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  //truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  //is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  //screen size
  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  //screen height
  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  //screen width
  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  //get formatted date
  static String getFormattedDate(
    DateTime date, {
    String format = 'dd MMM yyyy',
  }) {
    return DateFormat(format).format(date);
  }

  //remove duplicates
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  //wrap widgets
  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
        i,
        i + rowSize > widgets.length ? widgets.length : i + rowSize,
      );
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }
}
