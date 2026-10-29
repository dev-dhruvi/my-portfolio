import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/project.dart';
import 'app_network_image.dart';

/// Modern, image-focused Project Card adhering to Dhruvi Patel's portfolio design system.
///
/// Features:
/// - Prominent top image frame with `BoxFit.contain` on subtle background.
/// - Two independent labels: Platform category & Project type (no 'Featured' badge).
/// - Title & 2-line clamped description with consistent vertical rhythm.
/// - Bottom row: Company name / 'Personal Project' on left; independent external links on right.
/// - Desktop hover lift, glow, and focus ring; permanent touch affordance on mobile/tablet.
class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final bool? isDesktopOrTablet;
  final bool enable3D;
  final double? imageHeight;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isDesktopOrTablet,
    this.enable3D = false,
    this.imageHeight,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  IconData _getPlatformIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('web') && lower.contains('mobile')) {
      return Icons.devices_rounded;
    } else if (lower.contains('web')) {
      return Icons.language_rounded;
    }
    return Icons.phone_iphone_rounded;
  }

  Widget _buildStoreIconButton({
    required BuildContext context,
    required String url,
    required Widget icon,
    required String tooltip,
    required bool isDark,
    Color? accentColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => UrlLauncherUtil.openUrl(url, context: context),
          borderRadius: BorderRadius.circular(6),
          hoverColor: (accentColor ?? AppColors.violetPrimary).withOpacity(
            0.18,
          ),
          splashColor: (accentColor ?? AppColors.violetPrimary).withOpacity(
            0.24,
          ),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isDark
                  ? (accentColor?.withOpacity(0.12) ?? const Color(0xFF1E293B))
                  : (accentColor?.withOpacity(0.08) ?? const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark
                    ? (accentColor?.withOpacity(0.26) ??
                          AppColors.darkCardBorder)
                    : (accentColor?.withOpacity(0.20) ??
                          AppColors.lightCardBorder),
                width: 1,
              ),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcons(BuildContext context, {required bool isDark}) {
    final project = widget.project;
    final List<Widget> actionIcons = [];

    if (project.playStoreUrl.trim().isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.playStoreUrl,
          tooltip: 'Google Play Store',
          isDark: isDark,
          accentColor: AppColors.cyanPrimary,
          icon: FaIcon(
            FontAwesomeIcons.googlePlay,
            size: 13,
            color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
          ),
        ),
      );
    }

    if (project.appStoreUrl.trim().isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.appStoreUrl,
          tooltip: 'Apple App Store',
          isDark: isDark,
          accentColor: AppColors.violetPrimary,
          icon: FaIcon(
            FontAwesomeIcons.appStoreIos,
            size: 14,
            color: isDark ? AppColors.violetLight : AppColors.violetPrimary,
          ),
        ),
      );
    }

    if (project.githubUrl.trim().isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.githubUrl,
          tooltip: 'GitHub Repository',
          isDark: isDark,
          accentColor: const Color(0xFFA78BFA),
          icon: FaIcon(
            FontAwesomeIcons.github,
            size: 14,
            color: isDark ? Colors.white : const Color(0xFF24292F),
          ),
        ),
      );
    }

    if (project.demoUrl.trim().isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.demoUrl,
          tooltip: 'Live Demo',
          isDark: isDark,
          accentColor: AppColors.cyanPrimary,
          icon: Icon(
            Icons.open_in_new_rounded,
            size: 14,
            color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
          ),
        ),
      );
    }

    if (actionIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actionIcons.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          actionIcons[i],
        ],
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: primaryColor.withOpacity(0.32), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppBreakpoints.isMobile(context);
    final isDesktopOrTablet = widget.isDesktopOrTablet ?? !isMobile;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final project = widget.project;

    final platformCategory = project.platformCategory;
    final effectiveImageHeight =
        widget.imageHeight ?? (isMobile ? 220.0 : 185.0);

    final imageBgColor = isDark
        ? const Color(0xFF0A0F1D)
        : const Color(0xFFF1F5F9);

    final cardBgColor = isDark
        ? (_isHovered || _isFocused
              ? const Color(0xFF14192B)
              : AppColors.darkCard)
        : (_isHovered || _isFocused
              ? const Color(0xFFFFFFFF)
              : AppColors.lightCard);

    final borderColor = (_isHovered || _isFocused)
        ? AppColors.violetPrimary.withOpacity(0.85)
        : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder);

    final isLifted = (_isHovered || _isFocused) && isDesktopOrTablet;

    return FocusableActionDetector(
      onShowFocusHighlight: (focus) => setState(() => _isFocused = focus),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => widget.onTap(),
        ),
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, isLifted ? -6.0 : 0.0, 0),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isLifted ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (isLifted) ...[
                  BoxShadow(
                    color: AppColors.violetPrimary.withOpacity(
                      isDark ? 0.26 : 0.16,
                    ),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.cyanPrimary.withOpacity(
                      isDark ? 0.12 : 0.08,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ] else ...[
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Image Frame:
                  // Consistent image frame, BoxFit.cover to fit actual width & height edge-to-edge
                  // Clean and unobstructed with NO overlays on top of the image
                  Container(
                    height: effectiveImageHeight,
                    width: double.infinity,
                    color: imageBgColor,
                    child: AppNetworkImage(
                      imageUrl: project.displayImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 0,
                      placeholderText: project.title,
                      fallbackIcon: _getPlatformIcon(platformCategory),
                    ),
                  ),

                  // Card Content Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Project Title + Platform Category Pill (Beside Title)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      (_isHovered || _isFocused) &&
                                          isDesktopOrTablet
                                      ? (isDark
                                            ? AppColors.cyanPrimary
                                            : AppColors.violetPrimary)
                                      : textColor,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Platform Category Pill (e.g. Mobile App, Website)
                            _buildBadge(
                              icon: _getPlatformIcon(platformCategory),
                              label: platformCategory,
                              isDark: isDark,
                              primaryColor: isDark
                                  ? AppColors.cyanLight
                                  : AppColors.cyanDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Concise description limited to two lines
                        SizedBox(
                          height: 38,
                          child: Text(
                            project.shortDescription.isNotEmpty
                                ? project.shortDescription
                                : project.fullDescription,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.45,
                              color: secondaryTextColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtle Divider
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? AppColors.darkCardBorder.withOpacity(0.6)
                              : AppColors.lightCardBorder.withOpacity(0.8),
                        ),

                        const SizedBox(height: 10),

                        // Bottom Information Row:
                        // Left: Company Name (Client/Professional) or 'Personal Project'
                        // Right: Only available external link icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Information
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    project.companyName.isNotEmpty
                                        ? Icons.apartment_rounded
                                        : Icons.person_rounded,
                                    size: 13,
                                    color: isDark
                                        ? AppColors.violetLight
                                        : AppColors.violetPrimary,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      project.companyName.isNotEmpty
                                          ? project.companyName
                                          : 'Personal Project',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryTextColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Right Information: Independent external link icons
                            _buildActionIcons(context, isDark: isDark),
                          ],
                        ),
                      ],
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
