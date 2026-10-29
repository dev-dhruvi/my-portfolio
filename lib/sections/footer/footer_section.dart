import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/profile.dart';
import '../../widgets/animations/scroll_reveal.dart';

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
        horizontal: isMobile ? 16 : 36,
        vertical: isMobile ? 12 : 14,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppBreakpoints.maxContentWidth,
          ),
          child: ScrollReveal(
            slideDistance: 12.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 560;

                final brandText = FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: isNarrow ? Alignment.center : Alignment.centerLeft,
                  child: const Text(
                    AppConstants.developBy,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cyanPrimary,
                    ),
                  ),
                );

                final socialIcons = Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FooterSocialIconButton(
                      tooltip: 'GitHub',
                      icon: const FaIcon(FontAwesomeIcons.github, size: 18),
                      onPressed: () => UrlLauncherUtil.openUrl(
                        profile.githubUrl,
                        context: context,
                      ),
                    ),
                    _FooterSocialIconButton(
                      tooltip: 'LinkedIn',
                      icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 18),
                      onPressed: () => UrlLauncherUtil.openUrl(
                        profile.linkedinUrl,
                        context: context,
                      ),
                    ),
                    _FooterSocialIconButton(
                      tooltip: 'WhatsApp',
                      icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                      onPressed: () => UrlLauncherUtil.openWhatsApp(
                        AppConstants.whatsappNumber,
                        text: AppConstants.whatsappDefaultText,
                        context: context,
                      ),
                    ),
                    _FooterSocialIconButton(
                      tooltip: 'Email',
                      icon: const Icon(Icons.mail_rounded, size: 20),
                      onPressed: () => UrlLauncherUtil.openEmail(profile.email),
                    ),
                  ],
                );

                if (isNarrow) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      socialIcons,
                      const SizedBox(height: 6),
                      brandText,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: brandText),
                    const SizedBox(width: 12),
                    socialIcons,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterSocialIconButton extends StatefulWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _FooterSocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<_FooterSocialIconButton> createState() =>
      _FooterSocialIconButtonState();
}

class _FooterSocialIconButtonState extends State<_FooterSocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!_isHovered && mounted) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (_isHovered && mounted) setState(() => _isHovered = false);
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: IconButton(
          tooltip: widget.tooltip,
          icon: widget.icon,
          visualDensity: VisualDensity.compact,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
