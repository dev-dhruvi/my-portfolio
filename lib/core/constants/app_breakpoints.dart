import 'package:flutter/material.dart';

/// Screen size breakpoints for responsive web design.
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobileMax = 768;
  static const double tabletMax = 1024;
  static const double desktopMax = 1280;

  static const double maxContentWidth = 1200;
  static const double compactContentWidth = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileMax && width < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  static bool isCompactNav(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 1080;
}
