import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/profile.dart';
import '../../widgets/cards/glass_card.dart';

/// About section detailing verified experience in Flutter, Dart,
/// mobile development, REST APIs, Firebase, and testing.
class AboutSection extends StatelessWidget {
  final Profile profile;

  const AboutSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Tag & Title
          Row(
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
                'ABOUT ME',
                style: TextStyle(
                  color: AppColors.cyanPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Specialized in Flutter, Mobile Architecture & Cloud Services',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 16),

          // Main Narrative Cards
          GlassCard(
            padding: EdgeInsets.all(isMobile ? 18 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Background',
                  style: AppTypography.getTitleMedium(textColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'With over 4 years of verified software engineering experience based in Surat, Gujarat, '
                  'I focus on building production-grade cross-platform mobile and web applications with Flutter and Dart. '
                  'My technical journey spans end-to-end development, from designing responsive interfaces to '
                  'integrating high-concurrency REST APIs, real-time AWS IoT Core (MQTT) data pipelines, and Firebase cloud services.',
                  style: AppTypography.getBodyMedium(secondaryTextColor)
                      .copyWith(height: 1.45),
                ),
                const SizedBox(height: 12),
                Text(
                  'Engineering Philosophy & Craftsmanship',
                  style: AppTypography.getTitleMedium(textColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'I advocate for modular, Clean Architecture principles and strict separation of concerns using GetX '
                  'and reactive state models. '
                  'Having led and contributed to over 20 client and enterprise applications, I emphasize automated unit and '
                  'widget testing, robust JWT authentication, memory leak elimination, and CI/CD deployment pipelines '
                  'targeting both the Google Play Store and Apple App Store.',
                  style: AppTypography.getBodyMedium(secondaryTextColor)
                      .copyWith(height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key Highlights Metric Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (3 * 16)) / 4;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _HighlightCard(
                    width: cardWidth,
                    value: '4+ Years',
                    label: 'Hands-on Experience',
                    icon: Icons.timeline_rounded,
                    accentColor: AppColors.violetPrimary,
                  ),
                  _HighlightCard(
                    width: cardWidth,
                    value: '50+ Releases',
                    label: 'Play Store & App Store',
                    icon: Icons.rocket_launch_outlined,
                    accentColor: const Color(0xFFF59E0B),
                  ),
                  _HighlightCard(
                    width: cardWidth,
                    value: '20+ Projects',
                    label: 'Built & Deployed',
                    icon: Icons.layers_outlined,
                    accentColor: AppColors.cyanPrimary,
                  ),
                  _HighlightCard(
                    width: cardWidth,
                    value: 'MCA & BCA',
                    label: 'GTU & VNSGU Distinction',
                    icon: Icons.school_outlined,
                    accentColor: AppColors.bluePrimary,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final double width;
  final String value;
  final String label;
  final IconData icon;
  final Color accentColor;

  const _HighlightCard({
    required this.width,
    required this.value,
    required this.label,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return SizedBox(
      width: width,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
