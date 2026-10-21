import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';

/// Hero Section with animated role text, glowing portrait badge,
/// concise professional introduction, and call-to-action buttons.
class HeroSection extends StatefulWidget {
  final Profile profile;
  final Function(String sectionKey)? onNavigate;

  const HeroSection({super.key, required this.profile, this.onNavigate});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _currentRoleIndex = 0;
  Timer? _roleTimer;
  bool _isBioExpanded = false;

  @override
  void initState() {
    super.initState();
    _roleTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentRoleIndex =
              (_currentRoleIndex + 1) % AppConstants.animatedRoles.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _roleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      constraints: (!isMobile && !isTablet)
          ? const BoxConstraints(minHeight: 580)
          : null,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
      child: isMobile || isTablet
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStatusBadge(isDark),
                  const SizedBox(height: 24),
                  _buildAvatar(isDark),
                  const SizedBox(height: 32),
                  _buildHeroText(
                    context,
                    textColor,
                    secondaryTextColor,
                    isDark,
                    isCentered: true,
                  ),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, isCentered: true),
                  const SizedBox(height: 28),
                  _buildSocialLinks(context, isCentered: true),
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column: Introduction & CTA
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusBadge(isDark),
                      const SizedBox(height: 16),
                      _buildHeroText(
                        context,
                        textColor,
                        secondaryTextColor,
                        isDark,
                        isCentered: false,
                      ),
                      const SizedBox(height: 36),
                      _buildActionButtons(context, isCentered: false),
                      const SizedBox(height: 32),
                      _buildSocialLinks(context, isCentered: false),
                    ],
                  ),
                ),
                const SizedBox(width: 48),

                // Right Column: Polished Avatar with Glowing Ring
                Expanded(flex: 4, child: Center(child: _buildAvatar(isDark))),
              ],
            ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.violetPrimary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.violetPrimary.withOpacity(0.3)),
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
            'Available for Senior Flutter Developer Roles',
            style: TextStyle(
              color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroText(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    bool isDark, {
    required bool isCentered,
  }) {
    return Column(
      crossAxisAlignment: isCentered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, I am',
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.cyanPrimary : AppColors.violetDark,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.profile.name,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: AppTypography.getDisplayLarge(textColor).copyWith(
            fontSize: AppBreakpoints.isMobile(context) ? 36 : 52,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),

        // Prominent Single Subtitle: Senior Flutter Developer
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isCentered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Senior Flutter Developer',
                style: TextStyle(
                  fontSize: AppBreakpoints.isMobile(context) ? 20 : 26,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.violetLight : AppColors.violetDark,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Animated Role Switcher
        Wrap(
          alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Specializing as ',
              style: TextStyle(
                fontSize: AppBreakpoints.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                AppConstants.animatedRoles[_currentRoleIndex],
                key: ValueKey<int>(_currentRoleIndex),
                style: TextStyle(
                  fontSize: AppBreakpoints.isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.cyanPrimary : AppColors.cyanDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Summary statement from resume with Read More / Read Less
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: isCentered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isCentered ? Alignment.topCenter : Alignment.topLeft,
                child: Text(
                  widget.profile.bio,
                  textAlign: isCentered ? TextAlign.center : TextAlign.start,
                  style: AppTypography.getBodyLarge(secondaryTextColor),
                  maxLines: _isBioExpanded ? null : 4,
                  overflow: _isBioExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () {
                  setState(() {
                    _isBioExpanded = !_isBioExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isBioExpanded ? 'Read Less' : 'Read More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.cyanPrimary
                              : AppColors.violetPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isBioExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.cyanPrimary
                            : AppColors.violetPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, {required bool isCentered}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 16,
      runSpacing: 12,
      children: [
        // View Projects CTA
        ElevatedButton.icon(
          onPressed: () => widget.onNavigate?.call('projects'),
          icon: const Icon(Icons.rocket_launch_outlined, size: 18),
          label: const Text('View Projects'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.violetPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: AppColors.violetPrimary.withOpacity(0.4),
          ),
        ),

        // Download Resume CTA
        OutlinedButton.icon(
          onPressed: () {
            UrlLauncherUtil.openUrl(widget.profile.resumeUrl, context: context);
          },
          icon: const Icon(Icons.description_outlined, size: 18),
          label: const Text('Download Resume'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cyanPrimary,
            side: const BorderSide(color: AppColors.cyanPrimary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Contact Me Button
        TextButton.icon(
          onPressed: () => widget.onNavigate?.call('contact'),
          icon: Icon(
            Icons.mail_outline_rounded,
            size: 18,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          label: Text(
            'Contact Me',
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark
                    ? AppColors.darkCardBorder
                    : AppColors.lightCardBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks(BuildContext context, {required bool isCentered}) {
    return Row(
      mainAxisAlignment: isCentered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        _SocialIconBtn(
          icon: const FaIcon(FontAwesomeIcons.github),
          tooltip: 'GitHub Profile',
          onTap: () => UrlLauncherUtil.openUrl(
            widget.profile.githubUrl,
            context: context,
          ),
        ),
        const SizedBox(width: 12),
        _SocialIconBtn(
          icon: const FaIcon(FontAwesomeIcons.linkedinIn),
          tooltip: 'LinkedIn Profile',
          onTap: () => UrlLauncherUtil.openUrl(
            widget.profile.linkedinUrl,
            context: context,
          ),
        ),
        const SizedBox(width: 12),
        _SocialIconBtn(
          icon: const Icon(Icons.mail_rounded),
          tooltip: 'Email Dhruvi',
          onTap: () => UrlLauncherUtil.openEmail(widget.profile.email),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glowing pulse ring
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.violetPrimary.withOpacity(0.25),
                AppColors.cyanPrimary.withOpacity(0.08),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Middle bordered circle
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.accentGlowGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.violetPrimary.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4), // gradient border width
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkCard : Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: const Text(
                      'DP',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.violetPrimary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Surat, IN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cyanPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialIconBtn extends StatefulWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark ? AppColors.darkCard : const Color(0xFFF1F5F9);
    final hoverBg = isDark
        ? AppColors.violetPrimary.withOpacity(0.2)
        : AppColors.violetPrimary.withOpacity(0.12);

    final defaultBorder = isDark
        ? AppColors.darkCardBorder
        : AppColors.lightCardBorder;
    final hoverBorder = isDark
        ? AppColors.violetPrimary
        : AppColors.violetPrimary;

    final defaultIconColor = isDark
        ? Colors.white70
        : AppColors.textPrimaryLight;
    final hoverIconColor = isDark
        ? AppColors.cyanLight
        : AppColors.violetPrimary;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _isHovered ? hoverBg : defaultBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered ? hoverBorder : defaultBorder,
              ),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  size: 18,
                  color: _isHovered ? hoverIconColor : defaultIconColor,
                ),
                child: widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
