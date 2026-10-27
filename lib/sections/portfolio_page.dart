import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_breakpoints.dart';
import '../repositories/portfolio_repository.dart';
import '../widgets/animations/ambient_background.dart';
import '../widgets/animations/character_loader.dart';
import '../widgets/animations/scroll_visibility_revealer.dart';
import '../widgets/navigation/mobile_drawer.dart';
import '../widgets/navigation/nav_bar.dart';
import '../widgets/responsive/responsive_layout.dart';
import 'about/about_section.dart';
import 'contact/contact_section.dart';
import 'education/education_section.dart';
import 'experience/experience_section.dart';
import 'footer/footer_section.dart';
import 'hero/hero_section.dart';
import 'projects/projects_section.dart';
import 'skills/skills_section.dart';

/// Main public portfolio screen displaying all sections with smooth anchor
/// navigation, floating frosted glassmorphism navbar, and modern canvas styling.
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  int _aboutAnimationTrigger = 0;
  bool _isAboutInView = false;
  String _activeSection = 'hero';
  double _lastCheckedOffset = -1.0;
  bool _precacheDone = false;
  bool _isProgrammaticScrolling = false;
  Timer? _programmaticScrollTimer;
  // On web, the preloader in web/index.html seamlessly handles the initial Flutter
  // bootstrap state. Setting _showAppLoader to false eliminates the redundant 2.1-second
  // secondary delay, letting recruiters instantly view the Hero section.
  bool _showAppLoader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precacheDone) {
      _precacheDone = true;
      precacheImage(
        const AssetImage('assets/images/developer_character_3d.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/developer_character_business.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/developer_character_contact.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/developer_character_graduate.png'),
        context,
      );
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isProgrammaticScrolling) return;

    final scrollOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // Fast boundary checks without querying render boxes
    if (scrollOffset <= 60) {
      if (_activeSection != 'hero') {
        setState(() => _activeSection = 'hero');
      }
      return;
    } else if (scrollOffset >= maxScroll - 120) {
      if (_activeSection != 'contact') {
        setState(() => _activeSection = 'contact');
      }
      return;
    }

    // Throttle intermediate render box position checks to eliminate scroll jank
    if ((scrollOffset - _lastCheckedOffset).abs() < 14.0) return;
    _lastCheckedOffset = scrollOffset;

    // Evaluate sections from bottom to top to identify the currently active viewport section
    final sectionMap = <String, GlobalKey>{
      'contact': _contactKey,
      'education': _educationKey,
      'about': _aboutKey,
      'skills': _skillsKey,
      'experience': _experienceKey,
      'projects': _projectsKey,
      'hero': _heroKey,
    };

    const double activationThreshold = 140.0;
    String detectedSection = _activeSection;
    for (final entry in sectionMap.entries) {
      final ctx = entry.value.currentContext;
      if (ctx != null) {
        final renderBox = ctx.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final globalDy = renderBox.localToGlobal(Offset.zero).dy;
          if (globalDy <= activationThreshold) {
            detectedSection = entry.key;
            break;
          }
        }
      }
    }

    if (detectedSection != _activeSection) {
      setState(() {
        _activeSection = detectedSection;
      });
    }

    // Trigger counter animation when the About section enters the active viewport range
    final aboutContext = _aboutKey.currentContext;
    if (aboutContext != null) {
      final renderBox = aboutContext.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.sizeOf(context).height;
        final inView =
            position.dy < screenHeight * 0.75 &&
            (position.dy + renderBox.size.height) > screenHeight * 0.25;
        if (inView && !_isAboutInView) {
          _isAboutInView = true;
          setState(() {
            _aboutAnimationTrigger++;
          });
        } else if (!inView && _isAboutInView) {
          _isAboutInView = false;
        }
      }
    }
  }

  @override
  void dispose() {
    _programmaticScrollTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    _programmaticScrollTimer?.cancel();
    _isProgrammaticScrolling = true;

    if (_activeSection != sectionKey) {
      setState(() {
        _activeSection = sectionKey;
      });
    }

    if (sectionKey == 'hero') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
      _programmaticScrollTimer = Timer(const Duration(milliseconds: 650), () {
        if (mounted) {
          _isProgrammaticScrolling = false;
        }
      });
      return;
    }

    if (sectionKey == 'about') {
      _isAboutInView = true;
      setState(() {
        _aboutAnimationTrigger++;
      });
    }

    GlobalKey? targetKey;
    switch (sectionKey) {
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'skills':
        targetKey = _skillsKey;
        break;
      case 'experience':
        targetKey = _experienceKey;
        break;
      case 'projects':
        targetKey = _projectsKey;
        break;
      case 'education':
        targetKey = _educationKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      final targetContext = targetKey.currentContext!;
      final renderBox = targetContext.findRenderObject() as RenderBox?;
      if (renderBox != null && _scrollController.hasClients) {
        final position = _scrollController.position;
        final viewport = RenderAbstractViewport.of(renderBox);
        final revealedOffset = viewport
            .getOffsetToReveal(renderBox, 0.0)
            .offset;
        // Scroll directly to the section container's boundary. Each container provides
        // an internal 88px top inset so the floating navbar rests over the section's
        // own canvas with zero visual bleed or text leakage from the preceding section.
        // For 'contact', animate to maxScrollExtent so Contact and Footer fit the screen together flush.
        final targetOffset =
            (sectionKey == 'contact'
                    ? position.maxScrollExtent
                    : revealedOffset)
                .clamp(0.0, position.maxScrollExtent);
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
        _programmaticScrollTimer = Timer(const Duration(milliseconds: 650), () {
          if (mounted) {
            _isProgrammaticScrolling = false;
            if (_activeSection != sectionKey) {
              setState(() {
                _activeSection = sectionKey;
              });
            }
          }
        });
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
      _programmaticScrollTimer = Timer(const Duration(milliseconds: 650), () {
        if (mounted) {
          _isProgrammaticScrolling = false;
        }
      });
    } else {
      _isProgrammaticScrolling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolioRepo = context.watch<PortfolioRepository>();
    final profile = portfolioRepo.profile;
    final experiences = portfolioRepo.experiences;
    final projects = portfolioRepo.projects;
    final skills = portfolioRepo.skills;
    final education = portfolioRepo.education;
    final isMobile = AppBreakpoints.isMobile(context);
    final viewportHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: MobileDrawer(
        onNavItemSelected: _scrollToSection,
        activeSection: _activeSection,
      ),
      body: Stack(
        children: [
          // Main Scrollable Portfolio Sections & Canvas
          AmbientBackground(
            child: Stack(
              children: [
                // Main Scrollable Portfolio Sections
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 1. Hero Section
                      RepaintBoundary(
                        child: Container(
                          key: _heroKey,
                          padding: const EdgeInsets.only(top: 88),
                          child: ResponsiveContentContainer(
                            child: HeroSection(
                              profile: profile,
                              onNavigate: _scrollToSection,
                            ),
                          ),
                        ),
                      ),

                      // 2. Featured Projects Section (Promoted to Section 2 for maximum recruiter impact)
                      RepaintBoundary(
                        child: Container(
                          key: _projectsKey,
                          padding: const EdgeInsets.only(top: 88),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: ProjectsSection(projects: projects),
                            ),
                          ),
                        ),
                      ),

                      // 3. Experience & Achievements Section
                      RepaintBoundary(
                        child: Container(
                          key: _experienceKey,
                          padding: const EdgeInsets.only(top: 88),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: ExperienceSection(
                                experiences: experiences,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 4. Technical Skills Section
                      RepaintBoundary(
                        child: Container(
                          key: _skillsKey,
                          padding: const EdgeInsets.only(top: 88),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: SkillsSection(skills: skills),
                            ),
                          ),
                        ),
                      ),

                      // 5. About Me Section
                      RepaintBoundary(
                        child: Container(
                          key: _aboutKey,
                          padding: const EdgeInsets.only(top: 88),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: AboutSection(
                                profile: profile,
                                animationTrigger: _aboutAnimationTrigger,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 6. Education Section
                      RepaintBoundary(
                        child: Container(
                          key: _educationKey,
                          padding: const EdgeInsets.only(top: 88),
                          alignment: Alignment.topCenter,
                          constraints: BoxConstraints(
                            minHeight: isMobile ? 0 : viewportHeight,
                          ),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: EducationSection(education: education),
                            ),
                          ),
                        ),
                      ),

                      // 7. Contact Section
                      RepaintBoundary(
                        child: Container(
                          key: _contactKey,
                          padding: const EdgeInsets.only(top: 88),
                          alignment: Alignment.topCenter,
                          constraints: BoxConstraints(
                            minHeight: isMobile
                                ? 0
                                : (viewportHeight - 69.0).clamp(
                                    0.0,
                                    double.infinity,
                                  ),
                          ),
                          child: ResponsiveContentContainer(
                            child: ScrollVisibilityRevealer(
                              child: ContactSection(profile: profile),
                            ),
                          ),
                        ),
                      ),

                      // Footer Section
                      RepaintBoundary(
                        child: FooterSection(
                          profile: profile,
                          onNavigate: _scrollToSection,
                        ),
                      ),
                    ],
                  ),
                ),

                // Top Floating Frosted Glassmorphic Navbar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: NavBar(
                      activeSection: _activeSection,
                      onNavItemSelected: _scrollToSection,
                      onOpenDrawer: () =>
                          _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3D Illustrator Animated Startup Loader (App & Web)
          if (_showAppLoader)
            Positioned.fill(
              child: CharacterLoader(
                onFinished: () {
                  if (mounted) {
                    setState(() {
                      _showAppLoader = false;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
