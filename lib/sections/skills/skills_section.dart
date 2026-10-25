import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../models/skill.dart';

/// Skills section displaying technology stack across:
/// - Desktop (1440px): 6 cards per row
/// - Tablet (768px): 3 cards per row (3x2 grid)
/// - Mobile (375px): 2 cards per row (2x3 grid)
///
/// Features interactive category filter tabs (All, Mobile & Frameworks,
/// Cloud & Backend, Architecture & Quality), custom brand icons,
/// and smooth glowing hover transitions.
class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'All';

  static const List<String> _categoryOrder = [
    'Mobile & Frameworks',
    'Cloud & Backend',
    'Architecture & Quality',
  ];

  void _onCategoryChanged(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
    });
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('Mobile')) return Icons.phone_iphone_rounded;
    if (category.contains('Cloud')) return Icons.cloud_rounded;
    if (category.contains('Architecture')) return Icons.shield_rounded;
    return Icons.widgets_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    // Filter categories to render
    final List<String> activeCategories = _selectedCategory == 'All'
        ? _categoryOrder
        : [_selectedCategory];

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
            // Eyebrow Tag: | MY TECH STACK
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
            const SizedBox(height: 22),

            // Category Filter Pills Bar (All, Mobile & Frameworks, Cloud & Backend, Architecture & Quality)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildFilterTab(
                  label: 'All',
                  icon: null,
                  isSelected: _selectedCategory == 'All',
                  isDark: isDark,
                  onTap: () => _onCategoryChanged('All'),
                ),
                for (final cat in _categoryOrder)
                  _buildFilterTab(
                    label: cat,
                    icon: _getCategoryIcon(cat),
                    isSelected: _selectedCategory == cat,
                    isDark: isDark,
                    onTap: () => _onCategoryChanged(cat),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Category Sections with Grids
            for (int c = 0; c < activeCategories.length; c++) ...[
              if (c > 0) const SizedBox(height: 36),
              _buildCategoryGroup(
                categoryName: activeCategories[c],
                skills: widget.skills
                    .where((s) => s.category == activeCategories[c])
                    .toList(),
                isMobile: isMobile,
                isTablet: isTablet,
                isDesktop: isDesktop,
                isDark: isDark,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required IconData? icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED), // Violet
                    Color(0xFF06B6D4), // Cyan
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? const Color(0xFF0D1226) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? const Color(0xFF1E2846) : const Color(0xFFE2E8F0)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14.5,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
              ),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGroup({
    required String categoryName,
    required List<Skill> skills,
    required bool isMobile,
    required bool isTablet,
    required bool isDesktop,
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    if (skills.isEmpty) return const SizedBox.shrink();

    final IconData categoryIcon = _getCategoryIcon(categoryName);

    // Responsive columns:
    // Desktop (1440px): 6 items in single row
    // Tablet (768px): 3 items in a row (3x2 grid)
    // Mobile (375px): 2 items in a row (2x3 grid)
    final int crossAxisCount = isDesktop ? 6 : (isTablet ? 3 : 2);
    final double childAspectRatio = isDesktop ? 1.15 : (isTablet ? 1.25 : 1.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header (Icon + Title)
        Row(
          children: [
            Icon(categoryIcon, size: 19, color: AppColors.cyanPrimary),
            const SizedBox(width: 8),
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid of Skill Cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: skills.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isMobile ? 12 : 16,
            mainAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final skill = skills[index];
            return _SkillBrandCard(
              skill: skill,
              isMobile: isMobile,
              isDark: isDark,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            );
          },
        ),
      ],
    );
  }
}

