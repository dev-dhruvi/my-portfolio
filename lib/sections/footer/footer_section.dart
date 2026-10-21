import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';

/// Clean, responsive footer with copyright, stack credits, and quick links.
class FooterSection extends StatelessWidget {
  final Profile profile;
  final Function(String sectionKey)? onNavigate;

  const FooterSection({super.key, required this.profile, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
            .withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkCardBorder
                : AppColors.lightCardBorder,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 24 : 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxContentWidth,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand & Summary
                  Column(
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
                      const Text(
                        AppConstants.fullRoleHeadline,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.cyanPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Social Icons
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'GitHub',
                        icon: const FaIcon(FontAwesomeIcons.github, size: 18),
                        onPressed: () => UrlLauncherUtil.openUrl(
                          profile.githubUrl,
                          context: context,
                        ),
                      ),
                      IconButton(
                        tooltip: 'LinkedIn',
                        icon: const FaIcon(
                          FontAwesomeIcons.linkedinIn,
                          size: 18,
                        ),
                        onPressed: () => UrlLauncherUtil.openUrl(
                          profile.linkedinUrl,
                          context: context,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Email',
                        icon: const Icon(Icons.mail_rounded, size: 20),
                        onPressed: () =>
                            UrlLauncherUtil.openEmail(profile.email),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
