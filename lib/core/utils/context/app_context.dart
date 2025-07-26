import 'package:flutter/material.dart';

class AppContext {
  static late BuildContext currentContext;

  static void init(BuildContext context) {
    currentContext = context;
  }
}
