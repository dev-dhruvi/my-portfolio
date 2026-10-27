import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Floating frosted glassmorphic pill navbar matching the modern design
/// with animated nav pills, theme toggle, and responsive mobile trigger.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String sectionKey)? onNavItemSelected;
  final VoidCallback? onOpenDrawer;

  const NavBar({super.key, this.onNavItemSelected, this.onOpenDrawer});

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = AppBreakpoints.isCompactNav(context);
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    final navBgColor = isDark
        ? AppColors.darkGlassBackground
        : AppColors.lightGlassBackground;
    final navBorderColor = isDark
        ? AppColors.darkGlassBorder
        : AppColors.lightGlassBorder;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? (screenWidth < 600 ? 12 : 20) : 32,
        vertical: 14,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxContentWidth,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 14 : 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: navBgColor,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: navBorderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.4)
                          : AppColors.violetPrimary.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Monogram / Initials
                    Flexible(
                      child: InkWell(
                        onTap: () => onNavItemSelected?.call('hero'),
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.violetPrimary.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'DP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                AppConstants.developerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Desktop Navigation Menu
                    if (!isCompact) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavPill(
                            title: 'Home',
                            onTap: () => onNavItemSelected?.call('hero'),
                          ),
                          _NavPill(
                            title: 'Projects',
                            onTap: () => onNavItemSelected?.call('projects'),
                          ),
                          _NavPill(
                            title: 'Experience',
                            onTap: () => onNavItemSelected?.call('experience'),
                          ),
                          _NavPill(
                            title: 'Skills',
                            onTap: () => onNavItemSelected?.call('skills'),
                          ),
                          _NavPill(
                            title: 'About',
                            onTap: () => onNavItemSelected?.call('about'),
                          ),
                          _NavPill(
                            title: 'Education',
                            onTap: () => onNavItemSelected?.call('education'),
                          ),
                        ],
                      ),

                      // Right actions: Call Icon + Theme Toggle
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Call Icon Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.04),
                            ),
                            child: IconButton(
                              tooltip: 'Contact / Call',
                              icon: Icon(
                                Icons.phone_in_talk_rounded,
                                color: isDark
                                    ? AppColors.cyanLight
                                    : AppColors.violetDark,
                                size: 18,
                              ),
                              onPressed: () =>
                                  onNavItemSelected?.call('contact'),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Theme Switcher Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.04),
                            ),
                            child: IconButton(
                              tooltip: isDark
                                  ? 'Switch to Light Theme'
                                  : 'Switch to Dark Theme',
                              icon: Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                color: isDark
                                    ? AppColors.cyanLight
                                    : AppColors.violetDark,
                                size: 18,
                              ),
                              onPressed: () => themeController.toggleTheme(),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Tablet / Mobile Right Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Contact / Call',
                            icon: Icon(
                              Icons.phone_in_talk_rounded,
                              color: isDark
                                  ? AppColors.cyanLight
                                  : AppColors.violetDark,
                              size: 20,
                            ),
                            onPressed: () => onNavItemSelected?.call('contact'),
                          ),
                          IconButton(
                            tooltip: isDark
                                ? 'Switch to Light Theme'
                                : 'Switch to Dark Theme',
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: isDark
                                  ? AppColors.cyanLight
                                  : AppColors.violetDark,
                              size: 20,
                            ),
                            onPressed: () => themeController.toggleTheme(),
                          ),
                          IconButton(
                            tooltip: 'Open navigation menu',
                            icon: Icon(
                              Icons.menu_rounded,
                              color: isDark ? Colors.white : Colors.black87,
                              size: 26,
                            ),
                            onPressed: onOpenDrawer,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavPill({required this.title, required this.onTap});

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = _isHovered
        ? (isDark ? AppColors.cyanLight : AppColors.violetPrimary)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark
                      ? AppColors.violetPrimary.withOpacity(0.18)
                      : AppColors.violetPrimary.withOpacity(0.10))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
