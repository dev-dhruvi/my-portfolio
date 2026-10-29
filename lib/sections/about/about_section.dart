import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/profile.dart';
import '../../widgets/animations/parallax_widget.dart';
import '../../widgets/animations/scroll_reveal.dart';
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

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 24 : (isMobile ? 20 : 24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Section Tag & Title with clipped entrance reveal
          ScrollReveal.clippedText(
            staggerIndex: 0,
            child: Row(
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
                const Flexible(
                  child: Text(
                    'ABOUT ME',
                    style: TextStyle(
                      color: AppColors.cyanPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ScrollReveal.clippedText(
            staggerIndex: 1,
            child: Text(
              'Flutter Developer Passionate About Building Scalable Digital Experiences',
              style: AppTypography.getDisplayMedium(textColor)
                  .copyWith(fontSize: isMobile ? 24 : 28),
            ),
          ),
          const SizedBox(height: 16),

          // Main Narrative & 3D Anime Business Character Stage
          if (isMobile)
            Column(
              children: [
                ScrollReveal(
                  staggerIndex: 0,
                  slideDistance: 16.0,
                  child: _buildNarrativeCard(
                    context,
                    textColor,
                    secondaryTextColor,
                    isMobile,
                  ),
                ),
                const SizedBox(height: 18),
                const StaggeredEntrance(
                  index: 1,
                  child: ParallaxWidget(
                    speed: -0.04,
                    maxOffset: 16,
                    child: _AboutCharacterStage(isMobile: true),
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: ScrollReveal(
                    staggerIndex: 0,
                    slideDistance: 16.0,
                    child: _buildNarrativeCard(
                      context,
                      textColor,
                      secondaryTextColor,
                      isMobile,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(
                  flex: 4,
                  child: StaggeredEntrance(
                    index: 1,
                    child: ParallaxWidget(
                      speed: -0.05,
                      maxOffset: 20,
                      child: _AboutCharacterStage(isMobile: false),
                    ),
                  ),
                ),
              ],
            ),

          // Key Highlights Header (Mobile view matching reference design)
          if (isMobile) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Key Highlights',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'A quick look at my journey, achievements and contributions in the tech world.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 14),
          ] else
            const SizedBox(height: 20),

          // Key Highlights Metric Cards with Animated Counting Numbers
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile || constraints.maxWidth < 600) {
                // Mobile UI: Exact 2 x 2 grid with centered content, matching reference screenshot
                final card1 = _HighlightCard(
                  key: ValueKey('highlight_exp_$animationTrigger'),
                  value: '4+ Years',
                  numericTarget: 4,
                  suffix: '+ Years',
                  label: 'Hands-on Experience',
                  icon: Icons.trending_up_rounded,
                  accentColor: AppColors.violetPrimary,
                  animationTrigger: animationTrigger,
                  isCentered: true,
                  staggerIndex: 0,
                );
                final card2 = _HighlightCard(
                  key: ValueKey('highlight_releases_$animationTrigger'),
                  value: '350+ Releases',
                  numericTarget: 350,
                  suffix: '+ Releases',
                  label: 'Play Store & App Store',
                  icon: Icons.rocket_launch_rounded,
                  accentColor: const Color(0xFFF59E0B),
                  animationTrigger: animationTrigger,
                  isCentered: true,
                  staggerIndex: 1,
                );
                final card3 = _HighlightCard(
                  key: ValueKey('highlight_projects_$animationTrigger'),
                  value: '20+ Projects',
                  numericTarget: 20,
                  suffix: '+ Projects',
                  label: 'Built & Deployed',
                  icon: Icons.layers_rounded,
                  accentColor: AppColors.cyanPrimary,
                  animationTrigger: animationTrigger,
                  isCentered: true,
                  staggerIndex: 2,
                );
                final card4 = _HighlightCard(
                  key: ValueKey('highlight_commitment_$animationTrigger'),
                  value: '100%',
                  numericTarget: 100,
                  suffix: '%',
                  label: 'Commitment',
                  subtitle: 'Quality & Learning',
                  icon: Icons.verified_rounded,
                  accentColor: const Color(0xFF10B981),
                  animationTrigger: animationTrigger,
                  isCentered: true,
                  staggerIndex: 3,
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: card1),
                          const SizedBox(width: 12),
                          Expanded(child: card2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: card3),
                          const SizedBox(width: 12),
                          Expanded(child: card4),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Tablet (600px - 1000px): 2 columns, Desktop (> 1000px): 4 columns
              final int columns = constraints.maxWidth < 1000 ? 2 : 4;
              final double cardWidth =
                  (constraints.maxWidth - ((columns - 1) * 16)) / columns;

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
                    isCentered: false,
                    staggerIndex: 0,
                  ),
                  _HighlightCard(
                    key: ValueKey('highlight_releases_$animationTrigger'),
                    width: cardWidth,
                    value: '350+ Releases',
                    numericTarget: 350,
                    suffix: '+ Releases',
                    label: 'Play Store & App Store',
                    icon: Icons.rocket_launch_outlined,
                    accentColor: const Color(0xFFF59E0B),
                    animationTrigger: animationTrigger,
                    isCentered: false,
                    staggerIndex: 1,
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
                    isCentered: false,
                    staggerIndex: 2,
                  ),
                  _HighlightCard(
                    key: ValueKey('highlight_commitment_$animationTrigger'),
                    width: cardWidth,
                    value: '100%',
                    numericTarget: 100,
                    suffix: '%',
                    label: 'Commitment',
                    subtitle: 'Quality & Learning',
                    icon: Icons.verified_outlined,
                    accentColor: const Color(0xFF10B981),
                    animationTrigger: animationTrigger,
                    isCentered: false,
                    staggerIndex: 3,
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
            'With 4+ years of experience in mobile application development, I specialize in building high-quality, scalable applications using Flutter and Dart. I enjoy creating intuitive user interfaces, implementing clean architecture, integrating APIs, and delivering reliable applications for real-world needs.',
            style: AppTypography.getBodyMedium(secondaryTextColor)
                .copyWith(height: 1.6),
          ),
          const SizedBox(height: 14),
          Text(
            'I\'m also eager to expand my expertise in Flutter Web, modern web technologies, cloud services, and emerging tools. I believe in continuous learning, exploring new technologies, and improving my skills through practical projects and collaboration.',
            style: AppTypography.getBodyMedium(secondaryTextColor)
                .copyWith(height: 1.6),
          ),
          const SizedBox(height: 14),
          Text(
            'Based in Surat, Gujarat, I\'m open to onsite opportunities in Surat, remote roles, and freelance projects where I can contribute my experience, take on new challenges, and grow as a developer.',
            style: AppTypography.getBodyMedium(secondaryTextColor)
                .copyWith(height: 1.6),
          ),
          const SizedBox(height: 18),
          Divider(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildPillChip(
                label: '4+ Years Experience',
                backgroundColor: isDark
                    ? AppColors.bluePrimary.withOpacity(0.18)
                    : AppColors.bluePrimary.withOpacity(0.08),
                borderColor: isDark
                    ? AppColors.bluePrimary.withOpacity(0.45)
                    : AppColors.bluePrimary.withOpacity(0.25),
                textColor: isDark
                    ? const Color(0xFF60A5FA)
                    : AppColors.bluePrimary,
              ),
              _buildPillChip(
                label: 'Flutter & Dart',
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                borderColor: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.1),
                textColor: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
              _buildPillChip(
                label: 'Exploring Flutter Web',
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                borderColor: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.1),
                textColor: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
              _buildPillChip(
                label: 'Open to Opportunities',
                backgroundColor: isDark
                    ? const Color(0xFF10B981).withOpacity(0.16)
                    : const Color(0xFF10B981).withOpacity(0.08),
                borderColor: isDark
                    ? const Color(0xFF10B981).withOpacity(0.45)
                    : const Color(0xFF10B981).withOpacity(0.3),
                textColor: isDark
                    ? const Color(0xFF34D399)
                    : const Color(0xFF059669),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillChip({
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
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

              // 3D Anime Character - Senior Software Engineer
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/images/developer_character_business.png',
                  height: isMobile ? 260 : 320,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: isMobile ? 180 : 220,
                    height: isMobile ? 220 : 280,
                    decoration: BoxDecoration(
                      color: AppColors.violetPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: AppColors.violetPrimary,
                    ),
                  ),
                ),
              ),

              // Floating Badge: Clean Architecture Specialist
              Positioned(
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? AppColors.violetPrimary.withOpacity(0.4)
                          : AppColors.violetPrimary.withOpacity(0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.violetPrimary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 15,
                        color: AppColors.cyanPrimary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Clean Architecture Specialist',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : AppColors.darkBackground,
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

class _HighlightCard extends StatelessWidget {
  final double? width;
  final String value;
  final int? numericTarget;
  final String suffix;
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final int animationTrigger;
  final bool isCentered;
  final int staggerIndex;

  const _HighlightCard({
    super.key,
    this.width,
    required this.value,
    this.numericTarget,
    this.suffix = '',
    required this.label,
    this.subtitle,
    required this.icon,
    required this.accentColor,
    this.animationTrigger = 0,
    this.isCentered = false,
    this.staggerIndex = 0,
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

    final cardContent = isCentered
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(isDark ? 0.16 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accentColor.withOpacity(isDark ? 0.32 : 0.22),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: numericTarget != null
                    ? _AnimatedCounterText(
                        key: ValueKey('counter_${label}_$animationTrigger'),
                        targetValue: numericTarget!,
                        suffix: suffix,
                        fallbackText: value,
                        isCentered: true,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      )
                    : Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: subtitle != null ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: secondaryTextColor,
                  height: 1.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor.withOpacity(0.85),
                    height: 1.2,
                  ),
                ),
              ],
            ],
          )
        : Column(
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
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: numericTarget != null
                    ? _AnimatedCounterText(
                        key: ValueKey('counter_${label}_$animationTrigger'),
                        targetValue: numericTarget!,
                        suffix: suffix,
                        fallbackText: value,
                        isCentered: false,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: subtitle != null ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: secondaryTextColor,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor.withOpacity(0.85),
                  ),
                ),
              ],
            ],
          );

    final card = GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: isCentered ? 12 : 16,
        vertical: isCentered ? 18 : 14,
      ),
      child: cardContent,
    );

    final revealedCard = ScrollReveal(
      staggerIndex: staggerIndex,
      slideDistance: 18.0,
      child: card,
    );

    if (width != null) {
      return SizedBox(width: width, child: revealedCard);
    }
    return revealedCard;
  }
}

class _AnimatedCounterText extends StatelessWidget {
  final int targetValue;
  final String suffix;
  final String fallbackText;
  final TextStyle style;
  final bool isCentered;

  const _AnimatedCounterText({
    super.key,
    required this.targetValue,
    required this.suffix,
    required this.fallbackText,
    required this.style,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) {
      return Text(
        '$targetValue$suffix',
        style: style,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
      );
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
          alignment: isCentered ? Alignment.center : Alignment.centerLeft,
          child: Opacity(
            opacity: (0.35 + 0.65 * progress).clamp(0.0, 1.0),
            child: Text(
              '${value.toInt()}$suffix',
              style: style,
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
            ),
          ),
        );
      },
    );
  }
}