/// Sleek card displaying brand icon + technology short label.
/// Features neon glowing border and elevation hover effect.
class _SkillBrandCard extends StatefulWidget {
  final Skill skill;
  final bool isMobile;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  const _SkillBrandCard({
    required this.skill,
    required this.isMobile,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  State<_SkillBrandCard> createState() => _SkillBrandCardState();
}

class _SkillBrandCardState extends State<_SkillBrandCard> {
  bool _isHovered = false;

  String _getShortLabel(Skill skill) {
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
      return 'Android Studio';
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
      return 'AWS IoT';
    }
    if (id == 'sk_rest_jwt' || name.contains('rest')) {
      return 'REST APIs';
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
    if (id == 'sk_integrations' || name.contains('integration')) {
      return 'Integrations';
    }
    if (id == 'sk_hive' || name.contains('hive')) {
      return 'Hive DB';
    }

    return skill.name;
  }

  @override
  Widget build(BuildContext context) {
    final shortLabel = _getShortLabel(widget.skill);
    final isMobile = widget.isMobile;
    final isDark = widget.isDark;

    final cardContent = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered && mounted) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (_isHovered && mounted) {
          setState(() => _isHovered = false);
        }
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
          transform: Matrix4.translationValues(0, _isHovered ? -4.0 : 0.0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered
                      ? const Color(0xFF131B34)
                      : const Color(0xFF0B1020))
                : (_isHovered ? const Color(0xFFF8FAFC) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.cyanPrimary.withOpacity(0.85)
                  : (isDark
                        ? const Color(0xFF1E2848)
                        : const Color(0xFFE2E8F0)),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (_isHovered) ...[
                BoxShadow(
                  color: AppColors.cyanPrimary.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.violetPrimary.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ] else ...[
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.28 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Brand / Technology Icon
              Expanded(
                child: Center(
                  child: _TechnologyIconWidget(
                    shortLabel: shortLabel,
                    iconName: widget.skill.iconName,
                    isMobile: isMobile,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Short Label
              Text(
                shortLabel,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? AppColors.cyanPrimary : widget.textColor,
                  letterSpacing: -0.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    return cardContent;
  }
}

/// Dedicated widget that renders accurate brand icons matching the reference design:
/// - Flutter: Official Flutter vector logo
/// - Dart: Angled geometric chevron
/// - GetX: 3D layered purple boxes
/// - FlutterFlow: Lilac styled wings
/// - Android Studio: Android robot head in green
/// - iOS: Apple logo in rose/pink
/// - Firebase: Flame in orange/yellow
/// - FCM: Bell with ringing waves in rose
/// - AWS IoT: AWS logo with curved smile
/// - REST APIs: Connected link chains in cyan
/// - Crashlytics: Bar chart in violet
/// - Python: Dual-colored python snakes
/// - Clean Architecture: Triple modular layers
/// - Testing: Green circle checkmark
/// - Performance: Orange lightning bolt
/// - Git: Orange-red diamond with branch
/// - Integrations: Purple puzzle piece
/// - Hive DB: Cylinder database stack
class _TechnologyIconWidget extends StatelessWidget {
  final String shortLabel;
  final String iconName;
  final bool isMobile;

  const _TechnologyIconWidget({
    required this.shortLabel,
    required this.iconName,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = isMobile ? 32 : 38;

    switch (shortLabel) {
      case 'Flutter':
        return FlutterLogo(size: iconSize);

      case 'Dart':
        return CustomPaint(
          size: Size(iconSize, iconSize),
          painter: _DartLogoPainter(),
        );

      case 'GetX':
        return Icon(
          Icons.layers_rounded,
          size: iconSize,
          color: const Color(0xFFA855F7), // Purple / Violet
        );

      case 'FlutterFlow':
        return Icon(
          Icons.waterfall_chart_rounded,
          size: iconSize,
          color: const Color(0xFFA855F7),
        );

      case 'Android Studio':
        return Icon(
          Icons.android_rounded,
          size: iconSize + 2,
          color: const Color(0xFF3DDC84), // Android Green
        );

      case 'iOS':
        return Icon(
          Icons.apple,
          size: iconSize + 2,
          color: const Color(0xFFEC4899), // Rose / Pink
        );

      case 'Firebase':
        return Icon(
          Icons.local_fire_department_rounded,
          size: iconSize + 2,
          color: const Color(0xFFF59E0B), // Flame Orange
        );

      case 'FCM':
        return Icon(
          Icons.notifications_active_rounded,
          size: iconSize,
          color: const Color(0xFFF43F5E), // Rose Pink
        );

      case 'AWS IoT':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF232F3E),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFFFF9900).withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: const Text(
                'aws',
                style: TextStyle(
                  color: Color(0xFFFF9900),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9900),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        );

      case 'REST APIs':
        return Icon(
          Icons.link_rounded,
          size: iconSize + 2,
          color: const Color(0xFF06B6D4), // Cyan
        );

      case 'Crashlytics':
        return Icon(
          Icons.bar_chart_rounded,
          size: iconSize + 2,
          color: const Color(0xFF8B5CF6), // Purple
        );

      case 'Python':
        return CustomPaint(
          size: Size(iconSize, iconSize),
          painter: _PythonLogoPainter(),
        );

      case 'Clean Architecture':
        return Icon(
          Icons.layers_outlined,
          size: iconSize,
          color: const Color(0xFF818CF8), // Indigo
        );

      case 'Testing':
        return Icon(
          Icons.check_circle_rounded,
          size: iconSize,
          color: const Color(0xFF10B981), // Emerald Green
        );

      case 'Performance':
        return Icon(
          Icons.bolt_rounded,
          size: iconSize + 4,
          color: const Color(0xFFF97316), // Orange
        );

      case 'Git':
        return Container(
          width: iconSize - 6,
          height: iconSize - 6,
          transform: Matrix4.rotationZ(0.785),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF05032), // Git Orange-Red
            borderRadius: BorderRadius.circular(5),
          ),
          child: Transform.rotate(
            angle: -0.785,
            child: const Icon(
              Icons.fork_right_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        );

      case 'Integrations':
        return Icon(
          Icons.extension_rounded,
          size: iconSize,
          color: const Color(0xFFA855F7), // Purple puzzle
        );

      case 'Hive DB':
        return Icon(
          Icons.storage_rounded,
          size: iconSize,
          color: const Color(0xFF0EA5E9), // Database Cyan
        );

      default:
        return Icon(
          Icons.widgets_rounded,
          size: iconSize,
          color: AppColors.cyanPrimary,
        );
    }
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

    // Top-left teal polygon
    final path1 = Path()
      ..moveTo(w * 0.2, h * 0.2)
      ..lineTo(w * 0.7, h * 0.2)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.2, h * 0.55)
      ..close();
    canvas.drawPath(path1, paintTeal);

    // Right blue polygon
    final path2 = Path()
      ..moveTo(w * 0.7, h * 0.2)
      ..lineTo(w * 0.85, h * 0.45)
      ..lineTo(w * 0.65, h * 0.8)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    canvas.drawPath(path2, paintBlue);

    // Bottom dark polygon
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

    // Top blue snake body
    final rrectBlue = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.5, h * 0.45),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrectBlue, paintBlue);

    // Eye dot
    canvas.drawCircle(
      Offset(w * 0.3, h * 0.28),
      2.0,
      Paint()..color = Colors.white,
    );

    // Bottom yellow snake body
    final rrectYellow = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.4, w * 0.5, h * 0.45),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrectYellow, paintYellow);

    // Eye dot
    canvas.drawCircle(
      Offset(w * 0.7, h * 0.72),
      2.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
