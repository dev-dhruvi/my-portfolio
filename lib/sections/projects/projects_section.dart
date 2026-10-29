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
import '../../widgets/animations/interactive_3d_card.dart';
import '../../widgets/animations/scroll_reveal.dart';
import '../../widgets/cards/app_network_image.dart';
import '../../widgets/navigation/dynamic_scroll_indicators.dart';
import 'all_projects_page.dart';

/// Interactive project showcase on home page:
/// - Mobile: 3D stacked coverflow slider showing up to 5 projects + "View More" button
/// - Tablet: 2*2 grid horizontal slider showing up to 12 projects (4 per page)
///   with dynamic indicator dots (no side arrows) + "View All Projects" button
/// - Web / Desktop: Single row horizontal slider showing up to 12 projects (4 per page)
///   with auto-scrolling, hover effects, dynamic indicator dots (no side arrows) + "View All Projects" button
class ProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late final PageController _desktopPageController;
  late final ValueNotifier<int> _desktopActivePageNotifier;
  late final PageController _tabletPageController;
  late final ValueNotifier<int> _tabletActivePageNotifier;
  late final ValueNotifier<int> _mobileActivePageNotifier;
  final GlobalKey<_MobileStackedProjectSliderState> _mobileSliderKey =
      GlobalKey<_MobileStackedProjectSliderState>();

  @override
  void initState() {
    super.initState();
    _desktopPageController = PageController();
    _desktopActivePageNotifier = ValueNotifier<int>(0);
    _tabletPageController = PageController();
    _tabletActivePageNotifier = ValueNotifier<int>(0);
    _mobileActivePageNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _desktopPageController.dispose();
    _desktopActivePageNotifier.dispose();
    _tabletPageController.dispose();
    _tabletActivePageNotifier.dispose();
    _mobileActivePageNotifier.dispose();
    super.dispose();
  }

  void _animateToDesktopPage(int pageIndex, int maxPages) {
    final target = pageIndex.clamp(0, math.max(0, maxPages - 1)).toInt();
    if (_desktopPageController.hasClients) {
      _desktopPageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
    _desktopActivePageNotifier.value = target;
  }

  void _animateToTabletPage(int pageIndex, int maxPages) {
    final target = pageIndex.clamp(0, math.max(0, maxPages - 1)).toInt();
    if (_tabletPageController.hasClients) {
      _tabletPageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
    _tabletActivePageNotifier.value = target;
  }

  void _navigateToAllProjects(BuildContext context) {
    try {
      context.push('/projects');
    } catch (_) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const AllProjectsPage()));
    }
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
    // Filter and sort active projects by verified priority (orderIndex)
    final activeProjects = (widget.projects.where((project) {
      return project.isStatusActive;
    }).toList())..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    // Device-specific project counts:
    // Mobile: show total 5
    // Tablet: show total 12 (4 cards per view, 2x2 grid)
    // Web / Desktop: show total 12 in single row listing (4 cards per view)
    final mobileProjects = activeProjects.take(5).toList();
    final tabletProjects = activeProjects.take(12).toList();
    final desktopProjects = activeProjects.take(12).toList();

    const int tabletItemsPerPage = 4;
    final int tabletPageCount = tabletProjects.isEmpty
        ? 0
        : (tabletProjects.length / tabletItemsPerPage).ceil();

    const int desktopItemsPerPage = 4;
    final int desktopPageCount = desktopProjects.isEmpty
        ? 0
        : (desktopProjects.length / desktopItemsPerPage).ceil();

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          // Section Tag & Title with clipped text reveal
          ScrollReveal.clippedText(
            staggerIndex: 0,
            child: Row(
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
          ),
          const SizedBox(height: 10),
          ScrollReveal.clippedText(
            staggerIndex: 1,
            child: Text(
              'Production Applications & Client Projects',
              style: AppTypography.getDisplayMedium(textColor)
                  .copyWith(fontSize: isMobile ? 24 : 28),
            ),
          ),
          const SizedBox(height: 24),

          // Projects Display Area per Device Form Factor
          if (activeProjects.isEmpty)
            const SizedBox.shrink()
          else
            ScrollReveal(
              staggerIndex: 2,
              slideDistance: 20.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMobile) ...[
                    // Mobile: 3D Stacked Coverflow Slider (total 5)
                    _MobileStackedProjectSlider(
                      key: _mobileSliderKey,
                      projects: mobileProjects,
                      activePageNotifier: _mobileActivePageNotifier,
                      onProjectTap: (project) =>
                          _showProjectDetailDialog(context, project),
                    ),
                    // Mobile View More Button (if more than 5 projects exist)
                    if (activeProjects.length > 5) ...[
                      const SizedBox(height: 22),
                      Center(
                        child: ViewMoreButton(
                          label: 'View All Projects',
                          onTap: () => _navigateToAllProjects(context),
                        ),
                      ),
                    ],
                  ] else if (isTablet) ...[
                    // Tablet: 2*2 view slider (total 12, 4 cards per page view in 2x2 grid)
                    _Tablet2x2ProjectSlider(
                      projects: tabletProjects,
                      pageController: _tabletPageController,
                      activePageNotifier: _tabletActivePageNotifier,
                      onProjectTap: (project) =>
                          _showProjectDetailDialog(context, project),
                    ),

                    // Dynamic Scroll Indicators without side arrows (Tablet)
                    ValueListenableBuilder<int>(
                      valueListenable: _tabletActivePageNotifier,
                      builder: (context, activeIndex, _) {
                        final int safeIndex = activeIndex
                            .clamp(0, math.max(0, tabletPageCount - 1))
                            .toInt();
                        return DynamicScrollIndicators(
                          pageCount: tabletPageCount,
                          activeIndex: safeIndex,
                          showArrows: false,
                          onDotTapped: (index) =>
                              _animateToTabletPage(index, tabletPageCount),
                        );
                      },
                    ),

                    // Tablet View More Button (if more than 12 projects exist)
                    if (activeProjects.length > 12) ...[
                      const SizedBox(height: 28),
                      Center(
                        child: ViewMoreButton(
                          label: 'View All Projects',
                          onTap: () => _navigateToAllProjects(context),
                        ),
                      ),
                    ],
                  ] else ...[
                    // Web / Desktop: Single row horizontal slider (total 12, 4 cards per view)
                    _DesktopSingleRowProjectSlider(
                      projects: desktopProjects,
                      pageController: _desktopPageController,
                      activePageNotifier: _desktopActivePageNotifier,
                      onProjectTap: (project) =>
                          _showProjectDetailDialog(context, project),
                    ),

                    // Dynamic Scroll Indicators without side arrows (Desktop only)
                    ValueListenableBuilder<int>(
                      valueListenable: _desktopActivePageNotifier,
                      builder: (context, activeIndex, _) {
                        final int safeIndex = activeIndex
                            .clamp(0, math.max(0, desktopPageCount - 1))
                            .toInt();
                        return DynamicScrollIndicators(
                          pageCount: desktopPageCount,
                          activeIndex: safeIndex,
                          showArrows: false,
                          onDotTapped: (index) =>
                              _animateToDesktopPage(index, desktopPageCount),
                        );
                      },
                    ),

                    // Web View More Button (if more than 12 projects exist)
                    if (activeProjects.length > 12) ...[
                      const SizedBox(height: 22),
                      Center(
                        child: ViewMoreButton(
                          label: 'View All Projects',
                          onTap: () => _navigateToAllProjects(context),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
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

/// Tablet 2*2 Grid horizontal paged slider (4 projects per page view: 2x2 grid).
/// Displays up to 12 projects across pages with smooth swipe navigation and dynamic indicator dots.
class _Tablet2x2ProjectSlider extends StatefulWidget {
  final List<Project> projects;
  final PageController pageController;
  final ValueNotifier<int> activePageNotifier;
  final Function(Project) onProjectTap;

  const _Tablet2x2ProjectSlider({
    required this.projects,
    required this.pageController,
    required this.activePageNotifier,
    required this.onProjectTap,
  });

  @override
  State<_Tablet2x2ProjectSlider> createState() =>
      _Tablet2x2ProjectSliderState();
}

class _Tablet2x2ProjectSliderState extends State<_Tablet2x2ProjectSlider> {
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
  void didUpdateWidget(covariant _Tablet2x2ProjectSlider oldWidget) {
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
    final pageCount = (widget.projects.length / 4).ceil();

    if (disableAnimations || pageCount <= 1) return;

    _autoplayTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
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
    const itemsPerPage = 4;
    final List<List<Project>> pages = [];

    for (var i = 0; i < widget.projects.length; i += itemsPerPage) {
      final end = (i + itemsPerPage < widget.projects.length)
          ? i + itemsPerPage
          : widget.projects.length;
      pages.add(widget.projects.sublist(i, end));
    }

    final pageCount = pages.length;

    return MouseRegion(
      onEnter: (_) => _isHovered = true,
      onExit: (_) => _isHovered = false,
      child: SizedBox(
        height: 640,
        child: PageView.builder(
          controller: widget.pageController,
          itemCount: pageCount,
          onPageChanged: (pageIndex) {
            widget.activePageNotifier.value = pageIndex;
          },
          itemBuilder: (context, pageIndex) {
            final pageItems = pages[pageIndex];

            return AnimatedBuilder(
              animation: widget.pageController,
              builder: (context, _) {
                double currentPage = pageIndex.toDouble();
                if (widget.pageController.hasClients &&
                    widget.pageController.positions.length == 1) {
                  final pos = widget.pageController.position;
                  if (pos.hasContentDimensions &&
                      widget.pageController.page != null) {
                    currentPage = widget.pageController.page!;
                  }
                }
                final double pageDelta = pageIndex - currentPage;
                final double scale = (1.0 - (pageDelta.abs() * 0.06)).clamp(
                  0.9,
                  1.0,
                );
                final double opacity = (1.0 - (pageDelta.abs() * 0.4)).clamp(
                  0.0,
                  1.0,
                );

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: pageItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 310,
                          ),
                      itemBuilder: (context, index) {
                        final project = pageItems[index];
                        final double quadrantOffset = switch (index) {
                          0 => -1.0,
                          1 => 1.0,
                          2 => -0.8,
                          3 => 0.8,
                          _ => 0.0,
                        };

                        return Transform.translate(
                          offset: Offset(
                            pageDelta * quadrantOffset * 10.0,
                            0.0,
                          ),
                          child: ProjectCard(
                            project: project,
                            isDesktopOrTablet: true,
                            enable3D: true,
                            onTap: () => widget.onProjectTap(project),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Web / Desktop Single Row horizontal paged slider (4 projects per page view).
/// Supports up to 12 projects with auto-scrolling, pause-on-hover, and smooth transitions.
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
    final pageCount = (widget.projects.length / 4).ceil();

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
    const itemsPerPage = 4;
    final List<List<Project>> pages = [];

    for (var i = 0; i < widget.projects.length; i += itemsPerPage) {
      final end = (i + itemsPerPage < widget.projects.length)
          ? i + itemsPerPage
          : widget.projects.length;
      pages.add(widget.projects.sublist(i, end));
    }

    final pageCount = pages.length;

    return MouseRegion(
      onEnter: (_) => _isHovered = true,
      onExit: (_) => _isHovered = false,
      child: SizedBox(
        height: 340,
        child: PageView.builder(
          controller: widget.pageController,
          itemCount: pageCount,
          onPageChanged: (pageIndex) {
            widget.activePageNotifier.value = pageIndex;
          },
          itemBuilder: (context, pageIndex) {
            final pageItems = pages[pageIndex];

            return AnimatedBuilder(
              animation: widget.pageController,
              builder: (context, _) {
                double currentPage = pageIndex.toDouble();
                if (widget.pageController.hasClients &&
                    widget.pageController.positions.length == 1) {
                  final pos = widget.pageController.position;
                  if (pos.hasContentDimensions &&
                      widget.pageController.page != null) {
                    currentPage = widget.pageController.page!;
                  }
                }
                final double pageDelta = pageIndex - currentPage;
                final double rotY = (-pageDelta * 0.08).clamp(-0.2, 0.2);
                final double pageOpacity = (1.0 - (pageDelta.abs() * 0.35))
                    .clamp(0.0, 1.0);

                return Opacity(
                  opacity: pageOpacity,
                  child: Transform(
                    alignment: pageDelta > 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0008)
                      ..rotateY(rotY),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int c = 0; c < itemsPerPage; c++) ...[
                            if (c > 0) const SizedBox(width: 16),
                            if (c < pageItems.length)
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(
                                    0.0,
                                    pageDelta.abs() * (c * 4.0),
                                  ),
                                  child: ProjectCard(
                                    project: pageItems[c],
                                    isDesktopOrTablet: true,
                                    enable3D: true,
                                    onTap: () =>
                                        widget.onProjectTap(pageItems[c]),
                                  ),
                                ),
                              )
                            else
                              const Expanded(child: SizedBox.shrink()),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    if (!mounted ||
        !_pageController.hasClients ||
        _pageController.positions.length != 1 ||
        widget.projects.isEmpty) {
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
                final double page =
                    (_pageController.hasClients &&
                        _pageController.positions.length == 1)
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

                    final double rotateZ = diff < 0
                        ? (-diff * 0.05).clamp(-0.15, 0.15)
                        : (diff * 0.015).clamp(0.0, 0.05);

                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            ..translate(
                              translateX,
                              diff < 0 ? -diff * 10.0 : 0.0,
                            )
                            ..rotateZ(rotateZ)
                            ..scale(scale),
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
    this.label = 'View All Projects',
  });

  @override
  State<ViewMoreButton> createState() => _ViewMoreButtonState();
}

class _ViewMoreButtonState extends State<ViewMoreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final buttonContent = GestureDetector(
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
              color: AppColors.violetPrimary.withOpacity(
                _isHovered ? 0.45 : 0.25,
              ),
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
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isHovered) {
              setState(() => _isHovered = true);
            }
          });
        }
      },
      onExit: (_) {
        if (_isHovered && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _isHovered) {
              setState(() => _isHovered = false);
            }
          });
        }
      },
      child: buttonContent,
    );
  }
}

/// Project Card Component with Animated Hover Elevation,
/// Prominent Display Image, Company Name, and Direct App Store/Play Store/GitHub Icons.
class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final bool isDesktopOrTablet;
  final bool enable3D;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isDesktopOrTablet = true,
    this.enable3D = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Widget _buildStoreIconButton({
    required BuildContext context,
    required String url,
    required Widget icon,
    required String tooltip,
    required bool isDark,
    Color? accentColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => UrlLauncherUtil.openUrl(url, context: context),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isDark
                ? (accentColor?.withOpacity(0.14) ?? const Color(0xFF1E293B))
                : (accentColor?.withOpacity(0.08) ?? const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark
                  ? (accentColor?.withOpacity(0.28) ?? AppColors.darkCardBorder)
                  : (accentColor?.withOpacity(0.20) ??
                        AppColors.lightCardBorder),
              width: 1,
            ),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }

  Widget _buildActionIcons(BuildContext context, {required bool isDark}) {
    final project = widget.project;
    final List<Widget> actionIcons = [];

    if (project.playStoreUrl.isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.playStoreUrl,
          tooltip: 'Google Play',
          isDark: isDark,
          accentColor: AppColors.cyanPrimary,
          icon: FaIcon(
            FontAwesomeIcons.googlePlay,
            size: 13,
            color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
          ),
        ),
      );
    }

    if (project.appStoreUrl.isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.appStoreUrl,
          tooltip: 'App Store',
          isDark: isDark,
          accentColor: AppColors.violetPrimary,
          icon: FaIcon(
            FontAwesomeIcons.appStoreIos,
            size: 14,
            color: isDark ? AppColors.violetLight : AppColors.violetPrimary,
          ),
        ),
      );
    }

    if (project.githubUrl.isNotEmpty) {
      actionIcons.add(
        _buildStoreIconButton(
          context: context,
          url: project.githubUrl,
          tooltip: 'GitHub',
          isDark: isDark,
          accentColor: const Color(0xFFA78BFA),
          icon: FaIcon(
            FontAwesomeIcons.github,
            size: 14,
            color: isDark ? Colors.white : const Color(0xFF24292F),
          ),
        ),
      );
    }

    if (actionIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actionIcons.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          actionIcons[i],
        ],
      ],
    );
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
    final project = widget.project;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isBoundedHeight = constraints.maxHeight.isFinite;

        final cardBodyContent = Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Project Title with smooth hover translation & arrow
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(
                  _isHovered && widget.isDesktopOrTablet ? 3.0 : 0.0,
                  0,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: TextStyle(
                          fontSize: widget.isDesktopOrTablet ? 15 : 16.5,
                          fontWeight: FontWeight.w700,
                          color: _isHovered && widget.isDesktopOrTablet
                              ? (isDark
                                    ? AppColors.cyanPrimary
                                    : AppColors.violetPrimary)
                              : textColor,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.isDesktopOrTablet) ...[
                      const SizedBox(width: 4),
                      AnimatedOpacity(
                        opacity: _isHovered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: 13,
                          color: isDark
                              ? AppColors.cyanPrimary
                              : AppColors.violetPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Bottom Row: Company Name (bottom left) & Store / GitHub Icons (bottom right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Company Name (bottom left)
                  Expanded(
                    child: project.companyName.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.apartment_rounded,
                                size: 13,
                                color: isDark
                                    ? AppColors.violetLight
                                    : AppColors.violetPrimary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  project.companyName,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),

                  // Store & GitHub Icons (bottom right)
                  _buildActionIcons(context, isDark: isDark),
                ],
              ),
            ],
          ),
        );

        final cardThumbnail = ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: AppNetworkImage(
                  imageUrl: project.displayImageUrl,
                  height: isBoundedHeight
                      ? double.infinity
                      : (widget.isDesktopOrTablet ? 230 : 260),
                  width: double.infinity,
                  placeholderText: project.title,
                  fallbackIcon: Icons.phone_iphone_rounded,
                  borderRadius: 0,
                ),
              ),

              // Flag / Badge: "Featured" if dedicated image is provided, "Client Projects" if image is not there
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4.5,
                  ),
                  decoration: BoxDecoration(
                    color: project.hasCustomImage
                        ? (isDark
                              ? AppColors.violetPrimary.withOpacity(0.88)
                              : AppColors.violetPrimary)
                        : (isDark
                              ? const Color(0xFF0F172A).withOpacity(0.88)
                              : const Color(0xFF334155).withOpacity(0.92)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: project.hasCustomImage
                          ? AppColors.cyanPrimary.withOpacity(0.65)
                          : Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        project.hasCustomImage
                            ? Icons.star_rounded
                            : Icons.business_center_rounded,
                        size: 11,
                        color: project.hasCustomImage
                            ? AppColors.cyanLight
                            : Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        project.hasCustomImage ? 'Featured' : 'Client Projects',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        final cardContent = GestureDetector(
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
                  ? (_isHovered ? const Color(0xFF17172E) : AppColors.darkCard)
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
                mainAxisSize: isBoundedHeight
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  // Increased display image thumbnail
                  if (isBoundedHeight)
                    Expanded(child: cardThumbnail)
                  else
                    SizedBox(
                      height: widget.isDesktopOrTablet ? 230 : 260,
                      width: double.infinity,
                      child: cardThumbnail,
                    ),

                  // Card Body
                  cardBodyContent,
                ],
              ),
            ),
          ),
        );

        // On mobile touch viewports, skip MouseRegion entirely to avoid scheduler assertion collisions
        if (!widget.isDesktopOrTablet) {
          return cardContent;
        }

        if (widget.enable3D) {
          return Interactive3DCard(
            borderRadius: BorderRadius.circular(16),
            child: cardContent,
          );
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            if (!_isHovered && mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isHovered) {
                  setState(() => _isHovered = true);
                }
              });
            }
          },
          onExit: (_) {
            if (_isHovered && mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _isHovered) {
                  setState(() => _isHovered = false);
                }
              });
            }
          },
          child: cardContent,
        );
      },
    );
  }
}

