import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;
  final Size size;

  ResponsiveHelper(this.context) : size = MediaQuery.of(context).size;

  bool get isSmallPhone => size.width <=360;
  bool get isMediumPhone => size.width > 362 && size.width < 414;
  bool get isLargePhone => size.width >= 414;

  double fromSmallMediumLarge({
    required double small,
    required double medium,
    required double large,
  }) {
    if (isSmallPhone) return small;
    if (isMediumPhone) return medium;
    return large;
  }
}
