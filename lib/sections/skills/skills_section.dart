import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/skill.dart';
import '../../widgets/cards/glass_card.dart';

/// Skills section showing verified technologies categorized cleanly without
/// invented percentage meters.
class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'All';

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

    // Extract unique categories
    final categories = ['All', ...widget.skills.map((s) => s.category).toSet()];

    final filteredSkills = _selectedCategory == 'All'
        ? widget.skills
        : widget.skills.where((s) => s.category == _selectedCategory).toList();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 64),
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
                'CORE CAPABILITIES',
                style: TextStyle(
                  color: AppColors.cyanPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Technologies & Frameworks',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 26 : 34),
          ),
          const SizedBox(height: 8),
          Text(
            'Verified tech stack and methodologies proven across commercial and production mobile applications.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 28),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                    selectedColor: AppColors.violetPrimary.withOpacity(0.2),
                    checkmarkColor: AppColors.cyanPrimary,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.cyanPrimary
                          : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.violetPrimary
                            : (isDark
                                  ? AppColors.darkCardBorder
                                  : AppColors.lightCardBorder),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Grid of Skills
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = isMobile
                  ? constraints.maxWidth
                  : (constraints.maxWidth > 1000
                        ? (constraints.maxWidth - (2 * 16)) / 3
                        : (constraints.maxWidth - 16) / 2);

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: filteredSkills.map((skill) {
                  return SizedBox(
                    width: cardWidth,
                    child: _SkillCard(skill: skill),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  IconData _getIconForSkill(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('flutter') && !lower.contains('web')) {
      return Icons.phone_android_rounded;
    }
    if (lower.contains('web')) {
      return Icons.language_rounded;
    }
    if (lower.contains('dart')) {
      return Icons.code_rounded;
    }
    if (lower.contains('firebase') || lower.contains('fcm')) {
      return Icons.local_fire_department_rounded;
    }
    if (lower.contains('aws') ||
        lower.contains('mqtt') ||
        lower.contains('cloud')) {
      return Icons.cloud_queue_rounded;
    }
    if (lower.contains('clean') || lower.contains('architecture')) {
      return Icons.account_tree_outlined;
    }
    if (lower.contains('test')) {
      return Icons.verified_rounded;
    }
    if (lower.contains('git')) {
      return Icons.merge_type_rounded;
    }
    if (lower.contains('rest') || lower.contains('jwt')) {
      return Icons.key_rounded;
    }
    if (lower.contains('getx')) {
      return Icons.bolt_rounded;
    }
    return Icons.widgets_outlined;
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

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.violetPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getIconForSkill(skill.name),
                  size: 22,
                  color: AppColors.violetLight,
                ),
              ),
              if (skill.isHighlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cyanPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cyanPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    'PROD VERIFIED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cyanPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            skill.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            skill.description.isNotEmpty ? skill.description : skill.category,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
