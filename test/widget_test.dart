import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/core/constants/app_constants.dart';
import 'package:dhruvi_portfolio/core/constants/seed_data.dart';
import 'package:dhruvi_portfolio/sections/hero/hero_section.dart';
import 'package:dhruvi_portfolio/sections/about/about_section.dart';
import 'package:dhruvi_portfolio/sections/education/education_section.dart';
import 'package:dhruvi_portfolio/sections/contact/contact_section.dart';
import 'package:dhruvi_portfolio/sections/projects/projects_section.dart';
import 'package:dhruvi_portfolio/sections/experience/experience_section.dart';
import 'package:dhruvi_portfolio/widgets/animations/character_loader.dart';
import 'package:dhruvi_portfolio/core/theme/app_theme.dart';
import 'package:dhruvi_portfolio/widgets/cards/app_network_image.dart';
import 'package:dhruvi_portfolio/widgets/cards/glass_card.dart';
import 'package:dhruvi_portfolio/widgets/navigation/nav_bar.dart';
import 'package:provider/provider.dart';

void main() {
  group('UI Widget Tests', () {
    testWidgets(
      'HeroSection displays developer name, role, status badge, and Download CV action button',
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

        // Verify developer name, role, updated status badge, location, and action button
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.text(AppConstants.animatedRoles[0]), findsOneWidget);
        expect(
          find.text('Available for Senior Flutter Developer Roles'),
          findsOneWidget,
        );
        expect(find.text('Download CV'), findsOneWidget);
        expect(find.byIcon(Icons.download_rounded), findsOneWidget);
        expect(find.text('View Projects'), findsOneWidget);
        expect(find.byIcon(Icons.rocket_launch_outlined), findsOneWidget);
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
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              home: Scaffold(
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
        expect(find.byIcon(Icons.phone_in_talk_rounded), findsOneWidget);

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
        expect(find.text('50+ Releases'), findsOneWidget);
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
      'ContactSection renders contact info, form, and contact anime character stage',
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
        expect(find.text('Quick Response Guaranteed'), findsOneWidget);
        expect(find.text('Direct Message'), findsOneWidget);
        expect(find.text('Send Message via Email'), findsOneWidget);
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
        expect(find.text('Mobile App Developer'), findsOneWidget);
        expect(find.text('Intern, Android Developer'), findsOneWidget);
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
  });
}
