import 'package:flutter/material.dart';

class SetModel {
  String set;
  TextEditingController? kg;
  TextEditingController reps;
  bool started;

  SetModel({
    required this.set,
    this.kg,
    required this.reps,
    this.started = false,
  });
}
