import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';

/// Screen form factor enumeration for responsive layout logic.
enum ScreenType { mobile, tablet, desktop }

/// Blueprint responsive layout switcher that isolates responsiveness logic
/// into a clean, reusable widget. Chooses between mobile, tablet, and desktop
/// variants based on the parent's actual box constraints via LayoutBuilder.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Breakpoints based on standard screen widths
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1100;

  /// Helper to dynamically scale typography between a lower and upper clamp boundary.
  static double dynamicFontSize(
    BuildContext context, {
    double factor = 0.015,
    double min = 14.0,
    double max = 24.0,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * factor).clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// A builder variant of ResponsiveLayout providing parent constraints and active ScreenType.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    ScreenType screenType,
  ) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ScreenType type;
        if (constraints.maxWidth >= 1100) {
          type = ScreenType.desktop;
        } else if (constraints.maxWidth >= 600) {
          type = ScreenType.tablet;
        } else {
          type = ScreenType.mobile;
        }
        return builder(context, constraints, type);
      },
    );
  }
}

/// Centers child content and applies maximum width bounds and responsive padding.
class ResponsiveContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContentContainer({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(context);
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: isMobile ? 16.0 : (screenWidth < 1200 ? 24.0 : 32.0),
      vertical: 0.0,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding ?? defaultPadding, child: child),
      ),
    );
  }
}
