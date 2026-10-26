import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/skill.dart';

/// Grouped-chip skills section displaying technology stack across:
/// - Desktop (≥1024px): 3-column category cards
/// - Tablet (600–1023px): 2-column cards (with 3rd category spanning full width)
/// - Mobile (<600px): 1-column stacked category cards
///
/// Features all categories visible simultaneously (no filter tabs), compact chips with brand icons,
/// and highlighted standout styling for Flutter, Firebase, and Clean Architecture.
class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  static const List<String> _categoryOrder = [
    'Mobile & Frameworks',
    'Cloud & Backend',
    'Architecture & Quality',
  ];

  static String _getCategoryDisplayTitle(String category) {
    if (category.contains('Mobile')) return 'Mobile Development';
    if (category.contains('Cloud') || category.contains('Backend')) {
      return 'Backend & Integrations';
    }
    if (category.contains('Architecture') || category.contains('Quality')) {
      return 'Architecture & Tools';
    }
    return category;
  }

  static String _getCategorySubtitle(String category) {
    if (category.contains('Mobile')) {
      return 'Build cross-platform apps for Android, iOS and Web.';
    }
    if (category.contains('Cloud') || category.contains('Backend')) {
      return 'Cloud services, APIs and real-time communication.';
    }
    if (category.contains('Architecture') || category.contains('Quality')) {
      return 'Clean code, testing and development tools.';
    }
    return 'Core skills & verified production technologies.';
  }

  static IconData _getCategoryIcon(String category) {
    if (category.contains('Mobile')) return Icons.phone_iphone_rounded;
    if (category.contains('Cloud') || category.contains('Backend')) {
      return Icons.cloud_rounded;
    }
    if (category.contains('Architecture') || category.contains('Quality')) {
      return Icons.layers_rounded;
    }
    return Icons.widgets_rounded;
  }

  static Color _getCategoryAccent(String category) {
    if (category.contains('Mobile')) return const Color(0xFF06B6D4); // Cyan
    if (category.contains('Cloud') || category.contains('Backend')) {
      return const Color(0xFF38BDF8); // Sky Blue
    }
    if (category.contains('Architecture') || category.contains('Quality')) {
      return const Color(0xFFA855F7); // Purple / Violet
    }
    return AppColors.cyanPrimary;
  }

  static String getShortLabel(Skill skill) {
    final id = skill.id.toLowerCase();
    final name = skill.name.toLowerCase();

    if (id == 'sk_flutter' ||
        (name.contains('flutter') && !name.contains('flow'))) {
      return 'Flutter';
    }
    if (id == 'sk_dart' || name == 'dart') {
      return 'Dart';
    }
    if (id == 'sk_getx' || name.contains('getx')) {
      return 'GetX';
    }
    if (id == 'sk_flutterflow' || name.contains('flutterflow')) {
      return 'FlutterFlow';
    }
    if (id == 'sk_android' || name.contains('android')) {
      return 'Android';
    }
    if (id == 'sk_ios' || name.contains('ios')) {
      return 'iOS';
    }

    if (id == 'sk_firebase_auth' ||
        (name.contains('firebase') &&
            !name.contains('fcm') &&
            !name.contains('crashlytics'))) {
      return 'Firebase';
    }
    if (id == 'sk_fcm' || name.contains('fcm')) {
      return 'FCM';
    }
    if (id == 'sk_aws_iot' || name.contains('aws')) {
      return 'AWS IoT & MQTT';
    }
    if (id == 'sk_rest_jwt' || name.contains('rest')) {
      return 'REST APIs';
    }
    if (id == 'sk_dio' || name.contains('dio')) {
      return 'Dio & JWT';
    }
    if (id == 'sk_crashlytics' || name.contains('crashlytics')) {
      return 'Crashlytics';
    }
    if (id == 'sk_python_automation' || name.contains('python')) {
      return 'Python';
    }

    if (id == 'sk_clean_arch' || name.contains('clean')) {
      return 'Clean Architecture';
    }
    if (id == 'sk_testing' || name.contains('testing')) {
      return 'Testing';
    }
    if (id == 'sk_perf_opt' || name.contains('perf')) {
      return 'Performance';
    }
    if (id == 'sk_git' || name.contains('git')) {
      return 'Git';
    }
    if (id == 'sk_hive' || name.contains('hive')) {
      return 'Hive';
    }
    if (id == 'sk_integrations' ||
        name.contains('places') ||
        name.contains('integration')) {
      return 'Google Places';
    }

    return skill.name;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1024;

        // Group skills by category
        final List<Skill> mobileSkills = skills
            .where((s) => s.category == _categoryOrder[0])
            .toList();
        final List<Skill> backendSkills = skills
            .where((s) => s.category == _categoryOrder[1])
            .toList();
        final List<Skill> archSkills = skills
            .where((s) => s.category == _categoryOrder[2])
            .toList();

        final cardMobile = _CategoryGroupCard(
          categoryTitle: _getCategoryDisplayTitle(_categoryOrder[0]),
          categorySubtitle: _getCategorySubtitle(_categoryOrder[0]),
          categoryIcon: _getCategoryIcon(_categoryOrder[0]),
          categoryAccent: _getCategoryAccent(_categoryOrder[0]),
          skills: mobileSkills,
          isDark: isDark,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          isMobile: isMobile,
        );

        final cardBackend = _CategoryGroupCard(
          categoryTitle: _getCategoryDisplayTitle(_categoryOrder[1]),
          categorySubtitle: _getCategorySubtitle(_categoryOrder[1]),
          categoryIcon: _getCategoryIcon(_categoryOrder[1]),
          categoryAccent: _getCategoryAccent(_categoryOrder[1]),
          skills: backendSkills,
          isDark: isDark,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          isMobile: isMobile,
        );

        final cardArch = _CategoryGroupCard(
          categoryTitle: _getCategoryDisplayTitle(_categoryOrder[2]),
          categorySubtitle: _getCategorySubtitle(_categoryOrder[2]),
          categoryIcon: _getCategoryIcon(_categoryOrder[2]),
          categoryAccent: _getCategoryAccent(_categoryOrder[2]),
          skills: archSkills,
          isDark: isDark,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          isMobile: isMobile,
        );

        Widget responsiveCards;
        if (isMobile) {
          // Mobile: 1-column stacked cards
          responsiveCards = Column(
            children: [
              cardMobile,
              const SizedBox(height: 14),
              cardBackend,
              const SizedBox(height: 14),
              cardArch,
            ],
          );
        } else if (isTablet) {
          // Tablet: 2-column cards, last category spanning full width
          responsiveCards = Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: cardMobile),
                    const SizedBox(width: 16),
                    Expanded(child: cardBackend),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              cardArch,
            ],
          );
        } else {
          // Desktop: 3-column cards side by side
          responsiveCards = IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cardMobile),
                const SizedBox(width: 18),
                Expanded(child: cardBackend),
                const SizedBox(width: 18),
                Expanded(child: cardArch),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 24 : 36,
            horizontal: isMobile ? 8 : 16,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Eyebrow + Code Symbol Badge)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 3.5,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.cyanPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MY TECH STACK',
                          style: TextStyle(
                            color: AppColors.cyanPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (isDark
                                    ? const Color(0xFF1E2848)
                                    : const Color(0xFFF1F5F9))
                                .withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF2E3D6B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: const Text(
                        '</>',
                        style: TextStyle(
                          color: AppColors.cyanPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Main Title: Skills & Technologies (with gradient on Technologies)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Skills & ',
                        style: TextStyle(
                          fontSize: isMobile ? 26 : 34,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF06B6D4), // Cyan
                              Color(0xFF8B5CF6), // Violet
                              Color(0xFFD946EF), // Magenta
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Technologies',
                            style: TextStyle(
                              fontSize: isMobile ? 26 : 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle / Overview Stats Row
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cyanPrimary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.cyanPrimary.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        '${skills.length}+ Technologies',
                        style: const TextStyle(
                          color: AppColors.cyanLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '•  Cross-platform development',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Grouped Cards Layout (Responsive)
                responsiveCards,
                const SizedBox(height: 22),

                // Bottom Footer Line
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: AppColors.violetPrimary,
                    ),
                    Text(
                      'Cross-platform development · Scalable APIs · Real-time systems',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Category Card displaying a category header with rounded icon box,
/// title, short subtitle, and a Wrap of grouped skill chips.
class _CategoryGroupCard extends StatelessWidget {
  final String categoryTitle;
  final String categorySubtitle;
  final IconData categoryIcon;
  final Color categoryAccent;
  final List<Skill> skills;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isMobile;

  const _CategoryGroupCard({
    required this.categoryTitle,
    required this.categorySubtitle,
    required this.categoryIcon,
    required this.categoryAccent,
    required this.skills,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1020) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2848) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header: Rounded Icon Box + Title + Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 40 : 44,
                height: isMobile ? 40 : 44,
                decoration: BoxDecoration(
                  color: categoryAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryAccent.withOpacity(0.35)),
                ),
                child: Icon(
                  categoryIcon,
                  size: isMobile ? 20 : 22,
                  color: categoryAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryTitle,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 17,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      categorySubtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 12.5,
                        color: secondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),

          // Chips Wrap
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: skills.map((skill) {
              return _SkillChip(
                skill: skill,
                isDark: isDark,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isMobile: isMobile,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Compact interactive chip for individual technologies.
/// Standout skills (Flutter, Firebase, Clean Architecture) feature colored glowing borders.
class _SkillChip extends StatefulWidget {
  final Skill skill;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isMobile;

  const _SkillChip({
    required this.skill,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isMobile,
  });

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  Color _getChipAccentColor(String shortLabel) {
    switch (shortLabel) {
      case 'Flutter':
        return const Color(0xFF06B6D4); // Cyan
      case 'Firebase':
        return const Color(0xFFF59E0B); // Amber / Flame Orange
      case 'Clean Architecture':
        return const Color(0xFF10B981); // Emerald Green
      case 'Dart':
        return const Color(0xFF0284C7); // Sky Blue
      case 'GetX':
        return const Color(0xFFA855F7); // Purple
      case 'FlutterFlow':
        return const Color(0xFF8B5CF6); // Violet
      case 'AWS IoT & MQTT':
      case 'AWS IoT':
        return const Color(0xFFFF9900); // AWS Gold
      case 'Testing':
        return const Color(0xFF3B82F6); // Blue
      case 'Performance':
        return const Color(0xFFF97316); // Orange
      case 'REST APIs':
        return const Color(0xFF0EA5E9); // Cyan
      case 'Dio & JWT':
        return const Color(0xFF9333EA); // Purple
      case 'Crashlytics':
        return const Color(0xFF8B5CF6); // Violet
      case 'Python':
        return const Color(0xFFEAB308); // Yellow
      case 'Git':
        return const Color(0xFFF05032); // Git Orange-Red
      case 'Hive':
        return const Color(0xFFA855F7); // Purple
      case 'Google Places':
        return const Color(0xFF06B6D4); // Cyan
      case 'FCM':
        return const Color(0xFFF43F5E); // Rose
      case 'Android':
        return const Color(0xFF3DDC84); // Android Green
      case 'iOS':
        return const Color(0xFFEC4899); // Rose Pink
      default:
        return widget.skill.isHighlighted
            ? const Color(0xFF06B6D4)
            : const Color(0xFF94A3B8);
    }
  }

  Widget _buildChipIcon(String shortLabel, double size) {
    switch (shortLabel) {
      case 'Flutter':
        return FlutterLogo(size: size);

      case 'Dart':
        return CustomPaint(size: Size(size, size), painter: _DartLogoPainter());

      case 'GetX':
        return Icon(
          Icons.layers_rounded,
          size: size,
          color: const Color(0xFFA855F7),
        );

      case 'FlutterFlow':
        return Icon(
          Icons.waterfall_chart_rounded,
          size: size,
          color: const Color(0xFFA855F7),
        );

      case 'Android':
        return Icon(
          Icons.android_rounded,
          size: size + 2,
          color: const Color(0xFF3DDC84),
        );

      case 'iOS':
        return Icon(
          Icons.apple,
          size: size + 2,
          color: const Color(0xFFEC4899),
        );

      case 'Firebase':
        return Icon(
          Icons.local_fire_department_rounded,
          size: size + 2,
          color: const Color(0xFFF59E0B),
        );

      case 'FCM':
        return Icon(
          Icons.notifications_active_rounded,
          size: size,
          color: const Color(0xFFF43F5E),
        );

      case 'AWS IoT & MQTT':
      case 'AWS IoT':
        return Icon(
          Icons.cloud_queue_rounded,
          size: size,
          color: const Color(0xFFFF9900),
        );

      case 'REST APIs':
        return Icon(
          Icons.link_rounded,
          size: size,
          color: const Color(0xFF06B6D4),
        );

      case 'Dio & JWT':
        return Icon(
          Icons.vpn_key_rounded,
          size: size - 1,
          color: const Color(0xFF9333EA),
        );

      case 'Crashlytics':
        return Icon(
          Icons.insert_chart_rounded,
          size: size,
          color: const Color(0xFF8B5CF6),
        );

      case 'Python':
        return CustomPaint(
          size: Size(size, size),
          painter: _PythonLogoPainter(),
        );

      case 'Clean Architecture':
        return Icon(
          Icons.security_rounded,
          size: size,
          color: const Color(0xFF10B981),
        );

      case 'Testing':
        return Icon(
          Icons.check_circle_rounded,
          size: size,
          color: const Color(0xFF3B82F6),
        );

      case 'Performance':
        return Icon(
          Icons.bolt_rounded,
          size: size + 1,
          color: const Color(0xFFF97316),
        );

      case 'Git':
        return Icon(
          Icons.call_split_rounded,
          size: size,
          color: const Color(0xFFF05032),
        );

      case 'Hive':
        return Icon(
          Icons.storage_rounded,
          size: size,
          color: const Color(0xFFA855F7),
        );

      case 'Google Places':
        return Icon(
          Icons.place_rounded,
          size: size,
          color: const Color(0xFF06B6D4),
        );

      default:
        return Icon(
          Icons.code_rounded,
          size: size,
          color: AppColors.cyanPrimary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortLabel = SkillsSection.getShortLabel(widget.skill);
    final accentColor = _getChipAccentColor(shortLabel);
    final isKeyStandout =
        shortLabel == 'Flutter' ||
        shortLabel == 'Firebase' ||
        shortLabel == 'Clean Architecture' ||
        widget.skill.isHighlighted;

    final isMobile = widget.isMobile;
    final isDark = widget.isDark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered && mounted) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (_isHovered && mounted) setState(() => _isHovered = false);
      },
      child: Tooltip(
        message: '${widget.skill.name}\n${widget.skill.description}',
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.95),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cyanPrimary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -2.5 : 0.0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 11 : 13,
            vertical: isMobile ? 6 : 7.5,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered
                      ? const Color(0xFF131B34)
                      : (isKeyStandout
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF0B1020)))
                : (_isHovered ? const Color(0xFFF8FAFC) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? accentColor
                  : (isKeyStandout
                        ? accentColor.withOpacity(0.85)
                        : (isDark
                              ? const Color(0xFF1E2848)
                              : const Color(0xFFE2E8F0))),
              width: isKeyStandout || _isHovered ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (_isHovered || isKeyStandout)
                BoxShadow(
                  color: accentColor.withOpacity(_isHovered ? 0.35 : 0.18),
                  blurRadius: _isHovered ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildChipIcon(shortLabel, isMobile ? 15 : 17),
              const SizedBox(width: 8),
              Text(
                shortLabel,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  fontWeight: isKeyStandout ? FontWeight.w700 : FontWeight.w600,
                  color: _isHovered
                      ? (_isHovered && isKeyStandout
                            ? accentColor
                            : widget.textColor)
                      : widget.textColor,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the angled geometric Dart logo
class _DartLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintTeal = Paint()
      ..color = const Color(0xFF00B4AB)
      ..style = PaintingStyle.fill;

    final paintBlue = Paint()
      ..color = const Color(0xFF0175C2)
      ..style = PaintingStyle.fill;

    final paintDark = Paint()
      ..color = const Color(0xFF02569B)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(w * 0.2, h * 0.2)
      ..lineTo(w * 0.7, h * 0.2)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.2, h * 0.55)
      ..close();
    canvas.drawPath(path1, paintTeal);

    final path2 = Path()
      ..moveTo(w * 0.7, h * 0.2)
      ..lineTo(w * 0.85, h * 0.45)
      ..lineTo(w * 0.65, h * 0.8)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    canvas.drawPath(path2, paintBlue);

    final path3 = Path()
      ..moveTo(w * 0.2, h * 0.55)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.65, h * 0.8)
      ..lineTo(w * 0.35, h * 0.8)
      ..close();
    canvas.drawPath(path3, paintDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the Python blue and yellow logo
class _PythonLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintBlue = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.fill;

    final paintYellow = Paint()
      ..color = const Color(0xFFFACC15)
      ..style = PaintingStyle.fill;

    final rrectBlue = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.5, h * 0.45),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrectBlue, paintBlue);

    canvas.drawCircle(
      Offset(w * 0.3, h * 0.28),
      1.5,
      Paint()..color = Colors.white,
    );

    final rrectYellow = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.4, w * 0.5, h * 0.45),
      const Radius.circular(6),
    );
    canvas.drawRRect(rrectYellow, paintYellow);

    canvas.drawCircle(
      Offset(w * 0.7, h * 0.72),
      1.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
