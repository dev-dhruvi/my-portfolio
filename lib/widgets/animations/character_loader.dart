import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';

/// 3D Illustrator animated entrance loader shown at app or website startup.
/// Features the 3D anime cartoon developer character with breathing glow,
/// floating motion, rotating accent rings, gradient loading progress bar,
/// and smooth fade-out transition.
class CharacterLoader extends StatefulWidget {
  final VoidCallback onFinished;
  final Duration duration;

  const CharacterLoader({
    super.key,
    required this.onFinished,
    this.duration = const Duration(milliseconds: 2100),
  });

  @override
  State<CharacterLoader> createState() => _CharacterLoaderState();
}

class _CharacterLoaderState extends State<CharacterLoader>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _floatController;
  late final AnimationController _pulseController;
  late final AnimationController _exitController;

  late final Animation<double> _progressAnimation;
  late final Animation<double> _exitOpacity;
  late final Animation<double> _exitScale;

  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeOutCubic),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startExit();
      }
    });

    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });

    _progressController.forward();
  }

  void _startExit() {
    if (_isExiting || !mounted) return;
    setState(() => _isExiting = true);
    _exitController.forward();
  }

  void _skip() {
    if (_isExiting) return;
    _progressController.stop();
    _startExit();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  String _getStatusText(double progress) {
    if (progress < 0.35) {
      return 'Initializing 3D Workspace...';
    } else if (progress < 0.75) {
      return 'Loading Flutter & Cloud Architecture...';
    } else {
      return 'Welcome to Dhruvi’s Portfolio!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFinished();
      });
      return const SizedBox.shrink();
    }

    final isMobile = AppBreakpoints.isMobile(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return AnimatedBuilder(
      animation: _exitController,
      builder: (context, child) {
        return Opacity(
          opacity: _exitOpacity.value,
          child: Transform.scale(scale: _exitScale.value, child: child),
        );
      },
      child: Material(
        color: AppColors.darkBackground,
        child: GestureDetector(
          onTap: _skip,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient radiant background glow
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final pulse = _pulseController.value;
                  return Container(
                    width: isMobile ? 320 : 480,
                    height: isMobile ? 320 : 480,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.violetPrimary.withOpacity(
                            0.28 + pulse * 0.12,
                          ),
                          AppColors.cyanPrimary.withOpacity(
                            0.14 + pulse * 0.08,
                          ),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  );
                },
              ),

              // Main Stage: 3D Character Illustration, Floating Badges & Progress
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status Badge pill above character
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.violetPrimary.withOpacity(0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violetPrimary.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.onlineGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.onlineGreen,
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Dhruvi Patel • Senior Flutter Developer',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3D Anime Character with Floating Motion & Glowing Ring
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final floatOffset =
                              math.sin(_floatController.value * math.pi) * 8.0;
                          return Transform.translate(
                            offset: Offset(0, -floatOffset),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: isMobile ? 260 : 320,
                          height: isMobile ? 260 : 320,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer rotating glass ring
                              AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, _) {
                                  return Container(
                                    width: isMobile ? 240 : 290,
                                    height: isMobile ? 240 : 290,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.cyanPrimary
                                            .withOpacity(0.25),
                                        width: 1.5,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Inner soft aura circle
                              Container(
                                width: isMobile ? 210 : 255,
                                height: isMobile ? 210 : 255,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.violetPrimary.withOpacity(0.35),
                                      AppColors.cyanPrimary.withOpacity(0.18),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.65, 1.0],
                                  ),
                                ),
                              ),

                              // 3D Anime Character Illustration
                              Image.asset(
                                'assets/images/developer_character_3d.png',
                                height: isMobile ? 220 : 270,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.flutter_dash_rounded,
                                    size: 90,
                                    color: AppColors.cyanPrimary,
                                  );
                                },
                              ),

                              // Floating bottom Flutter & Dart pill
                              Positioned(
                                bottom: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkCard.withOpacity(0.92),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.cyanPrimary.withOpacity(
                                        0.4,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.cyanPrimary
                                              .withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.code_rounded,
                                          size: 13,
                                          color: AppColors.cyanPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Flutter & Dart Specialist',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Dynamic Progress Bar & Percent
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, _) {
                          final progress = _progressAnimation.value;
                          final barWidth = math.min(280.0, screenWidth * 0.72);

                          return Column(
                            children: [
                              // Progress Capsule Track
                              Container(
                                width: barWidth,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: progress.clamp(0.02, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.cyanPrimary
                                                  .withOpacity(0.5),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Progress Status Text & Percent
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getStatusText(progress),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.cyanPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // Skip hint
                      InkWell(
                        onTap: _skip,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            'Click anywhere or tap here to skip →',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white.withOpacity(0.4),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
