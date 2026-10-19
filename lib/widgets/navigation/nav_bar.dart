import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';

/// Navigation bar with responsive layout, theme switch, section links,
/// resume download button, and admin portal entrance.
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String sectionKey)? onNavItemSelected;
  final VoidCallback? onOpenDrawer;

  const NavBar({super.key, this.onNavItemSelected, this.onOpenDrawer});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBackground : AppColors.lightBackground)
            .withOpacity(0.85),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkCardBorder
                : AppColors.lightCardBorder,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxContentWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Logo / Initials
              Flexible(
                child: InkWell(
                  onTap: () => onNavItemSelected?.call('hero'),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violetPrimary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'DP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.developerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.getTitleMedium(
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            if (screenWidth >= 600)
                              Text(
                                screenWidth > 1150
                                    ? 'Sr. Flutter Developer'
                                    : AppConstants.primaryRole,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cyanPrimary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Desktop Navigation Menu
              if (isDesktop) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavLink(
                      title: 'About',
                      onTap: () => onNavItemSelected?.call('about'),
                    ),
                    _NavLink(
                      title: 'Skills',
                      onTap: () => onNavItemSelected?.call('skills'),
                    ),
                    _NavLink(
                      title: 'Experience',
                      onTap: () => onNavItemSelected?.call('experience'),
                    ),
                    _NavLink(
                      title: 'Projects',
                      onTap: () => onNavItemSelected?.call('projects'),
                    ),
                    _NavLink(
                      title: 'Education',
                      onTap: () => onNavItemSelected?.call('education'),
                    ),
                    _NavLink(
                      title: 'Contact',
                      onTap: () => onNavItemSelected?.call('contact'),
                    ),
                  ],
                ),

                // Right actions: Theme Toggle, Resume Download, Admin Link
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Theme Switcher Button
                    IconButton(
                      tooltip: isDark
                          ? 'Switch to Light Theme'
                          : 'Switch to Dark Theme',
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: isDark
                            ? AppColors.cyanLight
                            : AppColors.violetDark,
                        size: 20,
                      ),
                      onPressed: () => themeController.toggleTheme(),
                    ),
                    const SizedBox(width: 8),

                    // Admin Dashboard Button
                    IconButton(
                      tooltip: 'Admin Portal',
                      icon: const Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: AppColors.textMutedDark,
                      ),
                      onPressed: () => context.go('/admin'),
                    ),
                    const SizedBox(width: 12),

                    // Resume Download Button
                    ElevatedButton.icon(
                      onPressed: () {
                        UrlLauncherUtil.openUrl(
                          AppConstants.defaultResumeUrl,
                          context: context,
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violetPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Mobile / Tablet Drawer Trigger
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Switch Theme',
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: isDark
                            ? AppColors.cyanLight
                            : AppColors.violetDark,
                        size: 22,
                      ),
                      onPressed: () => themeController.toggleTheme(),
                    ),
                    IconButton(
                      tooltip: 'Menu',
                      icon: Icon(
                        Icons.menu_rounded,
                        color: isDark ? Colors.white : Colors.black,
                        size: 28,
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
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({required this.title, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = _isHovered
        ? AppColors.cyanPrimary
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 14,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
