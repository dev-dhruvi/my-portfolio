import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Highly responsive, animated pagination indicator dots row.
/// Features dynamic dot count calculated from active viewport capacity,
/// expanding active indicator pill with neon gradient glow,
/// and smooth left/right arrow step navigation.
class DynamicScrollIndicators extends StatelessWidget {
  final int pageCount;
  final int activeIndex;
  final ValueChanged<int> onDotTapped;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const DynamicScrollIndicators({
    super.key,
    required this.pageCount,
    required this.activeIndex,
    required this.onDotTapped,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (pageCount <= 1) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPrev = activeIndex > 0;
    final hasNext = activeIndex < pageCount - 1;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Arrow Step
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
            onPressed: hasPrev ? onPrevious : null,
            color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
            disabledColor: isDark ? Colors.white24 : Colors.black12,
            tooltip: 'Previous page',
            splashRadius: 18,
          ),
          const SizedBox(width: 4),

          // Dynamic Indicator Dots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(pageCount, (index) {
              final isActive = index == activeIndex;
              return InkWell(
                onTap: () => onDotTapped(index),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeInOutCubic,
                    width: isActive ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: isActive ? AppColors.primaryGradient : null,
                      color: isActive
                          ? null
                          : (isDark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.16)),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.violetPrimary.withOpacity(0.45),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 4),

          // Next Arrow Step
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onPressed: hasNext ? onNext : null,
            color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
            disabledColor: isDark ? Colors.white24 : Colors.black12,
            tooltip: 'Next page',
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
