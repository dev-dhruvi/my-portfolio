import 'package:flutter/material.dart';

import 'creative_animated_background.dart';

export 'creative_animated_background.dart';

/// Performance-optimized ambient lighting background with floating soft gradient
/// orbs, starry cyber particles, and subtle desktop mouse parallax.
/// Automatically disables continuous animation when reduced motion is preferred.
class AmbientBackground extends StatelessWidget {
  final Widget child;
  final bool enableParticles;
  final bool enableParallax;

  const AmbientBackground({
    super.key,
    required this.child,
    this.enableParticles = true,
    this.enableParallax = true,
  });

  @override
  Widget build(BuildContext context) {
    return CreativeAnimatedBackground(
      enableParticles: enableParticles,
      enableParallax: enableParallax,
      child: child,
    );
  }
}
