import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/url_launcher_util.dart';

/// Drawer navigation for mobile screens.
class MobileDrawer extends StatelessWidget {
  final Function(String sectionKey)? onNavItemSelected;

  const MobileDrawer({super.key, this.onNavItemSelected});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
                      borderRadius: BorderRadius.circular(12),
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
            const Divider(),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemSelected?.call('about');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.code_rounded,
                    title: 'Skills',
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemSelected?.call('skills');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.work_outline_rounded,
                    title: 'Experience',
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemSelected?.call('experience');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Projects',
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemSelected?.call('projects');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.school_outlined,
                    title: 'Education',
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemSelected?.call('education');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact',
                    onTap: () {
                      Navigator.pop(context);
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
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      UrlLauncherUtil.openUrl(
                        AppConstants.defaultResumeUrl,
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Resume'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: AppColors.violetPrimary,
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
                    ),
                    label: Text(
                      isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
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
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return ListTile(
      leading: Icon(icon, color: itemColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}
