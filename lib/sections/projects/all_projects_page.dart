import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../models/project.dart';
import '../../repositories/portfolio_repository.dart';
import '../../widgets/animations/ambient_background.dart';
import '../../widgets/responsive/responsive_layout.dart';
import 'projects_section.dart';

/// Dedicated page displaying the complete portfolio of client & production projects.
/// Features responsive multi-column layouts (1-col mobile, 2-col tablet, 3-col web),
/// smooth incremental pagination when scrolling down, and card entrance animations.
class AllProjectsPage extends StatefulWidget {
  final List<Project>? projects;

  const AllProjectsPage({super.key, this.projects});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  int _displayedCount = 6;
  bool _isLoadingMore = false;
  bool _hasInitializedCount = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedCount) {
      _hasInitializedCount = true;
      final isMobile = AppBreakpoints.isMobile(context);
      final isTablet = AppBreakpoints.isTablet(context);
      // Initial page capacity: 9 on desktop (3x3), 6 on tablet (2x3), 5 on mobile
      _displayedCount = isMobile ? 5 : (isTablet ? 6 : 9);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger load more when 250px from bottom
    if (currentScroll >= maxScroll - 250) {
      _loadMore();
    }
  }

  void _loadMore() {
    final allProjects = _getAllActiveProjects();
    if (_displayedCount >= allProjects.length) return;

    setState(() => _isLoadingMore = true);

    // Smooth delay for natural scrolling pagination feel
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) {
        final isMobile = AppBreakpoints.isMobile(context);
        final batchSize = isMobile ? 4 : 6;
        setState(() {
          _displayedCount = math.min(
            _displayedCount + batchSize,
            allProjects.length,
          );
          _isLoadingMore = false;
        });
      }
    });
  }

  List<Project> _getAllActiveProjects() {
    if (widget.projects != null) {
      return widget.projects!.where((p) => p.isStatusActive).toList();
    }
    final repo = context.read<PortfolioRepository>();
    return repo.projects.where((p) => p.isStatusActive).toList();
  }

  void _showDetailDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) => ProjectDetailDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final allProjects = _getAllActiveProjects();
    final displayedProjects = allProjects
        .take(math.min(_displayedCount, allProjects.length))
        .toList();
    final bool hasReachedEnd = _displayedCount >= allProjects.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: (isDark ? AppColors.darkSurface : Colors.white)
            .withOpacity(0.92),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back to Portfolio',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'DP',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'All Projects',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              final theme = Provider.of<ThemeController?>(context);
              if (theme == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  theme.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 20,
                ),
                tooltip: theme.isDarkMode ? 'Light Theme' : 'Dark Theme',
                onPressed: theme.toggleTheme,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AmbientBackground(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 24,
          ),
          child: Center(
            child: ResponsiveContentContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header Section
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
                        'PROJECT DIRECTORY',
                        style: TextStyle(
                          color: AppColors.cyanPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.violetPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.violetPrimary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${allProjects.length} Projects',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.cyanLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'All Client & Production Projects',
                    style: AppTypography.getDisplayMedium(textColor)
                        .copyWith(fontSize: isMobile ? 24 : 32),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Comprehensive archive of verified Flutter, GetX, and cross-platform applications with full architecture breakdowns and store links.',
                    style: AppTypography.getBodyLarge(secondaryTextColor),
                  ),
                  const SizedBox(height: 28),

                  // Responsive Multi-Device Listing Layouts:
                  // Mobile: Vertical listing of cards
                  // Tablet: 2-column GridView style
                  // Web / Desktop: 3-column GridView style
                  if (isMobile)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedProjects.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final project = displayedProjects[index];
                        return _AnimatedCardWrapper(
                          key: ValueKey('all_proj_m_${project.id}'),
                          index: index,
                          child: ProjectCard(
                            project: project,
                            isDesktopOrTablet: false,
                            onTap: () => _showDetailDialog(context, project),
                          ),
                        );
                      },
                    )
                  else if (isTablet)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedProjects.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            mainAxisExtent: 315,
                          ),
                      itemBuilder: (context, index) {
                        final project = displayedProjects[index];
                        return _AnimatedCardWrapper(
                          key: ValueKey('all_proj_t_${project.id}'),
                          index: index,
                          child: ProjectCard(
                            project: project,
                            isDesktopOrTablet: true,
                            onTap: () => _showDetailDialog(context, project),
                          ),
                        );
                      },
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedProjects.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            mainAxisExtent: 315,
                          ),
                      itemBuilder: (context, index) {
                        final project = displayedProjects[index];
                        return _AnimatedCardWrapper(
                          key: ValueKey('all_proj_d_${project.id}'),
                          index: index,
                          child: ProjectCard(
                            project: project,
                            isDesktopOrTablet: true,
                            onTap: () => _showDetailDialog(context, project),
                          ),
                        );
                      },
                    ),

                  // Pagination Loading Indicator
                  if (_isLoadingMore)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.cyanPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Loading more projects...',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Reached End Indicator
                  if (hasReachedEnd && allProjects.isNotEmpty) ...[
                    const SizedBox(height: 36),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.darkCard : Colors.white)
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkCardBorder
                                : AppColors.lightCardBorder,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.2 : 0.04,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppColors.cyanPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "You've viewed all ${allProjects.length} projects",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Smooth fade-and-slide card entrance animation wrapper for pagination.
class _AnimatedCardWrapper extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedCardWrapper({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 24 * (1.0 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: child,
    );
  }
}
