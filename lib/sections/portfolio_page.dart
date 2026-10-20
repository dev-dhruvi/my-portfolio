import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/portfolio_repository.dart';
import '../widgets/animations/ambient_background.dart';
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
/// navigation and dynamic/fallback data integration.
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    GlobalKey? targetKey;
    switch (sectionKey) {
      case 'hero':
        targetKey = _heroKey;
        break;
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
      Scrollable.ensureVisible(
        targetKey.currentContext!,
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
      body: AmbientBackground(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Fixed Navbar
                NavBar(
                  onNavItemSelected: _scrollToSection,
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                ),

                // Main Scrollable Portfolio Sections
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        // Hero Section
                        Container(
                          key: _heroKey,
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
                          child: ResponsiveContentContainer(
                            child: AboutSection(profile: profile),
                          ),
                        ),

                        // Skills Section
                        Container(
                          key: _skillsKey,
                          child: ResponsiveContentContainer(
                            child: SkillsSection(skills: skills),
                          ),
                        ),

                        // Experience Section
                        Container(
                          key: _experienceKey,
                          child: ResponsiveContentContainer(
                            child: ExperienceSection(experiences: experiences),
                          ),
                        ),

                        // Projects Section
                        Container(
                          key: _projectsKey,
                          child: ResponsiveContentContainer(
                            child: ProjectsSection(projects: projects),
                          ),
                        ),

                        // Education Section
                        Container(
                          key: _educationKey,
                          child: ResponsiveContentContainer(
                            child: EducationSection(education: education),
                          ),
                        ),

                        // Contact Section
                        Container(
                          key: _contactKey,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
