import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Performance-optimized ambient lighting background with floating soft gradient
/// orbs. Automatically stops animation if reduced motion is preferred.
class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (disableAnimations) {
      return Stack(
        children: [
          Container(
            color: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
          ),
          widget.child,
        ],
      );
    }

    return Stack(
      children: [
        // Base background
        Container(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        ),

        // Animated ambient glow orbs
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final orb1X = 0.2 + (0.15 * math.sin(t * 2 * math.pi));
              final orb1Y = 0.15 + (0.1 * math.cos(t * 2 * math.pi));

              final orb2X = 0.8 - (0.2 * math.cos(t * 2 * math.pi));
              final orb2Y = 0.65 + (0.15 * math.sin(t * 2 * math.pi));

              return CustomPaint(
                painter: _AmbientGlowPainter(
                  orb1: Offset(orb1X, orb1Y),
                  orb2: Offset(orb2X, orb2Y),
                  isDark: isDark,
                ),
              );
            },
          ),
        ),

        // Main content
        widget.child,
      ],
    );
  }
}

class _AmbientGlowPainter extends CustomPainter {
  final Offset orb1;
  final Offset orb2;
  final bool isDark;

  _AmbientGlowPainter({
    required this.orb1,
    required this.orb2,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final center1 = Offset(size.width * orb1.dx, size.height * orb1.dy);
    final radius1 = size.width * 0.35;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppColors.violetPrimary : const Color(0xFFC4B5FD))
              .withOpacity(isDark ? 0.14 : 0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center1, radius: radius1));

    canvas.drawCircle(center1, radius1, paint1);

    final center2 = Offset(size.width * orb2.dx, size.height * orb2.dy);
    final radius2 = size.width * 0.4;

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppColors.cyanPrimary : const Color(0xFFBAE6FD))
              .withOpacity(isDark ? 0.10 : 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center2, radius: radius2));

    canvas.drawCircle(center2, radius2, paint2);
  }

  @override
  bool shouldRepaint(_AmbientGlowPainter oldDelegate) {
    return oldDelegate.orb1 != orb1 ||
        oldDelegate.orb2 != orb2 ||
        oldDelegate.isDark != isDark;
  }
}
