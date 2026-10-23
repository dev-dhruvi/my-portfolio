import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/skill.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/glass_card.dart';
import '../../widgets/navigation/dynamic_scroll_indicators.dart';

/// Skills section featuring an animated horizontal paginated scroll structure,
/// dynamic indicator dots calculated from active viewport constraints,
/// and smooth interactive page controls.
class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'All';
  late final PageController _skillsPageController;
  late final ValueNotifier<int> _activePageNotifier;

  @override
  void initState() {
    super.initState();
    _skillsPageController = PageController();
    _activePageNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _skillsPageController.dispose();
    _activePageNotifier.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
    });
    if (_skillsPageController.hasClients) {
      _skillsPageController.jumpToPage(0);
    }
    _activePageNotifier.value = 0;
  }

  void _animateToPage(int pageIndex) {
    if (_skillsPageController.hasClients) {
      _skillsPageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
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

    // Extract unique categories
    final categories = ['All', ...widget.skills.map((s) => s.category).toSet()];

    final filteredSkills = _selectedCategory == 'All'
        ? widget.skills
        : widget.skills.where((s) => s.category == _selectedCategory).toList();

    final double? minSkillsHeight = isDesktop
        ? math.max(680.0, screenHeight - 92.0)
        : null;

    return Container(
      constraints: minSkillsHeight != null
          ? BoxConstraints(minHeight: minSkillsHeight)
          : null,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
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
          const SizedBox(height: 10),
          Text(
            'Technologies & Frameworks',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 6),
          Text(
            'Verified tech stack and methodologies proven across commercial and production mobile applications.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 14),

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
                    onSelected: (_) => _onCategoryChanged(cat),
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
          const SizedBox(height: 18),

          // Horizontal Scrolling Structure with Dynamic Indicator Dots
          if (filteredSkills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'No skills found in this category.',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                // Dynamically determine how many items comfortably fit per viewport page
                final int itemsPerPage = constraints.maxWidth > 1050
                    ? 3
                    : ((constraints.maxWidth >= 600 ||
                              constraints.maxWidth == 0)
                          ? 2
                          : 1);

                // Chunk skills into responsive pages
                final List<List<Skill>> pages = [];
                for (var i = 0; i < filteredSkills.length; i += itemsPerPage) {
                  final end = (i + itemsPerPage < filteredSkills.length)
                      ? i + itemsPerPage
                      : filteredSkills.length;
                  pages.add(filteredSkills.sublist(i, end));
                }

                final pageCount = pages.length;

                return Column(
                  children: [
                    SizedBox(
                      height: isMobile ? 215 : 200,
                      child: PageView.builder(
                        controller: _skillsPageController,
                        itemCount: pageCount,
                        onPageChanged: (pageIndex) {
                          _activePageNotifier.value = pageIndex;
                        },
                        itemBuilder: (context, pageIndex) {
                          final pageItems = pages[pageIndex];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int i = 0; i < itemsPerPage; i++) ...[
                                  if (i > 0) const SizedBox(width: 16),
                                  if (i < pageItems.length)
                                    Expanded(
                                      child: StaggeredEntrance(
                                        index: i,
                                        child: _SkillCard(skill: pageItems[i]),
                                      ),
                                    )
                                  else
                                    const Expanded(child: SizedBox.shrink()),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Dynamic Indicator Dots calculated from visible pages & viewport capacity
                    ValueListenableBuilder<int>(
                      valueListenable: _activePageNotifier,
                      builder: (context, activeIndex, _) {
                        final int safeIndex = activeIndex
                            .clamp(0, math.max(0, pageCount - 1))
                            .toInt();
                        return DynamicScrollIndicators(
                          pageCount: pageCount,
                          activeIndex: safeIndex,
                          onDotTapped: _animateToPage,
                          onPrevious: () => _animateToPage(safeIndex - 1),
                          onNext: () => _animateToPage(safeIndex + 1),
                        );
                      },
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

class _SkillCard extends StatefulWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

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
    if (lower.contains('python') || lower.contains('terminal')) {
      return Icons.terminal_rounded;
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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppColors.violetPrimary.withOpacity(0.24)
                              : AppColors.violetPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: AppColors.violetPrimary.withOpacity(
                                      0.35,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          _getIconForSkill(widget.skill.name),
                          size: 22,
                          color: isDark
                              ? AppColors.violetLight
                              : AppColors.violetDark,
                        ),
                      ),
                      if (widget.skill.isHighlighted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (isDark
                                        ? AppColors.cyanPrimary
                                        : AppColors.cyanDark)
                                    .withOpacity(0.14),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  (isDark
                                          ? AppColors.cyanPrimary
                                          : AppColors.cyanDark)
                                      .withOpacity(0.32),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 12,
                                color: isDark
                                    ? AppColors.cyanLight
                                    : AppColors.cyanDark,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Core Stack',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.cyanLight
                                      : AppColors.cyanDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.skill.name,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.skill.description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: secondaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.tag_rounded,
                    size: 13,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.skill.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
