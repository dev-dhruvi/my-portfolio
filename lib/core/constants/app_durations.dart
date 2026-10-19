import 'package:flutter/animation.dart';

/// Centralized animation durations and curves.
class AppDurations {
  AppDurations._();

  static const Duration quick = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration relaxed = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration heroLoop = Duration(milliseconds: 3000);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve bounce = Curves.easeOutBack;
}