class ProjectDetailDialog extends StatelessWidget {
  final Project project;

  const ProjectDetailDialog({super.key, required this.project});

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
                              project.id == 'proj_pandits_near_me'
                                  ? 'FLAGSHIP ARCHITECTURAL CASE STUDY'
                                  : (project.hasCustomImage
                                        ? project.category.toUpperCase()
                                        : 'CLIENT PROJECTS'),
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
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
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

                    // Flagship Modular Architecture Flow
                    if (project.id == 'proj_pandits_near_me') ...[
                      _buildArchitecturePipeline(context, isDark),
                      const SizedBox(height: 24),
                    ],

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

  Widget _buildArchitecturePipeline(BuildContext context, bool isDark) {
    const steps = [
      (
        'Presentation',
        'GetX & CustomPainter',
        Icons.phone_iphone_rounded,
        Color(0xFF06B6D4),
      ),
      (
        'State & Logic',
        'Controllers & Workers',
        Icons.layers_rounded,
        Color(0xFF8B5CF6),
      ),
      (
        'Domain / Data',
        'Repositories & Models',
        Icons.inventory_2_outlined,
        Color(0xFF3B82F6),
      ),
      (
        'Networking',
        'Dio + Single-Flight',
        Icons.lock_clock_rounded,
        Color(0xFF10B981),
      ),
      (
        'Real-Time',
        'AWS IoT MQTT & FCM',
        Icons.cloud_sync_rounded,
        Color(0xFFF59E0B),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardHover.withOpacity(0.4)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.cyanPrimary.withOpacity(0.35)
              : AppColors.violetPrimary.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.hub_rounded,
                size: 18,
                color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Production Clean Architecture Pipeline',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.cyanLight : AppColors.cyanDark,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: steps[i].$4.withOpacity(0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: steps[i].$4.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(steps[i].$3, size: 13, color: steps[i].$4),
                            const SizedBox(width: 5),
                            Text(
                              steps[i].$1,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: steps[i].$4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          steps[i].$2,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: isDark ? Colors.white38 : Colors.black26,
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
