import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A sleek, high-end scroll progress bar that tracks the reading and scroll
/// progression across the entire page (0.0 -> 1.0).
///
/// Inspired by modern creative studios (e.g. eezyinn.de, Awwwards portfolios),
/// providing a subtle, luminous indicator at the top of the viewport.
class ScrollProgressIndicator extends StatelessWidget {
  final ScrollController scrollController;
  final double height;
  final List<Color>? gradientColors;

  const ScrollProgressIndicator({
    super.key,
    required this.scrollController,
    this.height = 2.5,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultColors = [
      AppColors.cyanPrimary,
      AppColors.violetPrimary,
      const Color(0xFFD946EF), // Magenta accent
    ];
    final colors = gradientColors ?? defaultColors;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: scrollController,
        builder: (context, _) {
          double progress = 0.0;
          if (scrollController.hasClients &&
              scrollController.positions.length == 1 &&
              scrollController.position.hasContentDimensions &&
              scrollController.position.maxScrollExtent > 0) {
            progress =
                (scrollController.offset /
                        scrollController.position.maxScrollExtent)
                    .clamp(0.0, 1.0);
          }

          if (disableAnimations) {
            return const SizedBox.shrink();
          }

          return Container(
            height: height,
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isDark
                                  ? AppColors.cyanPrimary
                                  : AppColors.violetPrimary)
                              .withOpacity(0.55),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
