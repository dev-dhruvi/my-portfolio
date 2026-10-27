import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A creative, performance-optimized animated background for Flutter Web.
/// Features:
/// 1. Floating organic glow orbs with multi-frequency sinusoidal movement.
/// 2. Micro-particle cyber constellation with subtle twinkles and dynamic filaments.
/// 3. Responsive mouse parallax for depth on desktop web.
/// 4. Zero CPU/GPU cost when `disableAnimations` is active.
class CreativeAnimatedBackground extends StatefulWidget {
  final Widget child;

  /// Whether to render the subtle cyber particle constellation layer.
  final bool enableParticles;

  /// Whether mouse movement creates a subtle parallax shift.
  final bool enableParallax;

  const CreativeAnimatedBackground({
    super.key,
    required this.child,
    this.enableParticles = true,
    this.enableParallax = true,
  });

  @override
  State<CreativeAnimatedBackground> createState() =>
      _CreativeAnimatedBackgroundState();
}

class _CreativeAnimatedBackgroundState extends State<CreativeAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_BackgroundParticle> _particles;
  final math.Random _rng = math.Random(42);

  final ValueNotifier<Offset> _mouseParallax = ValueNotifier<Offset>(
    Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles = List.generate(28, (index) {
      return _BackgroundParticle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        radius: 1.0 + (_rng.nextDouble() * 1.8),
        speed: 0.02 + (_rng.nextDouble() * 0.04),
        phase: _rng.nextDouble() * math.pi * 2,
        baseAlpha: 0.15 + (_rng.nextDouble() * 0.35),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _mouseParallax.dispose();
    super.dispose();
  }

  void _onPointerHover(PointerHoverEvent event) {
    if (!widget.enableParallax) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    if (size.width == 0 || size.height == 0) return;

    final normX = (event.localPosition.dx / size.width) - 0.5;
    final normY = (event.localPosition.dy / size.height) - 0.5;

    // Decoupled from widget tree rebuilds: updates ValueNotifier without calling setState()
    _mouseParallax.value = Offset(normX * 24.0, normY * 24.0);
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
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

    return MouseRegion(
      onHover: _onPointerHover,
      child: Stack(
        children: [
          // 1. Deep solid backdrop
          Positioned.fill(
            child: ColoredBox(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
            ),
          ),

          // 2. Animated CustomPainter canvas with RepaintBoundary
          Positioned.fill(
            child: RepaintBoundary(
              child: ListenableBuilder(
                listenable: Listenable.merge([_controller, _mouseParallax]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: _CreativeCanvasPainter(
                      progress: _controller.value,
                      particles: widget.enableParticles ? _particles : const [],
                      parallax: _mouseParallax.value,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. Child contents
          widget.child,
        ],
      ),
    );
  }
}

class _BackgroundParticle {
  double x;
  double y;
  final double radius;
  final double speed;
  final double phase;
  final double baseAlpha;

  _BackgroundParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.baseAlpha,
  });
}

class _CreativeCanvasPainter extends CustomPainter {
  final double progress;
  final List<_BackgroundParticle> particles;
  final Offset parallax;
  final bool isDark;

  _CreativeCanvasPainter({
    required this.progress,
    required this.particles,
    required this.parallax,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final t = progress * 2 * math.pi;

    // --- 1. Luminous Ambient Glow Orbs ---
    // Orb 1: Violet/Indigo Top-Left wandering orb
    final orb1X =
        size.width * (0.22 + 0.12 * math.sin(t * 0.8)) + parallax.dx * 0.8;
    final orb1Y =
        size.height * (0.18 + 0.08 * math.cos(t * 0.6)) + parallax.dy * 0.8;
    final orb1Radius = size.width * (size.width < 600 ? 0.55 : 0.32);

    final orb1Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              (isDark ? AppColors.violetPrimary : const Color(0xFFC4B5FD))
                  .withOpacity(isDark ? 0.18 : 0.20),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb1X, orb1Y), radius: orb1Radius),
          );

    canvas.drawCircle(Offset(orb1X, orb1Y), orb1Radius, orb1Paint);

    // Orb 2: Cyan/Teal Bottom-Right wandering orb
    final orb2X =
        size.width * (0.78 - 0.14 * math.cos(t * 0.7)) - parallax.dx * 0.6;
    final orb2Y =
        size.height * (0.68 + 0.10 * math.sin(t * 0.5)) - parallax.dy * 0.6;
    final orb2Radius = size.width * (size.width < 600 ? 0.60 : 0.35);

    final orb2Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              (isDark ? AppColors.cyanPrimary : const Color(0xFFBAE6FD))
                  .withOpacity(isDark ? 0.13 : 0.16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb2X, orb2Y), radius: orb2Radius),
          );

    canvas.drawCircle(Offset(orb2X, orb2Y), orb2Radius, orb2Paint);

    // Orb 3: Accent Purple/Fuchsia Center-Floating orb
    final orb3X = size.width * (0.50 + 0.10 * math.sin(t * 1.1 + 1.0));
    final orb3Y = size.height * (0.45 + 0.12 * math.cos(t * 0.9 + 2.0));
    final orb3Radius = size.width * (size.width < 600 ? 0.45 : 0.24);

    final orb3Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFFA855F7).withOpacity(isDark ? 0.09 : 0.12),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb3X, orb3Y), radius: orb3Radius),
          );

    canvas.drawCircle(Offset(orb3X, orb3Y), orb3Radius, orb3Paint);

    // --- 2. Cyber Particles & Filament Lines ---
    if (particles.isEmpty) return;

    final particlePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    final renderedPoints = <Offset>[];

    for (final p in particles) {
      // Animate vertical drift
      final currentY = (p.y - (progress * p.speed * 8)) % 1.0;
      final px =
          (p.x * size.width) +
          (math.sin(t + p.phase) * 12.0) +
          (parallax.dx * 0.2);
      final py = (currentY * size.height) + (parallax.dy * 0.2);

      final point = Offset(px, py);
      renderedPoints.add(point);

      // Twinkle opacity
      final twinkle = (0.5 + 0.5 * math.sin(t * 3.0 + p.phase));
      final alpha = (p.baseAlpha * twinkle).clamp(0.05, 0.7);

      particlePaint.color = (isDark ? Colors.white : AppColors.violetPrimary)
          .withOpacity(isDark ? alpha : alpha * 0.6);

      canvas.drawCircle(point, p.radius, particlePaint);
    }

    // Connect close neighboring particles with subtle filament lines on tablet/desktop
    // Skip heavy O(N^2) pairwise line calculations on narrow mobile viewports (<600px)
    if (size.width >= 600) {
      final maxDistance = 110.0;
      for (int i = 0; i < renderedPoints.length; i++) {
        for (int j = i + 1; j < renderedPoints.length; j++) {
          final p1 = renderedPoints[i];
          final p2 = renderedPoints[j];
          final distance = (p1 - p2).distance;

          if (distance < maxDistance) {
            final lineAlpha = ((1.0 - (distance / maxDistance)) * 0.12).clamp(
              0.0,
              0.12,
            );
            linePaint.color =
                (isDark ? AppColors.cyanPrimary : AppColors.violetPrimary)
                    .withOpacity(lineAlpha);
            canvas.drawLine(p1, p2, linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_CreativeCanvasPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.parallax != parallax ||
        oldDelegate.isDark != isDark;
  }
}
