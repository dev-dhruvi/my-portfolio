import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../repositories/portfolio_repository.dart';
import '../widgets/animations/ambient_background.dart';
import '../widgets/animations/character_loader.dart';
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
  // On web, the preloader in web/index.html seamlessly handles the initial Flutter
  // bootstrap state. Setting _showAppLoader to false eliminates the redundant 2.1-second
  // secondary delay, letting recruiters instantly view the Hero section.
  bool _showAppLoader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final aboutContext = _aboutKey.currentContext;
    if (aboutContext != null) {
      final renderBox = aboutContext.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.sizeOf(context).height;
        // Trigger counter animation when the About section enters the active viewport range
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    if (sectionKey == 'hero') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    if (sectionKey == 'contact') {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
        return;
      }
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
        // an internal 92px top inset so the floating navbar rests over the section's
        // own canvas with zero visual bleed or text leakage from the preceding section.
        final targetOffset = revealedOffset.clamp(
          0.0,
          position.maxScrollExtent,
        );
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: MobileDrawer(onNavItemSelected: _scrollToSection),
      body: Stack(
        children: [
          // Main Scrollable Portfolio Sections & Canvas
          AmbientBackground(
            child: Stack(
              children: [
                // Main Scrollable Portfolio Sections
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Hero Section
                      Container(
                        key: _heroKey,
                        padding: const EdgeInsets.only(top: 92),
                        child: ResponsiveContentContainer(
                          child: HeroSection(
                            profile: profile,
                            onNavigate: _scrollToSection,
                          ),
                        ),
                      ),

                      // About Section
                      Container(
                        key: _aboutKey,
                        padding: const EdgeInsets.only(top: 80),
                        child: ResponsiveContentContainer(
                          child: AboutSection(
                            profile: profile,
                            animationTrigger: _aboutAnimationTrigger,
                          ),
                        ),
                      ),

                      // Skills Section
                      Container(
                        key: _skillsKey,
                        padding: const EdgeInsets.only(top: 75),
                        child: ResponsiveContentContainer(
                          child: SkillsSection(skills: skills),
                        ),
                      ),

                      // Experience Section
                      Container(
                        key: _experienceKey,
                        padding: const EdgeInsets.only(top: 75),
                        child: ResponsiveContentContainer(
                          child: ExperienceSection(experiences: experiences),
                        ),
                      ),

                      // Projects Section
                      Container(
                        key: _projectsKey,
                        padding: const EdgeInsets.only(top: 75),
                        child: ResponsiveContentContainer(
                          child: ProjectsSection(projects: projects),
                        ),
                      ),

                      // Education Section
                      Container(
                        key: _educationKey,
                        padding: const EdgeInsets.only(top: 75),
                        child: ResponsiveContentContainer(
                          child: EducationSection(education: education),
                        ),
                      ),

                      // Contact Section
                      Container(
                        key: _contactKey,
                        padding: const EdgeInsets.only(top: 40),
                        child: ResponsiveContentContainer(
                          child: ContactSection(profile: profile),
                        ),
                      ),

                      // Footer
                      FooterSection(
                        profile: profile,
                        onNavigate: _scrollToSection,
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
