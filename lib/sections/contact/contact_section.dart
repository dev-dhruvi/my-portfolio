import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/animations/parallax_widget.dart';
import '../../widgets/animations/scroll_reveal.dart';
import '../../widgets/animations/staggered_entrance.dart';

/// Contact section providing direct inquiry channels (Email, WhatsApp, LinkedIn, GitHub)
/// paired with the 3D contact character illustration and the "Ready to Build" callout banner.
class ContactSection extends StatefulWidget {
  final Profile profile;

  const ContactSection({super.key, required this.profile});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  void _openDirectEmail() {
    UrlLauncherUtil.openEmail(
      widget.profile.email.isNotEmpty
          ? widget.profile.email
          : AppConstants.email,
    );
  }

  void _openWhatsApp() {
    UrlLauncherUtil.openWhatsApp(
      AppConstants.whatsappNumber,
      text: AppConstants.whatsappDefaultText,
      context: context,
    );
  }

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
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 20 : (isMobile ? 24 : 28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Tag & Header with clipped text reveal
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
                const Text(
                  'GET IN TOUCH',
                  style: TextStyle(
                    color: AppColors.cyanPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Main Headline with Gradient and clipped reveal
          ScrollReveal.clippedText(
            staggerIndex: 1,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Let's Discuss Your Next ",
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 34,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6), // Violet
                          Color(0xFFD946EF), // Magenta
                          Color(0xFF06B6D4), // Cyan
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Mobile App',
                        style: TextStyle(
                          fontSize: isMobile ? 26 : 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          ScrollReveal(
            staggerIndex: 2,
            slideDistance: 14.0,
            child: Text(
              'Have a project in mind, need a skilled Flutter developer, or want to discuss an opportunity? Reach out via direct email, WhatsApp, LinkedIn, or GitHub.',
              style: AppTypography.getBodyLarge(secondaryTextColor),
            ),
          ),
          const SizedBox(height: 32),

          // Responsive Two-Column Layout
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: StaggeredEntrance(
                    index: 0,
                    child: _buildLeftOverview(
                      context,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isMobile: false,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 6,
                  child: StaggeredEntrance(
                    index: 1,
                    child: _buildRightContactCard(
                      context,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      isMobile: false,
                    ),
                  ),
                ),
              ],
            )
          else if (isTablet)
            Column(
              children: [
                StaggeredEntrance(
                  index: 0,
                  child: _buildLeftOverview(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: false,
                  ),
                ),
                const SizedBox(height: 28),
                StaggeredEntrance(
                  index: 1,
                  child: _buildRightContactCard(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: false,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                StaggeredEntrance(
                  index: 0,
                  child: _buildLeftOverview(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: true,
                  ),
                ),
                const SizedBox(height: 24),
                StaggeredEntrance(
                  index: 1,
                  child: _buildRightContactCard(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isMobile: true,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  /// Left-side: Character stage and availability indicators.
  Widget _buildLeftOverview(
    BuildContext context, {
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // 3D Cartoon Contact Character Stage with "Let's Connect" scribble badge
        Center(
          child: ParallaxWidget(
            speed: -0.05,
            maxOffset: 20,
            child: _ContactCharacterStage(isMobile: isMobile, isDark: isDark),
          ),
        ),
        const SizedBox(height: 24),

        // Status & Availability Indicators Row
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              // Available for new opportunities
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981), // Emerald green
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Available for new opportunities',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),

              // Quick response time indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 15,
                    color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Usually replies within a day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Right-side: "Ready to Build" Card at top, followed by 2 rows of contact channels.
  /// Row 1: Email and WhatsApp
  /// Row 2: GitHub and LinkedIn
  Widget _buildRightContactCard(
    BuildContext context, {
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isMobile,
  }) {
    final githubUrl = widget.profile.githubUrl.isNotEmpty
        ? widget.profile.githubUrl
        : AppConstants.defaultGithubUrl;
    final linkedinUrl = widget.profile.linkedinUrl.isNotEmpty
        ? widget.profile.linkedinUrl
        : AppConstants.defaultLinkedinUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. "Ready to Build" Callout Card with subtle reveal
        ScrollReveal(
          staggerIndex: 0,
          slideDistance: 16.0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 24,
              vertical: isMobile ? 20 : 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1E1B4B).withOpacity(0.85),
                        const Color(0xFF0F172A).withOpacity(0.92),
                      ]
                    : [const Color(0xFFEEF2FF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.violetPrimary.withOpacity(
                  isDark ? 0.35 : 0.25,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.violetPrimary.withOpacity(
                    isDark ? 0.12 : 0.05,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ready to Build Scalable Mobile Experiences Together?",
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Whether you need a dedicated Flutter developer, architectural guidance, or help shipping production releases — let's connect.",
                  style: TextStyle(
                    fontSize: isMobile ? 12.5 : 14,
                    color: secondaryTextColor,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Direct Contact Channels:
        // Row 1: Email and WhatsApp with staggered entrance
        Row(
          children: [
            Expanded(
              child: ScrollReveal(
                staggerIndex: 1,
                slideDistance: 14.0,
                child: _InteractiveContactActionCard(
                  onTap: _openDirectEmail,
                  isDark: isDark,
                  accentColor: const Color(0xFF8B5CF6),
                  backgroundGradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF7C3AED).withOpacity(0.20),
                            const Color(0xFF6366F1).withOpacity(0.08),
                          ]
                        : [const Color(0xFFF5F3FF), Colors.white],
                  ),
                  iconWidget: Container(
                    width: isMobile ? 36 : 40,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.mail_rounded,
                      size: isMobile ? 18 : 20,
                      color: const Color(0xFFA78BFA),
                    ),
                  ),
                  title: 'Email',
                  subtitle: 'Send an email directly',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Expanded(
              child: ScrollReveal(
                staggerIndex: 2,
                slideDistance: 14.0,
                child: _InteractiveContactActionCard(
                  onTap: _openWhatsApp,
                  isDark: isDark,
                  accentColor: const Color(0xFF10B981),
                  backgroundGradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF10B981).withOpacity(0.22),
                            const Color(0xFF059669).withOpacity(0.08),
                          ]
                        : [const Color(0xFFECFDF5), Colors.white],
                  ),
                  iconWidget: Container(
                    width: isMobile ? 36 : 40,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _WhatsAppIconWidget(size: isMobile ? 18 : 20),
                    ),
                  ),
                  title: 'WhatsApp',
                  subtitle: 'Connect on WhatsApp',
                  isMobile: isMobile,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 10 : 12),

        // Row 2: GitHub and LinkedIn with staggered entrance
        Row(
          children: [
            Expanded(
              child: ScrollReveal(
                staggerIndex: 3,
                slideDistance: 14.0,
                child: _InteractiveContactActionCard(
                  onTap: () =>
                      UrlLauncherUtil.openUrl(githubUrl, context: context),
                  isDark: isDark,
                  accentColor: isDark
                      ? const Color(0xFFA78BFA)
                      : const Color(0xFF475569),
                  backgroundGradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B).withOpacity(0.7),
                            const Color(0xFF0F172A).withOpacity(0.9),
                          ]
                        : [const Color(0xFFF8FAFC), Colors.white],
                  ),
                  iconWidget: Container(
                    width: isMobile ? 36 : 40,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : const Color(0xFF24292F))
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.github,
                        size: isMobile ? 16 : 18,
                        color: isDark ? Colors.white : const Color(0xFF24292F),
                      ),
                    ),
                  ),
                  title: 'GitHub',
                  subtitle: 'Explore repositories',
                  isMobile: isMobile,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Expanded(
              child: ScrollReveal(
                staggerIndex: 4,
                slideDistance: 14.0,
                child: _InteractiveContactActionCard(
                  onTap: () =>
                      UrlLauncherUtil.openUrl(linkedinUrl, context: context),
                  isDark: isDark,
                  accentColor: const Color(0xFF0A66C2),
                  backgroundGradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF0A66C2).withOpacity(0.20),
                            const Color(0xFF0284C7).withOpacity(0.08),
                          ]
                        : [const Color(0xFFF0F9FF), Colors.white],
                  ),
                  iconWidget: Container(
                    width: isMobile ? 36 : 40,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A66C2).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.linkedinIn,
                        size: isMobile ? 16 : 18,
                        color: const Color(0xFF0A66C2),
                      ),
                    ),
                  ),
                  title: 'LinkedIn',
                  subtitle: 'Connect on LinkedIn',
                  isMobile: isMobile,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Interactive direct action card for Email, WhatsApp, LinkedIn, GitHub
class _InteractiveContactActionCard extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;
  final Color accentColor;
  final Gradient backgroundGradient;
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final bool isMobile;

  const _InteractiveContactActionCard({
    required this.onTap,
    required this.isDark,
    required this.accentColor,
    required this.backgroundGradient,
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    this.isMobile = false,
  });

  @override
  State<_InteractiveContactActionCard> createState() =>
      _InteractiveContactActionCardState();
}

class _InteractiveContactActionCardState
    extends State<_InteractiveContactActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered && mounted) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (_isHovered && mounted) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -2.5 : 0.0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 12 : 16,
            vertical: widget.isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            gradient: widget.backgroundGradient,
            color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : widget.accentColor.withOpacity(widget.isDark ? 0.35 : 0.25),
              width: _isHovered ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(
                  _isHovered ? 0.22 : (widget.isDark ? 0.08 : 0.04),
                ),
                blurRadius: _isHovered ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              widget.iconWidget,
              SizedBox(width: widget.isMobile ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: widget.isMobile ? 13.5 : 14.5,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? Colors.white
                            : AppColors.darkBackground,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: widget.isMobile ? 11 : 12,
                          color: widget.isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.subtitle.isNotEmpty && !widget.isMobile)
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: widget.accentColor.withOpacity(_isHovered ? 1.0 : 0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Character illustration stage with glowing circular backdrop and "Let's Connect" scribble badge
class _ContactCharacterStage extends StatelessWidget {
  final bool isMobile;
  final bool isDark;

  const _ContactCharacterStage({required this.isMobile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double stageWidth = isMobile ? 220 : 250;
    final double stageHeight = isMobile ? 220 : 250;

    return SizedBox(
      width: stageWidth,
      height: stageHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ambient glowing circular backdrop
          Container(
            width: stageWidth * 0.88,
            height: stageHeight * 0.88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(isDark ? 0.40 : 0.25),
                  const Color(0xFF06B6D4).withOpacity(isDark ? 0.22 : 0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Outer glass ring
          Container(
            width: stageWidth * 0.94,
            height: stageHeight * 0.94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF8B5CF6).withOpacity(0.35)
                    : const Color(0xFF8B5CF6).withOpacity(0.25),
                width: 1.5,
              ),
            ),
          ),

          // 3D Cartoon Contact Character
          Image.asset(
            'assets/images/developer_character_contact.png',
            height: isMobile ? 200 : 230,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),

          // "Let's Connect" Scribble badge (top right of character)
          Positioned(
            top: isMobile ? 12 : 16,
            right: isMobile ? 4 : 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF131B34) : Colors.white)
                    .withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cyanPrimary.withOpacity(0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanPrimary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Let's Connect",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppColors.cyanLight,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.call_made_rounded,
                    size: 12,
                    color: AppColors.cyanLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pixel-perfect WhatsApp circular logo icon
class _WhatsAppIconWidget extends StatelessWidget {
  final double size;

  const _WhatsAppIconWidget({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF25D366), // WhatsApp Brand Green
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.call_rounded, size: size * 0.60, color: Colors.white),
    );
  }
}
