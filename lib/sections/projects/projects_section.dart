import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/project.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/app_network_image.dart';
import '../../widgets/cards/glass_card.dart';

/// Interactive project gallery with search, category filtering,
/// responsive card grid, and full-detail dialogs.
class ProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

    // Unique categories
    final categories = [
      'All',
      ...widget.projects.map((p) => p.category).toSet(),
    ];

    // Filter projects
    final filteredProjects = widget.projects.where((project) {
      final matchesCategory =
          _selectedCategory == 'All' || project.category == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          project.title.toLowerCase().contains(q) ||
          project.shortDescription.toLowerCase().contains(q) ||
          project.technologies.any((t) => t.toLowerCase().contains(q));
      return matchesCategory && matchesSearch;
    }).toList();

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
                'FEATURED WORK',
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
            'Production Applications & Client Projects',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 26 : 34),
          ),
          const SizedBox(height: 8),
          Text(
            'Curated projects verified from professional portfolio, showcasing Flutter, GetX, and FlutterFlow implementations.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 28),

          // Search & Filter Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText:
                        'Search by title, tech stack (e.g. GetX, Firebase)...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category Chips
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

          // Projects Grid
          if (filteredProjects.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No projects match your filter.',
                      style: AppTypography.getTitleMedium(textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Try searching for another keyword or select "All".',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final double cardWidth = isMobile
                    ? constraints.maxWidth
                    : (constraints.maxWidth > 1050
                          ? (constraints.maxWidth - (2 * 20)) / 3
                          : (constraints.maxWidth - 20) / 2);

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: filteredProjects.asMap().entries.map((entry) {
                    final index = entry.key;
                    final project = entry.value;

                    return SizedBox(
                      width: cardWidth,
                      height: 490,
                      child: StaggeredEntrance(
                        index: index,
                        child: _ProjectCard(
                          project: project,
                          onTap: () =>
                              _showProjectDetailDialog(context, project),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showProjectDetailDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) => _ProjectDetailDialog(project: project),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

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
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Thumbnail Header (fixed 160px height)
          Stack(
            children: [
              AppNetworkImage(
                imageUrl: project.displayImageUrl,
                height: 160,
                width: double.infinity,
                placeholderText: project.title,
                fallbackIcon: Icons.phone_iphone_rounded,
                borderRadius: 16,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Text(
                    project.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyanLight,
                    ),
                  ),
                ),
              ),
              if (project.isFeatured)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.violetPrimary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Card Body (Expanded to fill card uniformly)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Name (if present)
                  if (project.companyName.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          size: 13,
                          color: isDark
                              ? AppColors.violetLight
                              : AppColors.violetPrimary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            project.companyName,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.violetLight
                                  : AppColors.violetDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Project Title
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Short Description (clamped to 2 lines for uniform layout)
                  Text(
                    project.shortDescription,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: secondaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Technologies Chips (clamped to 3 for single-line fit)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: project.technologies.take(3).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCardHover
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : AppColors.lightCardBorder,
                          ),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  // Action Footer with Store Links & Details
                  Row(
                    children: [
                      // Google Play Pill
                      if (project.playStoreUrl.isNotEmpty) ...[
                        InkWell(
                          onTap: () =>
                              UrlLauncherUtil.openUrl(project.playStoreUrl),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? AppColors.cyanPrimary
                                          : AppColors.cyanDark)
                                      .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color:
                                    (isDark
                                            ? AppColors.cyanPrimary
                                            : AppColors.cyanDark)
                                        .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.cyanLight
                                      : AppColors.cyanDark,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Play Store',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.cyanLight
                                        : AppColors.cyanDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],

                      // App Store Pill
                      if (project.appStoreUrl.isNotEmpty) ...[
                        InkWell(
                          onTap: () =>
                              UrlLauncherUtil.openUrl(project.appStoreUrl),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? AppColors.violetPrimary
                                          : AppColors.violetDark)
                                      .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color:
                                    (isDark
                                            ? AppColors.violetPrimary
                                            : AppColors.violetDark)
                                        .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.apple,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.violetLight
                                      : AppColors.violetDark,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'App Store',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.violetLight
                                        : AppColors.violetDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const Spacer(),

                      // View Case Study button
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.cyanLight
                                  : AppColors.violetPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: isDark
                                ? AppColors.cyanLight
                                : AppColors.violetPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectDetailDialog extends StatelessWidget {
  final Project project;

  const _ProjectDetailDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final isMobile = AppBreakpoints.isMobile(context);

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 750),
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              project.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.cyanPrimary
                                    : AppColors.cyanDark,
                                letterSpacing: 1.0,
                              ),
                            ),
                            if (project.companyName.isNotEmpty) ...[
                              Text(
                                '•',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                project.companyName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.violetLight
                                      : AppColors.violetDark,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.title,
                          style: AppTypography.getHeadline(textColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Banner Image
                    if (project.displayImageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppNetworkImage(
                          imageUrl: project.displayImageUrl,
                          height: 220,
                          width: double.infinity,
                          placeholderText: project.title,
                          fallbackIcon: Icons.phone_iphone_rounded,
                          borderRadius: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Overview
                    Text(
                      'Project Overview',
                      style: AppTypography.getTitleMedium(textColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.fullDescription,
                      style: AppTypography.getBodyLarge(secondaryTextColor),
                    ),
                    const SizedBox(height: 24),

                    // Key Features
                    if (project.keyFeatures.isNotEmpty) ...[
                      Text(
                        'Key Features',
                        style: AppTypography.getTitleMedium(textColor),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: project.keyFeatures.map((feat) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.0,
                                    right: 10.0,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: AppColors.cyanPrimary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    feat,
                                    style: AppTypography.getBodyMedium(
                                      secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Personal Contribution
                    if (project.personalContribution.isNotEmpty) ...[
                      Text(
                        'Personal Contribution',
                        style: AppTypography.getTitleMedium(textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.personalContribution,
                        style: AppTypography.getBodyLarge(secondaryTextColor),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Challenges and Solutions
                    if (project.challengesAndSolutions.isNotEmpty) ...[
                      Text(
                        'Engineering Challenges & Solutions',
                        style: AppTypography.getTitleMedium(textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.challengesAndSolutions,
                        style: AppTypography.getBodyLarge(secondaryTextColor),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Verified Outcomes
                    if (project.verifiedOutcomes.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.violetPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.violetPrimary.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: AppColors.cyanPrimary,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Verified Outcome',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.cyanPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    project.verifiedOutcomes,
                                    style: AppTypography.getBodyMedium(
                                      textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Tech Stack Tags
                    Text(
                      'Technologies Used',
                      style: AppTypography.getTitleMedium(textColor),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.technologies.map((t) {
                        return Chip(
                          label: Text(t),
                          backgroundColor: isDark
                              ? AppColors.darkCardHover
                              : Colors.grey.shade100,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : AppColors.lightCardBorder,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Store / External Link Actions Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.end,
                children: [
                  if (project.playStoreUrl.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.playStoreUrl,
                        context: context,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.googlePlay, size: 16),
                      label: const Text('Google Play'),
                    ),
                  if (project.appStoreUrl.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.appStoreUrl,
                        context: context,
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.appStoreIos,
                        size: 16,
                      ),
                      label: const Text('App Store'),
                    ),
                  if (project.githubUrl.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.githubUrl,
                        context: context,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                      label: const Text('Source Code'),
                    ),
                  if (project.demoUrl.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.demoUrl,
                        context: context,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Live Demo'),
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
