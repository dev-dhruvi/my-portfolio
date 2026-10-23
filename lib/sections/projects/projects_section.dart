import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/url_launcher_util.dart';
import '../../models/project.dart';
import '../../widgets/animations/staggered_entrance.dart';
import '../../widgets/cards/app_network_image.dart';
import '../../widgets/navigation/dynamic_scroll_indicators.dart';
import 'all_projects_page.dart';

/// Interactive project showcase on home page:
/// - Mobile: 3D stacked coverflow slider showing up to 5 projects + "View More" button
/// - Tablet: 2-column grid showing up to 12 projects (no auto-scroll, no dots) + "View More" button
/// - Web / Desktop: Single row horizontal slider showing up to 15 projects (3 per page)
///   with auto-scrolling, hover effects, dynamic indicators + "View More" button
class ProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late final PageController _desktopPageController;
  late final ValueNotifier<int> _activePageNotifier;
  final GlobalKey<_MobileStackedProjectSliderState> _mobileSliderKey =
      GlobalKey<_MobileStackedProjectSliderState>();

  @override
  void initState() {
    super.initState();
    _desktopPageController = PageController();
    _activePageNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _desktopPageController.dispose();
    _activePageNotifier.dispose();
    super.dispose();
  }

  void _animateToPage(int pageIndex, int maxPages) {
    final target = pageIndex.clamp(0, math.max(0, maxPages - 1)).toInt();
    if (_desktopPageController.hasClients) {
      _desktopPageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
    _activePageNotifier.value = target;
  }

  void _navigateToAllProjects(BuildContext context) {
    try {
      context.push('/projects');
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AllProjectsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = !isMobile && !isTablet;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    // Filter active projects
    final activeProjects = widget.projects.where((project) {
      return project.isStatusActive;
    }).toList();

    // Device-specific project counts:
    // Mobile: show total 5
    // Tablet: show total 12
    // Web / Desktop: show total 15 in single row listing
    final mobileProjects = activeProjects.take(5).toList();
    final tabletProjects = activeProjects.take(12).toList();
    final desktopProjects = activeProjects.take(15).toList();

    const int desktopItemsPerPage = 3;
    final int desktopPageCount = desktopProjects.isEmpty
        ? 0
        : (desktopProjects.length / desktopItemsPerPage).ceil();

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isDesktop ? MainAxisAlignment.center : MainAxisAlignment.start,
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
          const SizedBox(height: 10),
          Text(
            'Production Applications & Client Projects',
            style: AppTypography.getDisplayMedium(textColor)
                .copyWith(fontSize: isMobile ? 24 : 28),
          ),
          const SizedBox(height: 6),
          Text(
            'Curated projects verified from professional portfolio, showcasing Flutter, GetX, and FlutterFlow implementations.',
            style: AppTypography.getBodyLarge(secondaryTextColor),
          ),
          const SizedBox(height: 24),

          // Projects Display Area per Device Form Factor
          if (activeProjects.isEmpty)
            const SizedBox.shrink()
          else if (isMobile) ...[
            // Mobile: 3D Stacked Coverflow Slider (total 5)
            _MobileStackedProjectSlider(
              key: _mobileSliderKey,
              projects: mobileProjects,
              activePageNotifier: _activePageNotifier,
              onProjectTap: (project) =>
                  _showProjectDetailDialog(context, project),
            ),
            // Mobile View More Button (if more than 5 projects exist)
            if (activeProjects.length > 5) ...[
              const SizedBox(height: 22),
              Center(
                child: ViewMoreButton(
                  onTap: () => _navigateToAllProjects(context),
                ),
              ),
            ],
          ] else if (isTablet) ...[
            // Tablet: 2-column Grid View (total 12, no auto-scrolling, no indicator)
            _TabletProjectGrid(
              projects: tabletProjects,
              onProjectTap: (project) =>
                  _showProjectDetailDialog(context, project),
            ),
            // Tablet View More Button (if more than 12 projects exist)
            if (activeProjects.length > 12) ...[
              const SizedBox(height: 28),
              Center(
                child: ViewMoreButton(
                  onTap: () => _navigateToAllProjects(context),
                ),
              ),
            ],
          ] else ...[
            // Web / Desktop: Single row horizontal slider (total 15, 3 cards per view)
            _DesktopSingleRowProjectSlider(
              projects: desktopProjects,
              pageController: _desktopPageController,
              activePageNotifier: _activePageNotifier,
              onProjectTap: (project) =>
                  _showProjectDetailDialog(context, project),
            ),

            // Dynamic Scroll Indicators with Navigation Arrows (Desktop only)
            ValueListenableBuilder<int>(
              valueListenable: _activePageNotifier,
              builder: (context, activeIndex, _) {
                final int safeIndex = activeIndex
                    .clamp(0, math.max(0, desktopPageCount - 1))
                    .toInt();
                return DynamicScrollIndicators(
                  pageCount: desktopPageCount,
                  activeIndex: safeIndex,
                  onDotTapped: (index) =>
                      _animateToPage(index, desktopPageCount),
                  onPrevious: () =>
                      _animateToPage(safeIndex - 1, desktopPageCount),
                  onNext: () =>
                      _animateToPage(safeIndex + 1, desktopPageCount),
                );
              },
            ),

            // Web View More Button (if more than 15 projects exist)
            if (activeProjects.length > 15) ...[
              const SizedBox(height: 22),
              Center(
                child: ViewMoreButton(
                  onTap: () => _navigateToAllProjects(context),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _showProjectDetailDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) => ProjectDetailDialog(project: project),
    );
  }
}

/// Tablet 2-column static grid displaying up to 12 projects.
/// No auto-scrolling and no row indicator dots, per specification.
class _TabletProjectGrid extends StatelessWidget {
  final List<Project> projects;
  final Function(Project) onProjectTap;

  const _TabletProjectGrid({
    required this.projects,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 310,
      ),
      itemBuilder: (context, index) {
        final project = projects[index];
        return StaggeredEntrance(
          index: index,
          child: ProjectCard(
            project: project,
            isDesktopOrTablet: true,
            onTap: () => onProjectTap(project),
          ),
        );
      },
    );
  }
}

/// Web / Desktop Single Row horizontal paged slider (3 projects per page view).
/// Supports up to 15 projects with auto-scrolling, pause-on-hover, and smooth transitions.
class _DesktopSingleRowProjectSlider extends StatefulWidget {
  final List<Project> projects;
  final PageController pageController;
  final ValueNotifier<int> activePageNotifier;
  final Function(Project) onProjectTap;

  const _DesktopSingleRowProjectSlider({
    required this.projects,
    required this.pageController,
    required this.activePageNotifier,
    required this.onProjectTap,
  });

  @override
  State<_DesktopSingleRowProjectSlider> createState() =>
      _DesktopSingleRowProjectSliderState();
}

class _DesktopSingleRowProjectSliderState
    extends State<_DesktopSingleRowProjectSlider> {
  Timer? _autoplayTimer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startAutoplay();
    });
  }

  @override
  void didUpdateWidget(covariant _DesktopSingleRowProjectSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projects != widget.projects) {
      _startAutoplay();
    }
  }

  @override
  void dispose() {
    _stopAutoplay();
    super.dispose();
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final pageCount = (widget.projects.length / 3).ceil();

    if (disableAnimations || pageCount <= 1) return;

    _autoplayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isHovered || !mounted) return;
      if (widget.pageController.hasClients) {
        final nextPage = (widget.activePageNotifier.value + 1) % pageCount;
        widget.pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    const itemsPerPage = 3;
    final List<List<Project>> pages = [];

    for (var i = 0; i < widget.projects.length; i += itemsPerPage) {
      final end = (i + itemsPerPage < widget.projects.length)
          ? i + itemsPerPage
          : widget.projects.length;
      pages.add(widget.projects.sublist(i, end));
    }

    final pageCount = pages.length;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        height: 335,
        child: PageView.builder(
          controller: widget.pageController,
          itemCount: pageCount,
          onPageChanged: (pageIndex) {
            widget.activePageNotifier.value = pageIndex;
          },
          itemBuilder: (context, pageIndex) {
            final pageItems = pages[pageIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int c = 0; c < itemsPerPage; c++) ...[
                    if (c > 0) const SizedBox(width: 18),
                    if (c < pageItems.length)
                      Expanded(
                        child: StaggeredEntrance(
                          index: c,
                          child: ProjectCard(
                            project: pageItems[c],
                            isDesktopOrTablet: true,
                            onTap: () => widget.onProjectTap(pageItems[c]),
                          ),
                        ),
                      )
                    else
                      const Expanded(
                        child: SizedBox.shrink(),
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Mobile 3D Stacked Card Deck Carousel with infinite auto-scrolling
/// directly inspired by match_slider.dart custom architecture.
class _MobileStackedProjectSlider extends StatefulWidget {
  final List<Project> projects;
  final ValueNotifier<int> activePageNotifier;
  final Function(Project) onProjectTap;

  const _MobileStackedProjectSlider({
    super.key,
    required this.projects,
    required this.activePageNotifier,
    required this.onProjectTap,
  });

  @override
  State<_MobileStackedProjectSlider> createState() =>
      _MobileStackedProjectSliderState();
}

class _MobileStackedProjectSliderState
    extends State<_MobileStackedProjectSlider> {
  late PageController _pageController;
  Timer? _autoplayTimer;
  late int _initialPage;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final count = widget.projects.length;
    _initialPage = count > 1 ? count * 100 : 0;
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.85,
    );
    _pageController.addListener(_onPageScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startAutoplay();
    });
  }

  void _onPageScroll() {
    if (!mounted || !_pageController.hasClients || widget.projects.isEmpty) {
      return;
    }
    final double page = _pageController.page ?? _initialPage.toDouble();
    final int count = widget.projects.length;
    final int realIndex = ((page.round() % count) + count) % count;
    if (widget.activePageNotifier.value != realIndex) {
      widget.activePageNotifier.value = realIndex;
    }
  }

  @override
  void didUpdateWidget(covariant _MobileStackedProjectSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projects != widget.projects) {
      _stopAutoplay();
      _pageController.removeListener(_onPageScroll);
      _pageController.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _stopAutoplay();
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (disableAnimations || widget.projects.length <= 1) return;

    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.projects.length;
    if (count == 0) return const SizedBox.shrink();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth * 0.84).clamp(270.0, 350.0);
    const cardHeight = 445.0;

    if (count == 1) {
      final project = widget.projects.first;
      return SizedBox(
        height: cardHeight,
        child: Center(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ProjectCard(
              project: project,
              isDesktopOrTablet: false,
              onTap: () => widget.onProjectTap(project),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: cardHeight + 20,
      child: Stack(
        children: [
          // Custom 3D Stacked Card Layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                final double page = _pageController.hasClients
                    ? (_pageController.page ?? _initialPage.toDouble())
                    : _initialPage.toDouble();

                final int activeFloor = page.floor();
                final List<int> pagesToRender = [];
                for (int p = activeFloor - 1; p <= activeFloor + 3; p++) {
                  pagesToRender.add(p);
                }

                // Sort pages by Z-order (descending distance from current page)
                pagesToRender.sort((a, b) {
                  final diffA = (a - page).abs();
                  final diffB = (b - page).abs();
                  return diffB.compareTo(diffA);
                });

                return Stack(
                  clipBehavior: Clip.none,
                  children: pagesToRender.map((p) {
                    final double diff = p - page;
                    final int realIndex = ((p % count) + count) % count;
                    final project = widget.projects[realIndex];

                    double scale = 1.0;
                    double translateX = 0.0;
                    double opacity = 1.0;

                    if (diff >= 0) {
                      // Stacked to the right with perspective scale and translation
                      scale = (1.0 - diff * 0.07).clamp(0.0, 1.0);
                      translateX = diff * 24.0;
                      opacity = (1.0 - diff * 0.28).clamp(0.0, 1.0);
                    } else {
                      // Smooth card exit to the left
                      scale = (1.0 + diff * 0.07).clamp(0.0, 1.0);
                      translateX = diff * (cardWidth * 0.92);
                      opacity = (1.0 + diff).clamp(0.0, 1.0);
                    }

                    if (scale <= 0.001 || opacity <= 0.001) {
                      return const SizedBox.shrink();
                    }

                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: Offset(translateX, 0.0),
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: SizedBox(
                                width: cardWidth,
                                height: cardHeight,
                                child: ProjectCard(
                                  project: project,
                                  isDesktopOrTablet: false,
                                  onTap: () => widget.onProjectTap(project),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Transparent PageView to handle user swipe gestures
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) => _stopAutoplay(),
              onPointerUp: (_) => _startAutoplay(),
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final int realIndex = ((index % count) + count) % count;
                  final project = widget.projects[realIndex];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.onProjectTap(project),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient CTA button with hover elevation and sliding arrow.
class ViewMoreButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const ViewMoreButton({
    super.key,
    required this.onTap,
    this.label = 'View More',
  });

  @override
  State<ViewMoreButton> createState() => _ViewMoreButtonState();
}

class _ViewMoreButtonState extends State<ViewMoreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -3.0 : 0.0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.violetPrimary
                    .withOpacity(_isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 6 : 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Transform.translate(
                offset: Offset(_isHovered ? 3.0 : 0.0, 0),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Project Card Component with Animated Hover Elevation,
/// Neon Border Sheen, Banner Zoom, and Interactive CTAs.
class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isDesktopOrTablet;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isDesktopOrTablet = true,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final project = widget.project;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            _isHovered && widget.isDesktopOrTablet ? -6.0 : 0.0,
            0,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered
                    ? const Color(0xFF17172E)
                    : AppColors.darkCard)
                : (_isHovered
                    ? const Color(0xFFF8FAFC)
                    : AppColors.lightCard),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.violetPrimary.withOpacity(0.85)
                  : (isDark
                      ? AppColors.darkCardBorder
                      : AppColors.lightCardBorder),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (isDark && _isHovered) ...[
                BoxShadow(
                  color: AppColors.violetPrimary.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.cyanPrimary.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ] else if (!isDark && _isHovered) ...[
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ] else ...[
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Thumbnail Header with Floating Badges
                Stack(
                  children: [
                    SizedBox(
                      height: widget.isDesktopOrTablet ? 135 : 185,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          child: AppNetworkImage(
                            imageUrl: project.displayImageUrl,
                            height: widget.isDesktopOrTablet ? 135 : 185,
                            width: double.infinity,
                            placeholderText: project.title,
                            fallbackIcon: Icons.phone_iphone_rounded,
                            borderRadius: 0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.78),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                        ),
                        child: Text(
                          project.category,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyanLight,
                          ),
                        ),
                      ),
                    ),
                    if (project.isFeatured)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.violetPrimary.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Featured',
                                style: TextStyle(
                                  fontSize: 10,
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

                // Card Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Company Name (if present)
                            if (project.companyName.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.apartment_rounded,
                                    size: 12,
                                    color: isDark
                                        ? AppColors.violetLight
                                        : AppColors.violetPrimary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      project.companyName,
                                      style: TextStyle(
                                        fontSize: 11,
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
                              const SizedBox(height: 3),
                            ],

                            // Project Title
                            Text(
                              project.title,
                              style: TextStyle(
                                fontSize: widget.isDesktopOrTablet ? 15 : 16.5,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Short Description
                            Text(
                              project.shortDescription,
                              style: TextStyle(
                                fontSize: 11.5,
                                height: 1.35,
                                color: secondaryTextColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),

                            // Technologies Chips (up to 3)
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children:
                                  project.technologies.take(3).map((tech) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkCardHover
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkCardBorder
                                          : AppColors.lightCardBorder,
                                    ),
                                  ),
                                  child: Text(
                                    tech,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        // Action Footer: Store Links & Details CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (project.playStoreUrl.isNotEmpty) ...[
                                      InkWell(
                                        onTap: () => UrlLauncherUtil.openUrl(
                                          project.playStoreUrl,
                                          context: context,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (isDark
                                                    ? AppColors.cyanPrimary
                                                    : AppColors.cyanDark)
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: (isDark
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
                                                size: 13,
                                                color: isDark
                                                    ? AppColors.cyanLight
                                                    : AppColors.cyanDark,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                'Play Store',
                                                style: TextStyle(
                                                  fontSize: 10,
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
                                      const SizedBox(width: 5),
                                    ],
                                    if (project.appStoreUrl.isNotEmpty) ...[
                                      InkWell(
                                        onTap: () => UrlLauncherUtil.openUrl(
                                          project.appStoreUrl,
                                          context: context,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (isDark
                                                    ? AppColors.violetPrimary
                                                    : AppColors.violetDark)
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: (isDark
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
                                                size: 13,
                                                color: isDark
                                                    ? AppColors.violetLight
                                                    : AppColors.violetDark,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                'App Store',
                                                style: TextStyle(
                                                  fontSize: 10,
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: _isHovered
                                        ? AppColors.cyanPrimary
                                        : (isDark
                                            ? AppColors.cyanLight
                                            : AppColors.violetPrimary),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Transform.translate(
                                  offset: Offset(_isHovered ? 3.0 : 0.0, 0),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: _isHovered
                                        ? AppColors.cyanPrimary
                                        : (isDark
                                            ? AppColors.cyanLight
                                            : AppColors.violetPrimary),
                                  ),
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
          ),
        ),
      ),
    );
  }
}

class ProjectDetailDialog extends StatelessWidget {
  final Project project;

  const ProjectDetailDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
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
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Google Play'),
                      ),
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
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('App Store'),
                      ),
                    ),
                  if (project.githubUrl.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.githubUrl,
                        context: context,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Source Code'),
                      ),
                    ),
                  if (project.demoUrl.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => UrlLauncherUtil.openUrl(
                        project.demoUrl,
                        context: context,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Live Demo'),
                      ),
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
