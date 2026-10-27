import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_breakpoints.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/url_launcher_util.dart';
import '../models/profile.dart';
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

    final scrollOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // 1. Detect active section for navigation pills and indicators
    String detectedSection = _activeSection;

    if (scrollOffset <= 60) {
      detectedSection = 'hero';
    } else if (scrollOffset >= maxScroll - 120) {
      detectedSection = 'contact';
    } else {
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
    }

    if (detectedSection != _activeSection) {
      setState(() {
        _activeSection = detectedSection;
      });
    }

    // 2. Trigger counter animation when the About section enters the active viewport range
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    if (_activeSection != sectionKey) {
      setState(() {
        _activeSection = sectionKey;
      });
    }

    if (sectionKey == 'hero') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
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
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // 1. Hero Section
                      Container(
                        key: _heroKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: HeroSection(
                            profile: profile,
                            onNavigate: _scrollToSection,
                          ),
                        ),
                      ),

                      // 2. Featured Projects Section (Promoted to Section 2 for maximum recruiter impact)
                      Container(
                        key: _projectsKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: ScrollVisibilityRevealer(
                            child: ProjectsSection(projects: projects),
                          ),
                        ),
                      ),

                      // 3. Experience & Achievements Section
                      Container(
                        key: _experienceKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: ScrollVisibilityRevealer(
                            child: ExperienceSection(experiences: experiences),
                          ),
                        ),
                      ),

                      // 4. Technical Skills Section
                      Container(
                        key: _skillsKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: ScrollVisibilityRevealer(
                            child: SkillsSection(skills: skills),
                          ),
                        ),
                      ),

                      // 5. About Me Section
                      Container(
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

                      // 6. Education Section
                      Container(
                        key: _educationKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: ScrollVisibilityRevealer(
                            child: EducationSection(education: education),
                          ),
                        ),
                      ),

                      // 7. Contact & Resume Section
                      Container(
                        key: _contactKey,
                        padding: const EdgeInsets.only(top: 88),
                        child: ResponsiveContentContainer(
                          child: ScrollVisibilityRevealer(
                            child: ContactSection(profile: profile),
                          ),
                        ),
                      ),

                      // Footer
                      // Repeated Call to Action Banner
                      ResponsiveContentContainer(
                        child: _buildRepeatedContactCta(context, profile),
                      ),

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

  Widget _buildRepeatedContactCta(BuildContext context, Profile profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppBreakpoints.isMobile(context);
    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 20 : 28),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 32,
        vertical: isMobile ? 22 : 28,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withOpacity(0.85),
                  const Color(0xFF0F172A).withOpacity(0.92),
                ]
              : [const Color(0xFFEEF2FF), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.violetPrimary.withOpacity(isDark ? 0.35 : 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.violetPrimary.withOpacity(isDark ? 0.12 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Ready to Build Scalable Mobile Experiences Together?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 19 : 24,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Whether you need a dedicated Flutter developer, architectural guidance, or help shipping production releases — let's connect.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12.5 : 14,
              color: secondaryTextColor,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => _scrollToSection('contact'),
                icon: const Icon(Icons.mail_outline_rounded, size: 16),
                label: const Text(
                  "Get in Touch",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.violetPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => UrlLauncherUtil.openResume(context: context),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text(
                  "Download Resume (PDF)",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
