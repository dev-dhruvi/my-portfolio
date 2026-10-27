import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/animations/animated_text_effects.dart';
import '../../widgets/animations/staggered_entrance.dart';

/// Redesigned Hero Section featuring 3D anime cartoon character illustration,
/// animated floating frosted glass badges, availability status pill,
/// expandable biography, and 3-tier responsive layout (Website, Tablet, App).
class HeroSection extends StatefulWidget {
  final Profile profile;
  final Function(String sectionKey)? onNavigate;

  const HeroSection({super.key, required this.profile, this.onNavigate});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    // Minimum height ensures the Hero section cleanly fills the full first viewport
    // on desktop screens so the following section lands cleanly below the fold,
    // without forcing excessive height that pushes CTAs below the fold on standard laptops.
    final double? minHeroHeight = (!isMobile && !isTablet)
        ? math.max(460.0, screenHeight - 88.0)
        : null;

    return Container(
      constraints: minHeroHeight != null
          ? BoxConstraints(minHeight: minHeroHeight)
          : null,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? 20
            : (isTablet ? 24 : (screenHeight < 800 ? 14 : 26)),
        horizontal: isMobile ? 8 : 16,
      ),
      child: isMobile
          ? _buildMobileLayout(
              context,
              textColor,
              secondaryTextColor,
              isDark,
              disableAnimations,
            )
          : (isTablet
                ? _buildTabletLayout(
                    context,
                    textColor,
                    secondaryTextColor,
                    isDark,
                    disableAnimations,
                  )
                : _buildDesktopLayout(
                    context,
                    textColor,
                    secondaryTextColor,
                    isDark,
                    disableAnimations,
                  )),
    );
  }

  // ===========================================================================
  // 1. DESKTOP LAYOUT (> 1024px)
  // ===========================================================================
  Widget _buildDesktopLayout(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
    bool disableAnimations,
  ) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompactHeight = screenHeight < 800;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Introduction, Bio, and CTAs
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StaggeredEntrance(
                index: 0,
                child: _buildStatusBadge(isDark, disableAnimations),
              ),
              SizedBox(height: isCompactHeight ? 12 : 18),
              StaggeredEntrance(
                index: 1,
                child: _buildHeroText(
                  context,
                  textColor,
                  secondaryTextColor,
                  isDark,
                  isCentered: false,
                ),
              ),
              SizedBox(height: isCompactHeight ? 20 : 30),
              StaggeredEntrance(
                index: 2,
                child: _buildActionButtons(context, isCentered: false),
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // Right Column: 3D Anime Character + Floating Glass Badges
        Expanded(
          flex: 5,
          child: Center(
            child: StaggeredEntrance(
              index: 1,
              slideOffset: 0.1,
              child: SizedBox(
                height: (screenHeight - 160.0).clamp(360.0, 480.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RepaintBoundary(
                    child: _buildCharacterStageDesktop(
                      isDark,
                      disableAnimations,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. TABLET LAYOUT (768px – 1024px)
  // ===========================================================================
  Widget _buildTabletLayout(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
    bool disableAnimations,
  ) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StaggeredEntrance(
          index: 0,
          child: _buildStatusBadge(isDark, disableAnimations),
        ),
        const SizedBox(height: 20),
        StaggeredEntrance(
          index: 1,
          slideOffset: 0.1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: RepaintBoundary(
              child: _buildCharacterStageTablet(isDark, disableAnimations),
            ),
          ),
        ),
        const SizedBox(height: 28),
        StaggeredEntrance(
          index: 2,
          child: _buildHeroText(
            context,
            textColor,
            secondaryTextColor,
            isDark,
            isCentered: true,
          ),
        ),
        const SizedBox(height: 28),
        StaggeredEntrance(
          index: 3,
          child: _buildActionButtons(context, isCentered: true),
        ),
      ],
    );

    if (Scrollable.maybeOf(context) != null) {
      return content;
    }
    return SingleChildScrollView(child: content);
  }

  // ===========================================================================
  // 3. APP / MOBILE LAYOUT (< 768px)
  // ===========================================================================
  Widget _buildMobileLayout(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
    bool disableAnimations,
  ) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StaggeredEntrance(
          index: 0,
          child: _buildStatusBadge(isDark, disableAnimations),
        ),
        const SizedBox(height: 18),
        StaggeredEntrance(
          index: 1,
          slideOffset: 0.1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: RepaintBoundary(child: _buildCharacterStageMobile(isDark)),
          ),
        ),
        const SizedBox(height: 22),
        StaggeredEntrance(
          index: 2,
          child: _buildHeroText(
            context,
            textColor,
            secondaryTextColor,
            isDark,
            isCentered: true,
          ),
        ),
        const SizedBox(height: 24),
        StaggeredEntrance(
          index: 3,
          child: _buildActionButtons(context, isCentered: true),
        ),
      ],
    );

    if (Scrollable.maybeOf(context) != null) {
      return content;
    }
    return SingleChildScrollView(child: content);
  }

  // ===========================================================================
  // STATUS BADGE (Available For Hire with pulsing dot)
  // ===========================================================================
  Widget _buildStatusBadge(bool isDark, bool disableAnimations) {
    Widget dot = Container(
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
    );

    if (!disableAnimations) {
      dot = dot
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1.2, 1.2),
            duration: 1200.ms,
          );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.violetPrimary.withOpacity(0.14)
            : AppColors.violetPrimary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? AppColors.violetPrimary.withOpacity(0.35)
              : AppColors.violetPrimary.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot,
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Available for Senior Flutter Developer Roles',
                maxLines: 1,
                style: TextStyle(
                  color: isDark ? AppColors.cyanLight : AppColors.violetPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HERO TEXT & EXPANDABLE BIO
  // ===========================================================================
  Widget _buildHeroText(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isDark, {
    required bool isCentered,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = screenWidth < AppBreakpoints.mobileMax;
    final double headlineFontSize = isMobile
        ? (screenWidth < 360 ? 25.0 : 32.0)
        : ((screenWidth < 1200 || screenHeight < 800) ? 38.0 : 48.0);

    return Column(
      crossAxisAlignment: isCentered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Prominent Name & Professional Role Badge
        Wrap(
          alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            Text(
              "Hi, I'm",
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w700,
                color: secondaryTextColor,
              ),
            ),
            Text(
              AppConstants.developerName,
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Primary Value Proposition Headline: "Building Scalable Mobile Experiences with Flutter"
        RichText(
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontSize: headlineFontSize,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: -1.2,
              height: 1.15,
            ),
            children: [
              const TextSpan(text: 'Building Scalable\n'),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShimmerGradientText(
                  'Mobile Experiences',
                  colors: const [
                    Color(0xFF06B6D4), // Cyan
                    Color(0xFF8B5CF6), // Violet
                    Color(0xFFD946EF), // Magenta
                    Color(0xFF06B6D4), // Cyan
                  ],
                  style: TextStyle(
                    fontSize: headlineFontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                  ),
                ),
              ),
              const TextSpan(text: ' with Flutter'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Supporting Text (Exact requirement)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: isCentered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.heroSupportingText,
                textAlign: isCentered ? TextAlign.center : TextAlign.start,
                style: AppTypography.getBodyLarge(secondaryTextColor)
                    .copyWith(fontSize: isMobile ? 15 : 16.5, height: 1.55),
              ),
              const SizedBox(height: 14),
              // Highlights Row: Location, Experience & Releases
              Wrap(
                alignment: isCentered
                    ? WrapAlignment.center
                    : WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 14,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: isDark
                            ? AppColors.cyanPrimary
                            : AppColors.cyanDark,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppConstants.location,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 15,
                        color: isDark
                            ? AppColors.violetLight
                            : AppColors.violetPrimary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '4+ Years Exp',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // ACTION BUTTONS (1. View My Projects & 2. Download CV)
  // ===========================================================================
  Widget _buildActionButtons(BuildContext context, {required bool isCentered}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppBreakpoints.isMobile(context);

    return Wrap(
      alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 14,
      runSpacing: 12,
      children: [
        // Primary CTA: View My Projects (Navigates to Projects Section)
        Semantics(
          button: true,
          label: 'Navigate to Projects Section',
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.violetPrimary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onNavigate?.call('projects');
                },
                borderRadius: BorderRadius.circular(14),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.rocket_launch_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'View My Projects',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              letterSpacing: 0.2,
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
        ),

        // Secondary CTA: Download CV (Glassmorphic button alongside View My Projects)
        Semantics(
          button: true,
          label: 'Download Dhruvi Patel CV Resume PDF',
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard.withOpacity(0.7)
                  : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppColors.cyanPrimary.withOpacity(0.4)
                    : AppColors.violetPrimary.withOpacity(0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isDark ? AppColors.cyanPrimary : AppColors.violetPrimary)
                          .withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  UrlLauncherUtil.openResume(context: context);
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 18 : 22,
                    vertical: isMobile ? 13 : 15,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: isDark
                            ? AppColors.cyanPrimary
                            : AppColors.violetPrimary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Download CV',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.cyanPrimary
                                  : AppColors.violetPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              letterSpacing: 0.2,
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
        ),
      ],
    );
  }

  // ===========================================================================
  // 3D ANIME CHARACTER STAGES (Desktop, Tablet, Mobile)
  // ===========================================================================
  Widget _wrapFloating(
    Widget child, {
    required double begin,
    required double end,
    required Duration duration,
    required bool disableAnimations,
  }) {
    if (disableAnimations) return child;
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: begin,
          end: end,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildCharacterStageDesktop(bool isDark, bool disableAnimations) {
    return SizedBox(
      width: 520,
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Ambient Radiant Aura Behind Character
          _buildRadiantAura(380, 380, isDark),

          // 2. 3D Cartoon Character Asset
          Positioned(
            bottom: 12,
            child: Image.asset(
              'assets/images/developer_character_3d.png',
              height: 410,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),

          // 3. Floating Badge 1: Flutter (Top Left)
          Positioned(
            top: 15,
            left: -15,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.flutter_dash,
                iconColor: const Color(0xFF02569B),
                iconBg: const Color(0xFF02569B).withOpacity(0.12),
                title: 'Flutter',
                subtitle: 'Cross-Platform',
                isDark: isDark,
              ),
              begin: 0,
              end: -10,
              duration: 2600.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 4. Floating Badge 2: Dart (Top Right)
          Positioned(
            top: 25,
            right: -15,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.code_rounded,
                iconColor: const Color(0xFF0175C2),
                iconBg: const Color(0xFF0175C2).withOpacity(0.12),
                title: 'Dart',
                subtitle: 'Language',
                isDark: isDark,
              ),
              begin: 0,
              end: -8,
              duration: 2400.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 5. Floating Badge 3: GetX (Mid Left)
          Positioned(
            top: 135,
            left: -32,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBg: const Color(0xFF8B5CF6).withOpacity(0.12),
                title: 'GetX',
                subtitle: 'State Mgmt',
                isDark: isDark,
              ),
              begin: 0,
              end: 8,
              duration: 2900.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 6. Floating Badge 4: Flutter Web (Mid Right)
          Positioned(
            top: 145,
            right: -32,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.language_rounded,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFF3B82F6).withOpacity(0.12),
                title: 'Flutter Web',
                subtitle: 'Progressive',
                isDark: isDark,
              ),
              begin: 0,
              end: 10,
              duration: 2700.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 7. Floating Badge 5: Firebase (Lower Left)
          Positioned(
            bottom: 75,
            left: -18,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFF59E0B),
                iconBg: const Color(0xFFF59E0B).withOpacity(0.12),
                title: 'Firebase',
                subtitle: 'Cloud & Auth',
                isDark: isDark,
              ),
              begin: 0,
              end: -7,
              duration: 3100.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 8. Floating Badge 6: Deployment (Lower Right)
          Positioned(
            bottom: 85,
            right: -18,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.cloud_upload_rounded,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFF10B981).withOpacity(0.12),
                title: 'Deployment',
                subtitle: 'Play & App Store',
                isDark: isDark,
              ),
              begin: 0,
              end: 9,
              duration: 2800.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // 9. Floating Badge 7: Git Version (Bottom Center Pill)
          Positioned(
            bottom: 0,
            child: _wrapFloating(
              _buildMiniTag(
                icon: Icons.alt_route_rounded,
                label: 'Git & GitHub Version Control',
                isDark: isDark,
              ),
              begin: -4,
              end: 4,
              duration: 2200.ms,
              disableAnimations: disableAnimations,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterStageTablet(bool isDark, bool disableAnimations) {
    return SizedBox(
      width: 420,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ambient Glow
          _buildRadiantAura(320, 320, isDark),

          // 3D Cartoon Character Asset
          Positioned(
            bottom: 10,
            child: Image.asset(
              'assets/images/developer_character_3d.png',
              height: 330,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Left Badges
          Positioned(
            top: 20,
            left: -10,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.flutter_dash,
                iconColor: const Color(0xFF02569B),
                iconBg: const Color(0xFF02569B).withOpacity(0.12),
                title: 'Flutter',
                subtitle: 'Framework',
                isDark: isDark,
              ),
              begin: 0,
              end: -8,
              duration: 2500.ms,
              disableAnimations: disableAnimations,
            ),
          ),
          Positioned(
            bottom: 60,
            left: -15,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF8B5CF6),
                iconBg: const Color(0xFF8B5CF6).withOpacity(0.12),
                title: 'GetX',
                subtitle: 'State Mgmt',
                isDark: isDark,
              ),
              begin: 0,
              end: 8,
              duration: 2800.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // Right Badges
          Positioned(
            top: 25,
            right: -10,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.code_rounded,
                iconColor: const Color(0xFF0175C2),
                iconBg: const Color(0xFF0175C2).withOpacity(0.12),
                title: 'Dart',
                subtitle: 'Language',
                isDark: isDark,
              ),
              begin: 0,
              end: 8,
              duration: 2600.ms,
              disableAnimations: disableAnimations,
            ),
          ),
          Positioned(
            bottom: 65,
            right: -15,
            child: _wrapFloating(
              _buildFloatingBadge(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFF59E0B),
                iconBg: const Color(0xFFF59E0B).withOpacity(0.12),
                title: 'Firebase',
                subtitle: 'Cloud DB',
                isDark: isDark,
              ),
              begin: 0,
              end: -8,
              duration: 2900.ms,
              disableAnimations: disableAnimations,
            ),
          ),

          // Bottom Center Tag
          Positioned(
            bottom: 0,
            child: _wrapFloating(
              _buildMiniTag(
                icon: Icons.alt_route_rounded,
                label: 'Git & Deployment CI/CD',
                isDark: isDark,
              ),
              begin: -3,
              end: 3,
              duration: 2200.ms,
              disableAnimations: disableAnimations,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterStageMobile(bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: 290,
          height: 290,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildRadiantAura(240, 240, isDark),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/images/developer_character_3d.png',
                  height: 260,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Mobile Docked Badges in adaptive row to prevent any screen overflow
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFloatingBadge(
              icon: Icons.flutter_dash,
              iconColor: const Color(0xFF02569B),
              iconBg: const Color(0xFF02569B).withOpacity(0.12),
              title: 'Flutter',
              subtitle: 'Mobile & Web',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.code_rounded,
              iconColor: const Color(0xFF0175C2),
              iconBg: const Color(0xFF0175C2).withOpacity(0.12),
              title: 'Dart',
              subtitle: 'Language',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.bolt_rounded,
              iconColor: const Color(0xFF8B5CF6),
              iconBg: const Color(0xFF8B5CF6).withOpacity(0.12),
              title: 'GetX',
              subtitle: 'State Mgmt',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.language_rounded,
              iconColor: const Color(0xFF3B82F6),
              iconBg: const Color(0xFF3B82F6).withOpacity(0.12),
              title: 'Flutter Web',
              subtitle: 'Responsive',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xFFF59E0B),
              iconBg: const Color(0xFFF59E0B).withOpacity(0.12),
              title: 'Firebase',
              subtitle: 'Cloud Auth',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.cloud_upload_rounded,
              iconColor: const Color(0xFF10B981),
              iconBg: const Color(0xFF10B981).withOpacity(0.12),
              title: 'Deployment',
              subtitle: 'CI/CD Pipeline',
              isDark: isDark,
            ),
            _buildFloatingBadge(
              icon: Icons.alt_route_rounded,
              iconColor: const Color(0xFFF05032),
              iconBg: const Color(0xFFF05032).withOpacity(0.12),
              title: 'Git Version',
              subtitle: 'VCS Workflow',
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // RADIANT AURA EFFECT
  // ===========================================================================
  Widget _buildRadiantAura(double width, double height, bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.violetPrimary.withOpacity(isDark ? 0.35 : 0.22),
            AppColors.cyanPrimary.withOpacity(isDark ? 0.15 : 0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  // ===========================================================================
  // FLOATING FROSTED GLASS BADGE
  // ===========================================================================
  Widget _buildFloatingBadge({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkGlassBackground.withOpacity(0.92)
            : AppColors.lightGlassBackground.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassBorder
              : AppColors.lightGlassBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : AppColors.violetPrimary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Icon(icon, size: 20, color: iconColor)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MINI AMBIENT TAG
  // ===========================================================================
  Widget _buildMiniTag({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkGlassBackground.withOpacity(0.90)
            : AppColors.lightGlassBackground.withOpacity(0.90),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkGlassBorder
              : AppColors.lightGlassBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.violetPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
