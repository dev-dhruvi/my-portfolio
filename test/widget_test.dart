import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/core/constants/app_constants.dart';
import 'package:dhruvi_portfolio/core/constants/seed_data.dart';
import 'package:dhruvi_portfolio/models/project.dart';
import 'package:dhruvi_portfolio/sections/hero/hero_section.dart';
import 'package:dhruvi_portfolio/sections/about/about_section.dart';
import 'package:dhruvi_portfolio/sections/education/education_section.dart';
import 'package:dhruvi_portfolio/sections/contact/contact_section.dart';
import 'package:dhruvi_portfolio/sections/projects/projects_section.dart';
import 'package:dhruvi_portfolio/sections/projects/all_projects_page.dart';
import 'package:dhruvi_portfolio/sections/experience/experience_section.dart';
import 'package:dhruvi_portfolio/sections/skills/skills_section.dart';
import 'package:dhruvi_portfolio/widgets/animations/character_loader.dart';
import 'package:dhruvi_portfolio/core/theme/app_theme.dart';
import 'package:dhruvi_portfolio/widgets/cards/app_network_image.dart';
import 'package:dhruvi_portfolio/widgets/cards/glass_card.dart';
import 'package:dhruvi_portfolio/widgets/navigation/nav_bar.dart';
import 'package:dhruvi_portfolio/widgets/navigation/mobile_drawer.dart';
import 'package:dhruvi_portfolio/widgets/navigation/dynamic_scroll_indicators.dart';
import 'package:dhruvi_portfolio/sections/footer/footer_section.dart';
import 'package:provider/provider.dart';

