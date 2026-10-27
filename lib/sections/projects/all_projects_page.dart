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
/// Features responsive multi-column layouts (1-col mobile, 3-col tablet, 4-col web),
/// scroll-driven infinite load pagination on mobile, interactive page controls on tablet & desktop,
/// and a polished cyber-glass status & "View All" toggle bar.
class AllProjectsPage extends StatefulWidget {
  final List<Project>? projects;

  const AllProjectsPage({super.key, this.projects});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final bool _showAll = false;

  // Mobile scroll pagination state
  static const int _mobilePageSize = 6;
  int _mobileDisplayedCount = _mobilePageSize;
  bool _isLoadingMoreMobile = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (!AppBreakpoints.isMobile(context)) return;
    if (_isLoadingMoreMobile) return;

    final total = _getAllActiveProjects().length;
    if (_mobileDisplayedCount >= total) return;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 240) {
      _loadMoreMobileProjects();
    }
  }

  Future<void> _loadMoreMobileProjects() async {
    if (_isLoadingMoreMobile) return;
    setState(() => _isLoadingMoreMobile = true);

    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    setState(() {
      _isLoadingMoreMobile = false;
      _mobileDisplayedCount = math.min(
        _mobileDisplayedCount + _mobilePageSize,
        _getAllActiveProjects().length,
      );
    });
  }

  int _getItemsPerPage(BuildContext context) {
    if (AppBreakpoints.isMobile(context)) return _mobilePageSize;
    if (AppBreakpoints.isTablet(context)) return 9; // 3 columns x 3 rows
    return 12; // 4 columns x 3 rows on desktop
  }

  void _goToPage(int page) {
    if (page == _currentPage) return;
    setState(() {
      _currentPage = page;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
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
    final int totalProjects = allProjects.length;
    final int itemsPerPage = _getItemsPerPage(context);
    final int pageCount = totalProjects == 0
        ? 1
        : (totalProjects / itemsPerPage).ceil();
    final int safeCurrentPage = _currentPage.clamp(
      0,
      math.max(0, pageCount - 1),
    );

    final int startIndex = safeCurrentPage * itemsPerPage;
    final int endIndex = math.min(startIndex + itemsPerPage, totalProjects);

    // Responsive project list selection
    final List<Project> displayedProjects;
    if (isMobile) {
      displayedProjects = totalProjects == 0
          ? <Project>[]
          : allProjects.sublist(
              0,
              math.min(_mobileDisplayedCount, totalProjects),
            );
    } else {
      displayedProjects = _showAll
          ? allProjects
          : (totalProjects == 0
                ? <Project>[]
                : allProjects.sublist(startIndex, endIndex));
    }

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
                  // Mobile: Vertical listing of cards (1 col)
                  // Tablet: 3-column GridView style
                  // Web / Desktop: 4-column GridView style
                  if (displayedProjects.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'No projects found.',
                          style: TextStyle(
                            fontSize: 16,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    )
                  else if (isMobile)
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(safeCurrentPage),
                        child: GridView.builder(
                          key: ValueKey<int>(safeCurrentPage),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedProjects.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                mainAxisExtent: 380,
                              ),
                          itemBuilder: (context, index) {
                            final project = displayedProjects[index];
                            return _AnimatedCardWrapper(
                              key: ValueKey('all_proj_t_${project.id}'),
                              index: index,
                              child: ProjectCard(
                                project: project,
                                isDesktopOrTablet: true,
                                enable3D: true,
                                onTap: () =>
                                    _showDetailDialog(context, project),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(safeCurrentPage),
                        child: GridView.builder(
                          key: ValueKey<int>(safeCurrentPage),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedProjects.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                mainAxisExtent: 385,
                              ),
                          itemBuilder: (context, index) {
                            final project = displayedProjects[index];
                            return _AnimatedCardWrapper(
                              key: ValueKey('all_proj_d_${project.id}'),
                              index: index,
                              child: ProjectCard(
                                project: project,
                                isDesktopOrTablet: true,
                                enable3D: true,
                                onTap: () =>
                                    _showDetailDialog(context, project),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Mobile Scroll Pagination & Status Line
                  if (isMobile && totalProjects > 0) ...[
                    const SizedBox(height: 28),
                    _buildMobilePaginationFooter(
                      context,
                      totalCount: totalProjects,
                      displayedCount: math.min(
                        _mobileDisplayedCount,
                        totalProjects,
                      ),
                      isLoadingMore: _isLoadingMoreMobile,
                      isDark: isDark,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      onLoadMore: _loadMoreMobileProjects,
                    ),
                  ],

                  // Desktop & Tablet Pagination Controls & Improved Status Bar
                  if (!isMobile && totalProjects > 0) ...[
                    const SizedBox(height: 36),
                    if (!_showAll && pageCount > 1) ...[
                      _buildPaginationControls(
                        context,
                        currentPage: safeCurrentPage,
                        pageCount: pageCount,
                        isDark: isDark,
                        textColor: textColor,
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Numbered pagination buttons for tablet and desktop views.
  Widget _buildPaginationControls(
    BuildContext context, {
    required int currentPage,
    required int pageCount,
    required bool isDark,
    required Color textColor,
  }) {
    final hasPrev = currentPage > 0;
    final hasNext = currentPage < pageCount - 1;

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          // Previous Page Button
          OutlinedButton.icon(
            onPressed: hasPrev ? () => _goToPage(currentPage - 1) : null,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 13),
            label: const Text(
              'Previous',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.cyanLight
                  : AppColors.cyanDark,
              disabledForegroundColor: isDark ? Colors.white24 : Colors.black26,
              side: BorderSide(
                color: hasPrev
                    ? (isDark
                          ? AppColors.cyanPrimary.withOpacity(0.4)
                          : AppColors.violetPrimary.withOpacity(0.3))
                    : (isDark ? Colors.white12 : Colors.black12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),

          // Page Number Chips
          for (int i = 0; i < pageCount; i++) ...[
            Builder(
              builder: (context) {
                final isSelected = i == currentPage;
                return InkWell(
                  onTap: () => _goToPage(i),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected
                          ? null
                          : (isDark ? AppColors.darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                  ? AppColors.darkCardBorder
                                  : AppColors.lightCardBorder),
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.violetPrimary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected ? Colors.white : textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          // Next Page Button
          OutlinedButton.icon(
            onPressed: hasNext ? () => _goToPage(currentPage + 1) : null,
            label: const Text(
              'Next',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.cyanLight
                  : AppColors.cyanDark,
              disabledForegroundColor: isDark ? Colors.white24 : Colors.black26,
              side: BorderSide(
                color: hasNext
                    ? (isDark
                          ? AppColors.cyanPrimary.withOpacity(0.4)
                          : AppColors.violetPrimary.withOpacity(0.3))
                    : (isDark ? Colors.white12 : Colors.black12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile infinite scroll-driven loading footer & progress capsule.
  Widget _buildMobilePaginationFooter(
    BuildContext context, {
    required int totalCount,
    required int displayedCount,
    required bool isLoadingMore,
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required VoidCallback onLoadMore,
  }) {
    final hasMore = displayedCount < totalCount;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active loading animation card
          if (isLoadingMore) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF0F172A) : Colors.white)
                    .withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.cyanPrimary.withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanPrimary.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.cyanPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Loading more projects...',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyanLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Polished Status Capsule & Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF0F172A) : Colors.white)
                  .withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E2848)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Icon(
                //       hasMore ? Icons.layers_rounded : Icons.verified_rounded,
                //       size: 15,
                //       color: AppColors.cyanPrimary,
                //     ),
                //     const SizedBox(width: 8),
                //     Text(
                //       hasMore
                //           ? 'Showing $displayedCount of $totalCount projects'
                //           : 'All $totalCount projects loaded',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: textColor,
                //       ),
                //     ),
                //   ],
                // ),
                if (hasMore) ...[
                  const SizedBox(height: 8),
                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 160,
                      height: 4,
                      child: LinearProgressIndicator(
                        value: totalCount == 0
                            ? 1
                            : displayedCount / totalCount,
                        backgroundColor: isDark
                            ? Colors.white10
                            : Colors.black12,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.cyanPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: isLoadingMore ? null : onLoadMore,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                    ),
                    label: const Text(
                      'Load More',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.cyanPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                    ),
                  ),
                ] else ...[
                  // const SizedBox(height: 6),
                  InkWell(
                    onTap: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 13,
                            color: AppColors.cyanLight,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back to Top',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.cyanLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
