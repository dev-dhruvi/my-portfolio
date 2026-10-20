import 'package:flutter/material.dart';
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
    final isCompact = AppBreakpoints.isCompactNav(context);
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? (screenWidth < 600 ? 16 : 24) : 32,
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
              // Brand Logo / Initials (Flexible to prevent any potential overflow)
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
                            if (screenWidth >= 1200)
                              Text(
                                'Sr. Flutter Developer',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cyanPrimary,
                                ),
                              )
                            else if (screenWidth >= 520)
                              Text(
                                'Sr. Flutter Developer',
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

              const SizedBox(width: 12),

              // Desktop Navigation Menu & Actions
              if (!isCompact) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavLink(
                      title: 'About',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('about'),
                    ),
                    _NavLink(
                      title: 'Skills',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('skills'),
                    ),
                    _NavLink(
                      title: 'Experience',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('experience'),
                    ),
                    _NavLink(
                      title: 'Projects',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('projects'),
                    ),
                    _NavLink(
                      title: 'Education',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('education'),
                    ),
                    _NavLink(
                      title: 'Contact',
                      horizontalPadding: screenWidth < 1200 ? 10 : 14,
                      onTap: () => onNavItemSelected?.call('contact'),
                    ),
                  ],
                ),

                // Right actions: Theme Toggle, Resume Download
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        UrlLauncherUtil.openUrl(
                          AppConstants.defaultResumeUrl,
                          context: context,
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violetPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Compact / Tablet / Mobile Drawer Trigger
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (screenWidth >= 640) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          UrlLauncherUtil.openUrl(
                            AppConstants.defaultResumeUrl,
                            context: context,
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Resume'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.violetPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
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
                        size: 22,
                      ),
                      onPressed: () => themeController.toggleTheme(),
                    ),
                    IconButton(
                      tooltip: 'Open navigation menu',
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
  final double horizontalPadding;

  const _NavLink({
    required this.title,
    required this.onTap,
    this.horizontalPadding = 14,
  });

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
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: 8,
          ),
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