void main() {
  group('UI Widget Tests', () {
    testWidgets(
      'HeroSection displays developer name, status badge, location, and Download CV action button',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: HeroSection(profile: SeedData.initialProfile),
              ),
            ),
          ),
        );

        // Verify developer name, status badge, location, and updated action buttons
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(
          find.text('Available for Senior Flutter Developer Roles'),
          findsOneWidget,
        );
        expect(find.text('View My Projects'), findsOneWidget);
        expect(find.byIcon(Icons.rocket_launch_rounded), findsOneWidget);
        expect(find.text('Download CV'), findsOneWidget);
        expect(find.byIcon(Icons.description_outlined), findsOneWidget);
        expect(find.text('Contact Me'), findsNothing);
        expect(find.text(AppConstants.location), findsOneWidget);
      },
    );

    testWidgets('AppNetworkImage shows fallback when URL is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(imageUrl: '', placeholderText: 'Radio Spice'),
          ),
        ),
      );

      expect(find.text('Radio Spice'), findsOneWidget);
      expect(find.byIcon(Icons.folder_special_outlined), findsOneWidget);
    });

    testWidgets('GlassCard renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(child: Text('Test GlassCard Content')),
          ),
        ),
      );

      expect(find.text('Test GlassCard Content'), findsOneWidget);
    });

    testWidgets(
      'ProjectsSection renders Pandits Near Me - Instant Puja and PMP CSV Validator project cards',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ProjectsSection(projects: SeedData.initialProjects),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.text('Pandits Near Me - Instant Puja'),
          findsAtLeastNWidgets(1),
        );
        expect(find.text('PMP CSV Validator'), findsAtLeastNWidgets(1));

        // Advance to page 1 on desktop slider (4 cards/page)
        final dots = find.descendant(
          of: find.byType(DynamicScrollIndicators),
          matching: find.byType(InkWell),
        );
        if (dots.evaluate().length > 1) {
          await tester.tap(dots.at(1));
          await tester.pumpAndSettle();
        } else {
          final nextButton = find.byTooltip('Next page');
          if (nextButton.evaluate().isNotEmpty) {
            await tester.tap(nextButton.first);
            await tester.pumpAndSettle();
          }
        }
        expect(find.text('Reut, buy me'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets(
      'ProjectsSection renders Featured badge when custom image exists and Client Projects badge when image is absent',
      (tester) async {
        final sampleProjects = [
          const Project(
            id: 'proj_with_img',
            slug: 'proj-with-img',
            title: 'Project With Image',
            shortDescription: 'Short desc',
            fullDescription: 'Full desc',
            category: 'Mobile App',
            imageUrl: 'https://example.com/project.png',
          ),
          const Project(
            id: 'proj_without_img',
            slug: 'proj-without-img',
            title: 'Project Without Image',
            shortDescription: 'Short desc',
            fullDescription: 'Full desc',
            category: 'Client Work',
            imageUrl: '',
            thumbnailUrl: '',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ProjectsSection(projects: sampleProjects),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Featured'), findsOneWidget);
        expect(find.text('Client Projects'), findsOneWidget);
      },
    );

    testWidgets(
      'ProjectsSection indicator dots navigate without lifecycle errors',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ProjectsSection(projects: SeedData.initialProjects),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        final dots = find.descendant(
          of: find.byType(DynamicScrollIndicators),
          matching: find.byType(InkWell),
        );
        if (dots.evaluate().length > 1) {
          await tester.tap(dots.at(1));
          await tester.pumpAndSettle();
          await tester.tap(dots.first);
          await tester.pumpAndSettle();
        }
      },
    );

    testWidgets(
      'NavBar renders cleanly across desktop (1280px), tablet (954px), and mobile (375px)',
      (tester) async {
        final themeController = ThemeController();

        Widget buildNavBarWithWidth(double width) {
          return ChangeNotifierProvider<ThemeController>.value(
            value: themeController,
            child: MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(width, 800),
                  disableAnimations: true,
                ),
                child: const Scaffold(appBar: NavBar()),
              ),
            ),
          );
        }

        // Test Desktop (1280px)
        await tester.binding.setSurfaceSize(const Size(1280, 800));
        await tester.pumpWidget(buildNavBarWithWidth(1280));
        await tester.pump();
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.text('Projects'), findsOneWidget);
        expect(find.text('Contact'), findsOneWidget);
        expect(find.byIcon(Icons.phone_in_talk_rounded), findsNothing);

        // Test Tablet (954px - exact reported overflow width)
        await tester.binding.setSurfaceSize(const Size(954, 800));
        await tester.pumpWidget(buildNavBarWithWidth(954));
        await tester.pump();
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

        // Test Mobile (375px)
        await tester.binding.setSurfaceSize(const Size(375, 800));
        await tester.pumpWidget(buildNavBarWithWidth(375));
        await tester.pump();
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

        // Reset surface size
        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets(
      'AboutSection renders narrative cards, metric cards with counters, and business character',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: AboutSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('ABOUT ME'), findsOneWidget);
        expect(find.text('Professional Background'), findsOneWidget);
        expect(
          find.text('Engineering Philosophy & Craftsmanship'),
          findsOneWidget,
        );
        expect(find.text('Code Craft Excellence Award (2025)'), findsOneWidget);
        expect(find.text('Clean Architecture Specialist'), findsOneWidget);
        expect(find.text('4+ Years'), findsOneWidget);
        expect(find.text('350+ Releases'), findsOneWidget);
        expect(find.text('20+ Projects'), findsOneWidget);
        expect(find.text('MCA & BCA'), findsOneWidget);
      },
    );

    testWidgets(
      'EducationSection renders degrees and graduate anime character stage',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: EducationSection(education: SeedData.initialEducation),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('ACADEMIC FOUNDATION'), findsOneWidget);
        expect(find.text('Education & Qualifications'), findsOneWidget);
        expect(
          find.text('Master of Computer Applications (MCA)'),
          findsOneWidget,
        );
        expect(
          find.text('Bachelor of Computer Applications (BCA)'),
          findsOneWidget,
        );
        expect(find.text('Distinction Honors (MCA & BCA)'), findsOneWidget);
      },
    );

    testWidgets(
      'ContactSection renders contact channels, ready to build banner, and contact anime character stage',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ContactSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('GET IN TOUCH'), findsOneWidget);
        expect(
          find.text('Ready to Build Scalable Mobile Experiences Together?'),
          findsOneWidget,
        );
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('WhatsApp'), findsOneWidget);
        expect(find.text('LinkedIn'), findsOneWidget);
        expect(find.text('GitHub'), findsOneWidget);
        expect(find.text('Available for new opportunities'), findsOneWidget);
        expect(find.text('Usually replies within a day'), findsOneWidget);
        expect(find.text("Let's Connect"), findsOneWidget);
      },
    );

    testWidgets(
      'ExperienceSection renders all 4 experiences in 2x2 desktop grid layout',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ExperienceSection(
                    experiences: SeedData.initialExperiences,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify section header and all 4 company roles are rendered
        expect(find.text('CAREER PATH'), findsOneWidget);
        expect(find.text('Work Experience & Roles'), findsOneWidget);
        expect(find.text('Logix Built Solutions Limited'), findsOneWidget);
        expect(find.text('Dinjan Infotech'), findsOneWidget);
        expect(find.textContaining('Mobile App Developer'), findsOneWidget);
        expect(find.textContaining('Android Developer'), findsOneWidget);
      },
    );

    testWidgets(
      'CharacterLoader renders 3D character branding, badge, and progress indicators',
      (tester) async {
        bool finished = false;
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: false,
              ),
              child: Scaffold(
                body: CharacterLoader(
                  duration: const Duration(milliseconds: 1000),
                  onFinished: () => finished = true,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify branding and character specialist badges are visible
        expect(
          find.text('Dhruvi Patel • Senior Flutter Developer'),
          findsOneWidget,
        );
        expect(find.text('Flutter & Dart Specialist'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);

        // Fast-forward past duration to trigger finish callback
        await tester.pump(const Duration(milliseconds: 1100));
        await tester.pump(const Duration(milliseconds: 500));
        expect(finished, isTrue);
      },
    );

    testWidgets(
      'DynamicScrollIndicators renders without overflow across narrow constraints (288px, 368px)',
      (tester) async {
        for (final width in [288.0, 368.0, 240.0]) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: width,
                    child: DynamicScrollIndicators(
                      pageCount: 17,
                      activeIndex: 3,
                      onDotTapped: (_) {},
                      onPrevious: () {},
                      onNext: () {},
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets(
      'FooterSection renders without overflow on narrow constraints (280px, 368px)',
      (tester) async {
        for (final width in [280.0, 320.0, 368.0]) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: width,
                    child: FooterSection(profile: SeedData.initialProfile),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets(
      'HeroSection status badge and header render without overflow on narrow 320px screen',
      (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 800),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: HeroSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AboutSection Key Highlights renders 2x2 grid with equal height cards on mobile',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(375, 812),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: AboutSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Key Highlights'), findsOneWidget);
        expect(find.text('Hands-on Experience'), findsOneWidget);
        expect(find.text('Play Store & App Store'), findsOneWidget);
        expect(find.text('Built & Deployed'), findsOneWidget);
        expect(find.text('GTU & VNSGU Distinction'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AllProjectsPage renders header, project directory, and back button cleanly on desktop',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 800),
                disableAnimations: true,
              ),
              child: AllProjectsPage(projects: SeedData.initialProjects),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('All Projects'), findsOneWidget);
        expect(find.text('PROJECT DIRECTORY'), findsOneWidget);
        expect(
          find.text('Pandits Near Me - Instant Puja'),
          findsAtLeastNWidgets(1),
        );
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.text('Previous'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AllProjectsPage renders vertical listview with scroll pagination on mobile without previous/next buttons',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(375, 812),
                disableAnimations: true,
              ),
              child: AllProjectsPage(projects: SeedData.initialProjects),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('All Projects'), findsOneWidget);
        expect(find.text('PROJECT DIRECTORY'), findsOneWidget);
        expect(
          find.text('Pandits Near Me - Instant Puja'),
          findsAtLeastNWidgets(1),
        );
        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Previous'), findsNothing);
        expect(find.text('Next'), findsNothing);
        expect(find.text('Load More'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'SkillsSection renders grouped-chip tech stack across desktop, tablet, and mobile',
      (tester) async {
        // Desktop test (1440px)
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1440, 900),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: SkillsSection(skills: SeedData.initialSkills),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('MY TECH STACK'), findsOneWidget);
        expect(find.text('Technologies'), findsOneWidget);
        expect(find.text('Mobile Development'), findsOneWidget);
        expect(find.text('State Management'), findsOneWidget);
        expect(find.text('Backend & Data'), findsOneWidget);
        expect(find.text('Engineering'), findsOneWidget);
        expect(find.text('Tools'), findsOneWidget);
        expect(find.text('Flutter'), findsOneWidget);
        expect(find.text('Dart'), findsOneWidget);
        expect(find.text('Firebase'), findsOneWidget);
        expect(find.text('Clean Architecture'), findsOneWidget);

        // Mobile test (375px)
        tester.view.physicalSize = const Size(375, 812);
        addTearDown(() => tester.view.resetPhysicalSize());
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(375, 812),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: SkillsSection(skills: SeedData.initialSkills),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('MY TECH STACK'), findsOneWidget);
        expect(find.text('Mobile Development'), findsOneWidget);
        expect(find.text('Flutter'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'MobileDrawer opens, displays nav items, and tapping item closes drawer safely without route errors',
      (tester) async {
        String? selectedSection;
        final themeController = ThemeController();

        await tester.pumpWidget(
          ChangeNotifierProvider<ThemeController>.value(
            value: themeController,
            child: MaterialApp(
              home: Scaffold(
                drawer: MobileDrawer(
                  onNavItemSelected: (key) => selectedSection = key,
                ),
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: const Text('Open'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Open the drawer
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Verify items exist
        expect(find.text('Experience'), findsOneWidget);
        expect(find.text('Projects'), findsOneWidget);

        // Tap Experience item
        await tester.tap(find.text('Experience'));
        await tester.pumpAndSettle();

        // Verify callback was invoked and no exception was thrown
        expect(selectedSection, equals('experience'));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'NavBar displays activeSection state and Contact pill on desktop',
      (tester) async {
        final themeController = ThemeController();
        String? navigatedSection;

        await tester.binding.setSurfaceSize(const Size(1280, 800));
        await tester.pumpWidget(
          ChangeNotifierProvider<ThemeController>.value(
            value: themeController,
            child: MaterialApp(
              home: MediaQuery(
                data: const MediaQueryData(
                  size: Size(1280, 800),
                  disableAnimations: true,
                ),
                child: Scaffold(
                  appBar: NavBar(
                    activeSection: 'contact',
                    onNavItemSelected: (key) => navigatedSection = key,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify Contact pill exists on desktop
        expect(find.text('Contact'), findsOneWidget);

        // Tap Contact pill
        await tester.tap(find.text('Contact'));
        await tester.pump();
        expect(navigatedSection, equals('contact'));

        // Verify phone icon is removed beside theme
        expect(find.byIcon(Icons.phone_in_talk_rounded), findsNothing);
        expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets(
      'HeroSection renders cleanly without overflow on laptop viewports (1366x768 and 1280x720)',
      (tester) async {
        // Standard laptop resolution (1366x768)
        await tester.binding.setSurfaceSize(const Size(1366, 768));
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1366, 768),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: HeroSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.text('View My Projects'), findsOneWidget);
        expect(find.text('Download CV'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Compact laptop resolution (1280x720)
        await tester.binding.setSurfaceSize(const Size(1280, 720));
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(1280, 720),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: HeroSection(profile: SeedData.initialProfile),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.text('View My Projects'), findsOneWidget);
        expect(find.text('Download CV'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
