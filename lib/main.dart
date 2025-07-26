import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:barbell/app.dart';
import 'package:barbell/core/services/app_service.dart';
import 'package:barbell/firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay for status bar visibility
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness:
          Brightness.light, // Light icons for dark background
      statusBarBrightness: Brightness.dark, // For iOS
      systemNavigationBarColor: Color(0xff121400), // Match app background
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize timezone data for scheduled notifications
  tz.initializeTimeZones();

  // Initialize App Services (Professional Way)
  await AppService.initializeApp();

  runApp(const Barbell());
  EasyLoading.init();
}
