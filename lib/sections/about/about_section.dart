import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/profile.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/glass_card.dart';

/// About section detailing verified experience in Flutter, Dart,
/// mobile development, REST APIs, Firebase, and testing.
class AboutSection extends StatelessWidget {
  final Profile profile;
  final int animationTrigger;

  const AboutSection({
    super.key,
    required this.profile,
    this.animationTrigger = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    // Minimum height ensures the About section occupies the full desktop viewport
    // with its content centered vertically, eliminating bleed from previous or following sections.
    final double? minAboutHeight = isDesktop
        ? math.max(620.0, screenHeight - 92.0)
        : null;

    return Container(
      constraints: minAboutHeight != null
          ? BoxConstraints(minHeight: minAboutHeight)
          : null,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 16 : (isMobile ? 24 : 28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          // Section Tag & Title
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
                'ABOUT ME',
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
            'Specialized in Flutter, Mobile Architecture & Cloud Services',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 16),

          // Main Narrative & 3D Anime Business Character Stage
          if (isMobile)
            Column(
              children: [
                _buildNarrativeCard(
                  context,
                  textColor,
                  secondaryTextColor,
                  isMobile,
                ),
                const SizedBox(height: 18),
                const StaggeredEntrance(
                  index: 1,
                  child: _AboutCharacterStage(isMobile: true),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildNarrativeCard(
                    context,
                    textColor,
                    secondaryTextColor,
                    isMobile,
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(
                  flex: 4,
                  child: StaggeredEntrance(
                    index: 1,
                    child: _AboutCharacterStage(isMobile: false),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Key Highlights Metric Cards with Animated Counting Numbers
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (3 * 16)) / 4;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _HighlightCard(
                    key: ValueKey('highlight_exp_$animationTrigger'),
                    width: cardWidth,
                    value: '4+ Years',
                    numericTarget: 4,
                    suffix: '+ Years',
                    label: 'Hands-on Experience',
                    icon: Icons.timeline_rounded,
                    accentColor: AppColors.violetPrimary,
                    animationTrigger: animationTrigger,
                  ),
                  _HighlightCard(
                    key: ValueKey('highlight_releases_$animationTrigger'),
                    width: cardWidth,
                    value: '50+ Releases',
                    numericTarget: 50,
                    suffix: '+ Releases',
                    label: 'Play Store & App Store',
                    icon: Icons.rocket_launch_outlined,
                    accentColor: const Color(0xFFF59E0B),
                    animationTrigger: animationTrigger,
                  ),
                  _HighlightCard(
                    key: ValueKey('highlight_projects_$animationTrigger'),
                    width: cardWidth,
                    value: '20+ Projects',
                    numericTarget: 20,
                    suffix: '+ Projects',
                    label: 'Built & Deployed',
                    icon: Icons.layers_outlined,
                    accentColor: AppColors.cyanPrimary,
                    animationTrigger: animationTrigger,
                  ),
                  _HighlightCard(
                    key: ValueKey('highlight_edu_$animationTrigger'),
                    width: cardWidth,
                    value: 'MCA & BCA',
                    numericTarget: null,
                    suffix: '',
                    label: 'GTU & VNSGU Distinction',
                    icon: Icons.school_outlined,
                    accentColor: AppColors.bluePrimary,
                    animationTrigger: animationTrigger,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNarrativeCard(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isMobile,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Background',
            style: AppTypography.getTitleMedium(textColor)
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'With over 4 years of verified software engineering experience based in Surat, Gujarat, '
            'I focus on building production-grade cross-platform mobile and web applications with Flutter and Dart. '
            'My technical journey spans end-to-end development, from designing responsive interfaces to '
            'integrating high-concurrency REST APIs, real-time AWS IoT Core (MQTT) data pipelines, and Firebase cloud services.',
            style: AppTypography.getBodyMedium(secondaryTextColor)
                .copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Engineering Philosophy & Craftsmanship',
            style: AppTypography.getTitleMedium(textColor)
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'I advocate for modular, Clean Architecture principles and strict separation of concerns using GetX '
            'and reactive state models. '
            'Having led and contributed to over 20 client and enterprise applications, I emphasize automated unit and '
            'widget testing, robust JWT authentication, memory leak elimination, and CI/CD deployment pipelines '
            'targeting both the Google Play Store and Apple App Store.',
            style: AppTypography.getBodyMedium(secondaryTextColor)
                .copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF59E0B).withOpacity(isDark ? 0.18 : 0.12),
                  AppColors.violetPrimary.withOpacity(isDark ? 0.15 : 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(isDark ? 0.45 : 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 16,
                  color: Color(0xFFD97706),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Code Craft Excellence Award (2025)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFFDE68A)
                          : const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCharacterStage extends StatelessWidget {
  final bool isMobile;

  const _AboutCharacterStage({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? 260 : 320,
          maxHeight: isMobile ? 280 : 340,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Ambient soft glowing backdrop
            Container(
              width: isMobile ? 210 : 260,
              height: isMobile ? 210 : 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.violetPrimary.withOpacity(isDark ? 0.35 : 0.22),
                    AppColors.cyanPrimary.withOpacity(isDark ? 0.2 : 0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
            // Outer subtle glass accent ring
            Container(
              width: isMobile ? 225 : 275,
              height: isMobile ? 225 : 275,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : AppColors.violetPrimary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            // 3D Business anime developer illustration
            Image.asset(
              'assets/images/developer_character_business.png',
              height: isMobile ? 250 : 310,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            // Floating badge at bottom of character
            Positioned(
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkCard : Colors.white)
                      .withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.violetPrimary.withOpacity(0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
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
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Clean Architecture Specialist',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.darkBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final double width;
  final String value;
  final int? numericTarget;
  final String suffix;
  final String label;
  final IconData icon;
  final Color accentColor;
  final int animationTrigger;

  const _HighlightCard({
    super.key,
    required this.width,
    required this.value,
    this.numericTarget,
    this.suffix = '',
    required this.label,
    required this.icon,
    required this.accentColor,
    this.animationTrigger = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return SizedBox(
      width: width,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 10),
            if (numericTarget != null)
              _AnimatedCounterText(
                key: ValueKey('counter_${numericTarget}_$animationTrigger'),
                targetValue: numericTarget!,
                suffix: suffix,
                fallbackText: value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              )
            else
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCounterText extends StatelessWidget {
  final int targetValue;
  final String suffix;
  final String fallbackText;
  final TextStyle style;

  const _AnimatedCounterText({
    super.key,
    required this.targetValue,
    required this.suffix,
    required this.fallbackText,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      return Text('$targetValue$suffix', style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue.toDouble()),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = targetValue == 0
            ? 1.0
            : (value / targetValue).clamp(0.0, 1.0);
        return Transform.scale(
          scale: 0.94 + (0.06 * progress),
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: (0.35 + 0.65 * progress).clamp(0.0, 1.0),
            child: Text('${value.toInt()}$suffix', style: style),
          ),
        );
      },
    );
  }
}
