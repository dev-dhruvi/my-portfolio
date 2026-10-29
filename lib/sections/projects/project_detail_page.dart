import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/seed_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/project.dart';
import '../../repositories/portfolio_repository.dart';
import '../../widgets/animations/ambient_background.dart';
import '../../widgets/cards/app_network_image.dart';
import '../../widgets/cards/glass_card.dart';

/// Dedicated Case Study & Detail Page for individual projects (/projects/:slug).
///
/// Features:
/// - Breadcrumb & "Back to Projects" navigation.
/// - Prominent Header with canonical badges and independent store/demo action buttons.
/// - Responsive visual screenshot showcase preserving original aspect ratios.
/// - Detailed case study sections: Overview, Role, Features, Tech Stack, Challenges & Solutions, Outcomes.
/// - Seamless Previous & Next Project navigation footer.
class ProjectDetailPage extends StatefulWidget {
  final String slug;
  final Project? initialProject;

  const ProjectDetailPage({super.key, required this.slug, this.initialProject});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedImageIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Project? _resolveProject(BuildContext context) {
    if (widget.initialProject != null) return widget.initialProject;
    final repo = context.read<PortfolioRepository>();
    final fromRepo = repo.getProjectBySlug(widget.slug);
    if (fromRepo != null) return fromRepo;

    final normalized = widget.slug.trim().toLowerCase();
    try {
      return SeedData.initialProjects.firstWhere(
        (p) =>
            p.slug.toLowerCase() == normalized ||
            p.id.toLowerCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  List<Project> _getAllActiveProjects(BuildContext context) {
    final repo = context.read<PortfolioRepository>();
    final active = repo.projects.where((p) => p.isStatusActive).toList();
    if (active.isNotEmpty) return active;
    return SeedData.initialProjects.where((p) => p.isStatusActive).toList();
  }

  void _navigateToProject(String slug) {
    setState(() => _selectedImageIndex = 0);
    context.go('/projects/$slug');
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Widget icon,
    required String url,
    required bool isPrimary,
    required bool isDark,
  }) {
    if (url.trim().isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: 'Open $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => UrlLauncherUtil.openUrl(url, context: context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isPrimary ? AppColors.primaryGradient : null,
              color: isPrimary
                  ? null
                  : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPrimary
                    ? Colors.transparent
                    : (isDark
                          ? AppColors.darkCardBorder
                          : AppColors.lightCardBorder),
                width: 1,
              ),
              boxShadow: [
                if (isPrimary)
                  BoxShadow(
                    color: AppColors.violetPrimary.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPrimary
                          ? Colors.white
                          : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 13,
                  color: isPrimary
                      ? Colors.white70
                      : (isDark ? Colors.white60 : Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withOpacity(0.90)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withOpacity(0.40), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: primaryColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
    required bool isDark,
    Color? iconColor,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      borderRadius: 16,
      enableHoverEffect: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.violetPrimary).withOpacity(
                    0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (iconColor ?? AppColors.violetPrimary).withOpacity(
                      0.25,
                    ),
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor ?? AppColors.violetPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16.5 : 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = _resolveProject(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppBreakpoints.isMobile(context);
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    if (project == null) {
      return Scaffold(
        body: AmbientBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_off_outlined,
                    size: 72,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Project Not Found',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We could not locate the requested project case study.',
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/projects'),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Back to Projects Directory'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Collect gallery images
    final List<String> images = [];
    if (project.displayImageUrl.isNotEmpty) {
      images.add(project.displayImageUrl);
    }
    for (final url in project.galleryUrls) {
      if (url.isNotEmpty && !images.contains(url)) {
        images.add(url);
      }
    }
    if (images.isEmpty) {
      images.add('assets/images/project/default.webp');
    }

    final safeImageIndex = _selectedImageIndex.clamp(0, images.length - 1);
    final currentImage = images[safeImageIndex];

    // Compute Previous / Next projects for footer navigation
    final allProjects = _getAllActiveProjects(context);
    final currentIndex = allProjects.indexWhere((p) => p.slug == project.slug);
    final Project? prevProject = (currentIndex > 0)
        ? allProjects[currentIndex - 1]
        : null;
    final Project? nextProject =
        (currentIndex >= 0 && currentIndex < allProjects.length - 1)
        ? allProjects[currentIndex + 1]
        : null;

    final platformCategory = project.platformCategory;

    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 36,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Bar ("Back to Projects" breadcrumb)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/projects');
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18,
                                  color: AppColors.cyanPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back to Projects',
                                  style: TextStyle(
                                    fontSize: 14,
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

                        // Home link shortcut
                        IconButton(
                          tooltip: 'Return to Home',
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.home_outlined, size: 20),
                          color: secondaryTextColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Header Badges: Platform Category & (if available) Company Name
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildBadge(
                          icon: platformCategory.contains('Web')
                              ? Icons.language_rounded
                              : Icons.phone_iphone_rounded,
                          label: platformCategory,
                          isDark: isDark,
                          primaryColor: isDark
                              ? AppColors.cyanLight
                              : AppColors.cyanDark,
                        ),
                        if (project.companyName.isNotEmpty)
                          _buildBadge(
                            icon: Icons.apartment_rounded,
                            label: project.companyName,
                            isDark: isDark,
                            primaryColor: isDark
                                ? AppColors.violetLight
                                : AppColors.violetPrimary,
                          ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Project Title
                    Text(
                      project.title,
                      style:
                          (isMobile
                                  ? AppTypography.getDisplayMedium(textColor)
                                  : AppTypography.getDisplayLarge(textColor))
                              .copyWith(
                                fontSize: isMobile ? 26 : 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                    ),

                    const SizedBox(height: 10),

                    // Short Summary
                    Text(
                      project.shortDescription.isNotEmpty
                          ? project.shortDescription
                          : project.fullDescription,
                      style: AppTypography.getBodyLarge(secondaryTextColor)
                          .copyWith(fontSize: isMobile ? 14 : 16, height: 1.5),
                    ),

                    const SizedBox(height: 20),

                    // External Action Buttons (App Store, Play Store, GitHub, Live Demo)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (project.playStoreUrl.trim().isNotEmpty)
                          _buildActionButton(
                            context: context,
                            label: 'Google Play Store',
                            icon: const FaIcon(
                              FontAwesomeIcons.googlePlay,
                              size: 14,
                              color: Colors.white,
                            ),
                            url: project.playStoreUrl,
                            isPrimary: true,
                            isDark: isDark,
                          ),
                        if (project.appStoreUrl.trim().isNotEmpty)
                          _buildActionButton(
                            context: context,
                            label: 'Apple App Store',
                            icon: FaIcon(
                              FontAwesomeIcons.appStoreIos,
                              size: 15,
                              color: project.playStoreUrl.trim().isEmpty
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white
                                        : AppColors.textPrimaryLight),
                            ),
                            url: project.appStoreUrl,
                            isPrimary: project.playStoreUrl.trim().isEmpty,
                            isDark: isDark,
                          ),
                        if (project.demoUrl.trim().isNotEmpty)
                          _buildActionButton(
                            context: context,
                            label: 'Live Web Demo',
                            icon: Icon(
                              Icons.open_in_new_rounded,
                              size: 15,
                              color:
                                  (project.playStoreUrl.trim().isEmpty &&
                                      project.appStoreUrl.trim().isEmpty)
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white
                                        : AppColors.textPrimaryLight),
                            ),
                            url: project.demoUrl,
                            isPrimary:
                                project.playStoreUrl.trim().isEmpty &&
                                project.appStoreUrl.trim().isEmpty,
                            isDark: isDark,
                          ),
                        if (project.githubUrl.trim().isNotEmpty)
                          _buildActionButton(
                            context: context,
                            label: 'GitHub Repository',
                            icon: FaIcon(
                              FontAwesomeIcons.github,
                              size: 15,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF24292F),
                            ),
                            url: project.githubUrl,
                            isPrimary: false,
                            isDark: isDark,
                          ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Gallery / Visual Showcase Section
                    // Preserves aspect ratio with BoxFit.contain inside a clean frame
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0A0F1D)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : AppColors.lightCardBorder,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.3 : 0.08,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Main Featured Screenshot Preview
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: isMobile ? 320 : 480,
                              minHeight: 240,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: AppNetworkImage(
                                  imageUrl: currentImage,
                                  fit: BoxFit.contain,
                                  borderRadius: 12,
                                  placeholderText: project.title,
                                  fallbackIcon: Icons.phone_iphone_rounded,
                                ),
                              ),
                            ),
                          ),

                          // Thumbnails Carousel (if more than 1 image available)
                          if (images.length > 1) ...[
                            Divider(
                              height: 1,
                              color: isDark
                                  ? AppColors.darkCardBorder
                                  : AppColors.lightCardBorder,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (int i = 0; i < images.length; i++) ...[
                                      if (i > 0) const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () => setState(
                                          () => _selectedImageIndex = i,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 80,
                                          height: 56,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF1E293B)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: safeImageIndex == i
                                                  ? AppColors.violetPrimary
                                                  : (isDark
                                                        ? AppColors
                                                              .darkCardBorder
                                                        : AppColors
                                                              .lightCardBorder),
                                              width: safeImageIndex == i
                                                  ? 2
                                                  : 1,
                                            ),
                                          ),
                                          child: AppNetworkImage(
                                            imageUrl: images[i],
                                            fit: BoxFit.contain,
                                            borderRadius: 4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Structured Information Sections
                    // 1. Project Overview
                    if (project.fullDescription.isNotEmpty) ...[
                      _buildSectionCard(
                        context: context,
                        icon: Icons.menu_book_rounded,
                        title: 'Project Overview',
                        isDark: isDark,
                        iconColor: AppColors.cyanPrimary,
                        content: Text(
                          project.fullDescription,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 2. Role & Personal Contributions
                    if (project.personalContribution.isNotEmpty) ...[
                      _buildSectionCard(
                        context: context,
                        icon: Icons.assignment_ind_rounded,
                        title: 'My Role & Key Contributions',
                        isDark: isDark,
                        iconColor: AppColors.violetPrimary,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final line
                                in project.personalContribution
                                    .split('\n')
                                    .where((l) => l.trim().isNotEmpty))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      line.startsWith('Role:')
                                          ? Icons.badge_outlined
                                          : Icons.arrow_right_rounded,
                                      size: 18,
                                      color: line.startsWith('Role:')
                                          ? AppColors.cyanPrimary
                                          : AppColors.violetLight,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        line.replaceFirst(
                                          RegExp(r'^[•\-\*]\s*'),
                                          '',
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          fontWeight: line.startsWith('Role:')
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: isDark
                                              ? (line.startsWith('Role:')
                                                    ? Colors.white
                                                    : const Color(0xFFCBD5E1))
                                              : const Color(0xFF334155),
                                        ),
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

                    // 3. Key Features
                    if (project.keyFeatures.isNotEmpty) ...[
                      _buildSectionCard(
                        context: context,
                        icon: Icons.auto_awesome_rounded,
                        title: 'Key Features & Capabilities',
                        isDark: isDark,
                        iconColor: const Color(0xFFF59E0B),
                        content: Column(
                          children: [
                            for (final feature in project.keyFeatures)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF59E0B)
                                            .withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        size: 13,
                                        color: Color(0xFFF59E0B),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.45,
                                          color: isDark
                                              ? const Color(0xFFCBD5E1)
                                              : const Color(0xFF334155),
                                        ),
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

                    // 4. Technology Stack
                    if (project.technologies.isNotEmpty) ...[
                      _buildSectionCard(
                        context: context,
                        icon: Icons.code_rounded,
                        title: 'Technology Stack & Tools',
                        isDark: isDark,
                        iconColor: AppColors.cyanPrimary,
                        content: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: project.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkCardBorder
                                      : AppColors.lightCardBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.terminal_rounded,
                                    size: 13,
                                    color: AppColors.cyanPrimary,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      tech,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 5. Challenges & Solutions
                    if (project.challengesAndSolutions.isNotEmpty) ...[
                      _buildSectionCard(
                        context: context,
                        icon: Icons.psychology_rounded,
                        title: 'Challenges & Engineering Solutions',
                        isDark: isDark,
                        iconColor: const Color(0xFFEC4899),
                        content: Text(
                          project.challengesAndSolutions,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],

                    // Previous / Next Project Navigation Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF141A2E)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : AppColors.lightCardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous Button
                          if (prevProject != null)
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    _navigateToProject(prevProject.slug),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: 14,
                                        color: AppColors.cyanPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Previous',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            Text(
                                              prevProject.title,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
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
                              ),
                            )
                          else
                            const Spacer(),

                          const SizedBox(width: 16),

                          // Next Button
                          if (nextProject != null)
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    _navigateToProject(nextProject.slug),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Next',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            Text(
                                              nextProject.title,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: AppColors.violetPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            const Spacer(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
