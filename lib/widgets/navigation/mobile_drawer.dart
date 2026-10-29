import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/url_launcher_util.dart';

/// Drawer navigation for mobile screens with modern frosted styling.
class MobileDrawer extends StatelessWidget {
  final Function(String sectionKey)? onNavItemSelected;
  final String activeSection;

  const MobileDrawer({
    super.key,
    this.onNavItemSelected,
    this.activeSection = 'hero',
  });

  void _closeDrawer(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkCanvas : AppColors.lightCanvas,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.violetPrimary.withOpacity(0.35),
                          blurRadius: 12,
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
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.developerName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Senior Flutter Developer',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark
                                ? AppColors.cyanPrimary
                                : AppColors.cyanDark,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: isDark
                  ? AppColors.darkCardBorder
                  : AppColors.lightCardBorder,
              height: 1,
            ),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    isActive: activeSection == 'hero',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('hero');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'About',
                    isActive: activeSection == 'about',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('about');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Projects',
                    isActive: activeSection == 'projects',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('projects');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.work_outline_rounded,
                    title: 'Experience',
                    isActive: activeSection == 'experience',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('experience');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.code_rounded,
                    title: 'Skills',
                    isActive: activeSection == 'skills',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('skills');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.school_outlined,
                    title: 'Education',
                    isActive: activeSection == 'education',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('education');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact',
                    isActive: activeSection == 'contact',
                    onTap: () {
                      _closeDrawer(context);
                      onNavItemSelected?.call('contact');
                    },
                  ),
                ],
              ),
            ),

            // Bottom Actions: Resume Download & Theme Toggle
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.violetPrimary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _closeDrawer(context);
                        UrlLauncherUtil.openUrl(
                          AppConstants.defaultResumeUrl,
                          context: context,
                        );
                      },
                      icon: const Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Download CV',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => themeController.toggleTheme(),
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 20,
                      color: isDark
                          ? AppColors.cyanLight
                          : AppColors.violetPrimary,
                    ),
                    label: Text(
                      isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : AppColors.lightCardBorder,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isActive
        ? (isDark ? AppColors.cyanLight : AppColors.violetPrimary)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Semantics(
      button: true,
      label: '$title navigation${isActive ? ", current section" : ""}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isActive
                ? BorderSide(color: itemColor.withOpacity(0.35), width: 1.2)
                : BorderSide.none,
          ),
          tileColor: isActive
              ? (isDark
                    ? AppColors.violetPrimary.withOpacity(0.22)
                    : AppColors.violetPrimary.withOpacity(0.12))
              : Colors.transparent,
          leading: Icon(icon, color: itemColor, size: 22),
          title: Text(
            title,
            style: TextStyle(
              color: itemColor,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
