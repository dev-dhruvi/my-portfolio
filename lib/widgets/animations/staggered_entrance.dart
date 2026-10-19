import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps any widget in a subtle, staggered entrance fade and slide.
class StaggeredEntrance extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration itemDelay;
  final Duration duration;
  final double slideOffset;

  const StaggeredEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 100),
    this.itemDelay = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 500),
    this.slideOffset = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    final totalDelay = baseDelay + (itemDelay * index);

    return child
        .animate(delay: totalDelay)
        .fadeIn(duration: duration, curve: Curves.easeOutCubic)
        .slideY(
          begin: slideOffset,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
