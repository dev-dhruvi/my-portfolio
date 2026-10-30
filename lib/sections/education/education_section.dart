import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/education.dart';
import '../../widgets/cards/glass_card.dart';

/// Cinematic Education section orchestrating a precision-choreographed entrance:
/// 1. Section Heading: Fade + slide upward (0.0s – 700ms)
/// 2. MCA Card: Slide in from 100px left, fade + scale 0.94 -> 1.0 (0.3s – 900ms)
/// 3. BCA Card: Slide in from 100px right, fade + scale 0.94 -> 1.0 (0.5s – 900ms)
/// 4. Graduate Illustration: Scale + fade (0.7s – 1000ms) -> Continuous 3D floating (8-12px float, -2° to +2° rotation, soft purple radial glow, rotating gradient outline ring, hover scale)
/// 5. Achievement Badge: Pop + golden glow (1.2s – 1200ms) with trophy bounce & repeating 4-second pulse
/// 6. Background: Continuous slow ambient particle constellation (30 particles, cyan glow, connecting filaments)
/// 7. Cards: 250ms subtle hover lift by 6px with purple/cyan shadow and achievement badge micro-interaction
class EducationSection extends StatefulWidget {
  final List<Education> education;

  const EducationSection({super.key, required this.education});

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection>
    with TickerProviderStateMixin {
  // Master timeline controller orchestrating the 2.4-second cinematic sequence
  late final AnimationController _timelineController;

  // Continuous loop controllers
  late final AnimationController _floatController;
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  // Timeline curve intervals
  late final Animation<double> _headingAnimation;
  late final Animation<double> _mcaAnimation;
  late final Animation<double> _bcaAnimation;
  late final Animation<double> _characterEntranceAnimation;
  late final Animation<double> _awardEntranceAnimation;

  final ValueNotifier<bool> _isCardHoveredNotifier = ValueNotifier<bool>(false);
  ScrollPosition? _scrollPosition;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();

    // Master Entrance Timeline (2400 ms)
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Continuous Animation Loops
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // 1. Heading: 0.0s -> 700ms (0.0 to 0.2917)
    _headingAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.0, 700 / 2400, curve: Curves.easeOutCubic),
    );

    // 2. MCA Card: 0.3s -> 1.2s (900ms duration, 0.125 to 0.500)
    _mcaAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(
        300 / 2400,
        1200 / 2400,
        curve: Curves.easeOutCubic,
      ),
    );

    // 3. BCA Card: 0.5s -> 1.4s (900ms duration, 0.2083 to 0.5833)
    _bcaAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(
        500 / 2400,
        1400 / 2400,
        curve: Curves.easeOutCubic,
      ),
    );

    // 4. Graduate Illustration: 0.7s -> 1.7s (1000ms duration, 0.2917 to 0.7083)
    _characterEntranceAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(
        700 / 2400,
        1700 / 2400,
        curve: Curves.easeOutBack,
      ),
    );

    // 5. Achievement Badge: 1.2s -> 2.4s (1200ms duration, 0.500 to 1.000)
    _awardEntranceAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(
        1200 / 2400,
        1.0,
        curve: Curves.easeOutBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollListener();
  }

  void _attachScrollListener() {
    if (_hasTriggered) return;
    final scrollable = Scrollable.maybeOf(context);
    final newPosition = scrollable?.position;
    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  void _onScroll() {
    if (!mounted || _hasTriggered) return;
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted || _hasTriggered) return;

    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _hasTriggered = true;
      _timelineController.value = 1.0;
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = null;
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final viewHeight = MediaQuery.sizeOf(context).height;
    if (viewHeight <= 0) return;
    final widgetPos = renderBox.localToGlobal(Offset.zero);

    // Trigger when section enters the visible viewport threshold (~85%)
    final topVisible = widgetPos.dy < (viewHeight * 0.88);
    final bottomVisible = (widgetPos.dy + renderBox.size.height) > 0;

    if (topVisible && bottomVisible) {
      _hasTriggered = true;
      _timelineController.forward();
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = null;
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _timelineController.dispose();
    _floatController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _isCardHoveredNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations && _timelineController.value != 1.0) {
      _timelineController.value = 1.0;
    }

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // C. Continuous Ambient Background Particles
        Positioned.fill(
          child: RepaintBoundary(
            child: _EducationParticleBackdrop(
              controller: _particleController,
              isDark: isDark,
              disableAnimations: disableAnimations,
            ),
          ),
        ),

        // Main Education Content Column
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 24 : (isMobile ? 20 : 24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Section Heading: Fade + Slide Upward (0.0s - 700ms)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _headingAnimation,
                  builder: (context, child) {
                    final progress = disableAnimations
                        ? 1.0
                        : _headingAnimation.value;
                    return Opacity(
                      opacity: progress.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, (1.0 - progress) * 26.0),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'ACADEMIC FOUNDATION',
                            style: TextStyle(
                              color: AppColors.cyanPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Education & Qualifications',
                        style: AppTypography.getDisplayMedium(textColor)
                            .copyWith(fontSize: isMobile ? 26 : 32),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Responsive Education Layout Strategy:
              // Desktop (> 1050dp): 3-column row (MCA Card - Graduate Stage - BCA Card)
              // Tablet (650-1050dp): 2-tier layout (Stage top, degree cards side-by-side row below)
              // Mobile (< 650dp): Adaptive single-column stack
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktopLayout = constraints.maxWidth >= 1050;
                  final isTabletLayout =
                      constraints.maxWidth >= 650 && constraints.maxWidth < 1050;

                  if (isDesktopLayout) {
                    return _buildDesktopLayout(isDark, disableAnimations);
                  } else if (isTabletLayout) {
                    return _buildTabletLayout(isDark, disableAnimations);
                  } else {
                    return _buildMobileLayout(isDark, disableAnimations);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 1. DESKTOP LAYOUT (3-Column Horizontal Symphony)
  // ===========================================================================
  Widget _buildDesktopLayout(bool isDark, bool disableAnimations) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // MCA Card: Starts 100px left, fades 0->1, scales 0.94->1.0 (300ms delay, 900ms duration)
            if (widget.education.isNotEmpty)
              Expanded(
                flex: 7,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _mcaAnimation,
                    builder: (context, child) {
                      final val = disableAnimations ? 1.0 : _mcaAnimation.value;
                      final dx = (1.0 - val) * -100.0;
                      final scale = 0.94 + (0.06 * val);
                      return Opacity(
                        opacity: val.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(dx, 0),
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.centerRight,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: _EducationCard(
                      education: widget.education[0],
                      onHoverChanged: (hovered) =>
                          _isCardHoveredNotifier.value = hovered,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 22),

            // Graduate Character Stage: Scale + Fade (700ms delay, 1000ms duration)
            // followed by continuous 3D floating (8-12px float, -2° to +2° rotation, soft purple radial glow)
            Expanded(
              flex: 6,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _characterEntranceAnimation,
                  builder: (context, child) {
                    final val = disableAnimations
                        ? 1.0
                        : _characterEntranceAnimation.value;
                    return Opacity(
                      opacity: val.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.70 + (0.30 * val),
                        child: child,
                      ),
                    );
                  },
                  child: _EducationCharacterStage(
                    isMobile: false,
                    floatController: _floatController,
                    rotationController: _rotationController,
                    disableAnimations: disableAnimations,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 22),

            // BCA Card: Starts 100px right, fades 0->1, scales 0.94->1.0 (500ms delay, 900ms duration)
            if (widget.education.length > 1)
              Expanded(
                flex: 7,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _bcaAnimation,
                    builder: (context, child) {
                      final val = disableAnimations ? 1.0 : _bcaAnimation.value;
                      final dx = (1.0 - val) * 100.0;
                      final scale = 0.94 + (0.06 * val);
                      return Opacity(
                        opacity: val.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(dx, 0),
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.centerLeft,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: _EducationCard(
                      education: widget.education[1],
                      onHoverChanged: (hovered) =>
                          _isCardHoveredNotifier.value = hovered,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),

        // Achievement Badge: Pop + Golden Reveal (1200ms delay, 1200ms duration)
        // With gentle trophy bounce and repeating 4-second golden glow pulse
        Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _awardEntranceAnimation,
              builder: (context, child) {
                final val = disableAnimations
                    ? 1.0
                    : _awardEntranceAnimation.value;
                return Opacity(
                  opacity: val.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.70 + (0.30 * val),
                    child: child,
                  ),
                );
              },
              child: _EducationAwardBadge(
                pulseController: _pulseController,
                isCardHoveredNotifier: _isCardHoveredNotifier,
                disableAnimations: disableAnimations,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. TABLET LAYOUT
  // ===========================================================================
  Widget _buildTabletLayout(bool isDark, bool disableAnimations) {
    return Column(
      children: [
        // Graduate Character Stage
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _characterEntranceAnimation,
            builder: (context, child) {
              final val = disableAnimations
                  ? 1.0
                  : _characterEntranceAnimation.value;
              return Opacity(
                opacity: val.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.70 + (0.30 * val),
                  child: child,
                ),
              );
            },
            child: _EducationCharacterStage(
              isMobile: true,
              floatController: _floatController,
              rotationController: _rotationController,
              disableAnimations: disableAnimations,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Achievement Badge
        Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _awardEntranceAnimation,
              builder: (context, child) {
                final val = disableAnimations
                    ? 1.0
                    : _awardEntranceAnimation.value;
                return Opacity(
                  opacity: val.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.70 + (0.30 * val),
                    child: child,
                  ),
                );
              },
              child: _EducationAwardBadge(
                pulseController: _pulseController,
                isCardHoveredNotifier: _isCardHoveredNotifier,
                disableAnimations: disableAnimations,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Row of MCA & BCA Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.education.isNotEmpty)
              Expanded(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _mcaAnimation,
                    builder: (context, child) {
                      final val = disableAnimations ? 1.0 : _mcaAnimation.value;
                      final dx = (1.0 - val) * -70.0;
                      return Opacity(
                        opacity: val.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        ),
                      );
                    },
                    child: _EducationCard(
                      education: widget.education[0],
                      onHoverChanged: (h) => _isCardHoveredNotifier.value = h,
                    ),
                  ),
                ),
              ),
            if (widget.education.length > 1) ...[
              const SizedBox(width: 18),
              Expanded(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _bcaAnimation,
                    builder: (context, child) {
                      final val = disableAnimations ? 1.0 : _bcaAnimation.value;
                      final dx = (1.0 - val) * 70.0;
                      return Opacity(
                        opacity: val.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        ),
                      );
                    },
                    child: _EducationCard(
                      education: widget.education[1],
                      onHoverChanged: (h) => _isCardHoveredNotifier.value = h,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 3. MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout(bool isDark, bool disableAnimations) {
    return Column(
      children: [
        // Graduate Character Stage
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _characterEntranceAnimation,
            builder: (context, child) {
              final val = disableAnimations
                  ? 1.0
                  : _characterEntranceAnimation.value;
              return Opacity(
                opacity: val.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.75 + (0.25 * val),
                  child: child,
                ),
              );
            },
            child: _EducationCharacterStage(
              isMobile: true,
              floatController: _floatController,
              rotationController: _rotationController,
              disableAnimations: disableAnimations,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Achievement Badge
        Center(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _awardEntranceAnimation,
              builder: (context, child) {
                final val = disableAnimations
                    ? 1.0
                    : _awardEntranceAnimation.value;
                return Opacity(
                  opacity: val.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.70 + (0.30 * val),
                    child: child,
                  ),
                );
              },
              child: _EducationAwardBadge(
                pulseController: _pulseController,
                isCardHoveredNotifier: _isCardHoveredNotifier,
                disableAnimations: disableAnimations,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Vertical List of Education Cards
        ...widget.education.asMap().entries.map((entry) {
          final index = entry.key;
          final edu = entry.value;
          final isEven = index.isEven;
          final anim = isEven ? _mcaAnimation : _bcaAnimation;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: anim,
                builder: (context, child) {
                  final val = disableAnimations ? 1.0 : anim.value;
                  final dx = (1.0 - val) * (isEven ? -60.0 : 60.0);
                  return Opacity(
                    opacity: val.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(dx, 0),
                      child: child,
                    ),
                  );
                },
                child: _EducationCard(
                  education: edu,
                  onHoverChanged: (h) => _isCardHoveredNotifier.value = h,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// =============================================================================
// C. BACKGROUND AMBIENT PARTICLES (CustomPainter with Slow Float & Cyan Glow)
// =============================================================================
class _EducationParticleBackdrop extends StatelessWidget {
  final AnimationController controller;
  final bool isDark;
  final bool disableAnimations;

  const _EducationParticleBackdrop({
    required this.controller,
    required this.isDark,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    if (disableAnimations) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _EducationParticlePainter(
            progress: controller.value,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _EducationParticlePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  static final List<_SeedParticle> _particles = List.generate(32, (i) {
    final rng = math.Random(i * 13 + 7);
    return _SeedParticle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      radius: 1.2 + (rng.nextDouble() * 2.0),
      speed: 0.03 + (rng.nextDouble() * 0.05),
      phase: rng.nextDouble() * math.pi * 2,
      baseAlpha: 0.18 + (rng.nextDouble() * 0.35),
      isCyan: i % 4 == 0,
    );
  });

  _EducationParticlePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final dotPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    final points = <Offset>[];
    final t = progress * 2 * math.pi;

    for (final p in _particles) {
      final currentY = (p.y - (progress * p.speed * 6)) % 1.0;
      final px = (p.x * size.width) + (math.sin(t + p.phase) * 10.0);
      final py = currentY * size.height;
      final pt = Offset(px, py);
      points.add(pt);

      final twinkle = 0.5 + 0.5 * math.sin(t * 2.5 + p.phase);
      final alpha = (p.baseAlpha * twinkle).clamp(0.08, 0.65);

      final color = p.isCyan
          ? AppColors.cyanPrimary
          : (isDark ? const Color(0xFFC4B5FD) : AppColors.violetPrimary);

      dotPaint.color = color.withOpacity(isDark ? alpha : alpha * 0.7);
      canvas.drawCircle(pt, p.radius, dotPaint);
    }

    // Connect close neighbors with subtle filaments
    const maxDist = 95.0;
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d < maxDist) {
          final lineAlpha = ((1.0 - (d / maxDist)) * 0.10).clamp(0.0, 0.10);
          linePaint.color =
              (isDark ? AppColors.cyanPrimary : AppColors.violetPrimary)
                  .withOpacity(lineAlpha);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EducationParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SeedParticle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final double baseAlpha;
  final bool isCyan;

  _SeedParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.baseAlpha,
    required this.isCyan,
  });
}

// =============================================================================
// A. GRADUATE ILLUSTRATION – 3D FLOATING EFFECT & ROTATING GRADIENT RING
// =============================================================================
class _EducationCharacterStage extends StatefulWidget {
  final bool isMobile;
  final AnimationController floatController;
  final AnimationController rotationController;
  final bool disableAnimations;

  const _EducationCharacterStage({
    required this.isMobile,
    required this.floatController,
    required this.rotationController,
    required this.disableAnimations,
  });

  @override
  State<_EducationCharacterStage> createState() =>
      _EducationCharacterStageState();
}

class _EducationCharacterStageState extends State<_EducationCharacterStage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = widget.isMobile;

    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? 260 : 310,
                maxHeight: isMobile ? 260 : 310,
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. Soft Purple/Cyan Radial Glow behind character
                  Container(
                    width: isMobile ? 210 : 255,
                    height: isMobile ? 210 : 255,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF8B5CF6)
                              .withOpacity(isDark ? 0.40 : 0.25),
                          AppColors.cyanPrimary
                              .withOpacity(isDark ? 0.24 : 0.14),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.58, 1.0],
                      ),
                    ),
                  ),

                  // 2. Rotating Gradient Circular Outline Ring
                  if (!widget.disableAnimations)
                    Positioned.fill(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: widget.rotationController,
                          builder: (context, _) {
                            final angle =
                                widget.rotationController.value * 2 * math.pi;
                            return Transform.rotate(
                              angle: angle,
                              child: Container(
                                width: isMobile ? 220 : 265,
                                height: isMobile ? 220 : 265,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const SweepGradient(
                                    colors: [
                                      AppColors.cyanPrimary,
                                      Color(0xFF8B5CF6),
                                      Color(0xFFEC4899),
                                      AppColors.cyanPrimary,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? const Color(0xFF090D16)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // 3. 3D Graduate Character Asset with Slow Floating & Subtle Tilt
                  AnimatedBuilder(
                    animation: widget.floatController,
                    builder: (context, child) {
                      if (widget.disableAnimations) return child!;
                      final t = widget.floatController.value * 2 * math.pi;
                      // Float up and down: 8-12px (amplitude 10.0)
                      final dy = math.sin(t) * 10.0;
                      // Subtle rotation: -2° to +2° (-0.035 to +0.035 rad)
                      final tilt = math.sin(t) * 0.035;

                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.rotate(
                          angle: tilt,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/developer_character_graduate.webp',
                      height: isMobile ? 220 : 270,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: isMobile ? 180 : 220,
                        height: isMobile ? 180 : 220,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// D. ACHIEVEMENT BADGE – GOLDEN REVEAL & TROPHY BOUNCE
// =============================================================================
class _EducationAwardBadge extends StatelessWidget {
  final AnimationController pulseController;
  final ValueNotifier<bool> isCardHoveredNotifier;
  final bool disableAnimations;

  const _EducationAwardBadge({
    required this.pulseController,
    required this.isCardHoveredNotifier,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: isCardHoveredNotifier,
      builder: (context, isCardHovered, _) {
        return AnimatedBuilder(
          animation: pulseController,
          builder: (context, child) {
            final t = pulseController.value * 2 * math.pi;
            // Golden glow pulse every 4 seconds
            final pulseAlpha = disableAnimations
                ? 0.25
                : 0.18 + (math.sin(t).abs() * 0.22);
            final trophyBounce = disableAnimations ? 0.0 : math.sin(t * 2) * 2.5;

            final isHighlight = isCardHovered;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(isHighlight ? 1.04 : 1.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF59E0B)
                        .withOpacity(isDark ? 0.24 : 0.15),
                    AppColors.violetPrimary
                        .withOpacity(isDark ? 0.18 : 0.10),
                  ],
                ),
                color: isDark
                    ? AppColors.darkCard.withOpacity(0.95)
                    : Colors.white.withOpacity(0.96),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(
                    isHighlight ? 0.95 : (isDark ? 0.65 : 0.50),
                  ),
                  width: isHighlight ? 1.6 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withOpacity(
                      isHighlight ? 0.45 : pulseAlpha,
                    ),
                    blurRadius: isHighlight ? 22 : 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trophy Icon with subtle bounce
                      Transform.translate(
                        offset: Offset(0, -trophyBounce),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFFF59E0B),
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Code Craft Excellence Award (2025)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFFDE68A)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Logix Built Infotech Solutions',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// =============================================================================
// B. EDUCATION CARDS – 250ms HOVER LIFT (6px) & 100% STABLE TEXT RENDERING
// =============================================================================
class _EducationCard extends StatefulWidget {
  final Education education;
  final ValueChanged<bool>? onHoverChanged;

  const _EducationCard({
    required this.education,
    this.onHoverChanged,
  });

  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered != value) {
      setState(() => _isHovered = value);
      widget.onHoverChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        // Move card upward by 6px on hover with scale lift
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.violetPrimary : AppColors.cyanPrimary)
                  .withOpacity(_isHovered ? 0.38 : 0.07),
              blurRadius: _isHovered ? 26 : 10,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
            if (_isHovered)
              BoxShadow(
                color: AppColors.cyanPrimary.withOpacity(0.20),
                blurRadius: 18,
                offset: const Offset(0, -2),
              ),
          ],
        ),
        child: GlassCard(
          padding: const EdgeInsets.all(22),
          customBorderColor: _isHovered
              ? AppColors.cyanPrimary.withOpacity(isDark ? 0.85 : 0.70)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.violetPrimary.withOpacity(0.26)
                          : AppColors.violetPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: AppColors.violetPrimary.withOpacity(0.40),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: isDark
                          ? AppColors.violetLight
                          : AppColors.violetDark,
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4.5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isDark ? AppColors.cyanPrimary : AppColors.cyanDark)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            (isDark
                                    ? AppColors.cyanPrimary
                                    : AppColors.cyanDark)
                                .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${widget.education.startDate} – ${widget.education.endDate}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.cyanPrimary
                            : AppColors.cyanDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.education.degree,
                style: AppTypography.getTitleLarge(textColor)
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                widget.education.institution,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.violetLight : AppColors.violetDark,
                ),
              ),
              if (widget.education.affiliation.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  widget.education.affiliation,
                  style: TextStyle(fontSize: 12.5, color: secondaryTextColor),
                ),
              ],
              const SizedBox(height: 12),

              // Distinction / CGPA Badge
              if (widget.education.honors.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.education.honors,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
