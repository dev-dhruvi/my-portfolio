import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/core/constants/app_constants.dart';
import 'package:dhruvi_portfolio/core/constants/seed_data.dart';
import 'package:dhruvi_portfolio/sections/hero/hero_section.dart';
import 'package:dhruvi_portfolio/sections/projects/projects_section.dart';
import 'package:dhruvi_portfolio/core/theme/app_theme.dart';
import 'package:dhruvi_portfolio/widgets/cards/app_network_image.dart';
import 'package:dhruvi_portfolio/widgets/cards/glass_card.dart';
import 'package:dhruvi_portfolio/widgets/navigation/nav_bar.dart';
import 'package:provider/provider.dart';

void main() {
  group('UI Widget Tests', () {
    testWidgets('HeroSection displays developer name and action buttons', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: HeroSection(profile: SeedData.initialProfile)),
        ),
      );

      // Verify developer name and headline
      expect(find.text('Dhruvi Patel'), findsOneWidget);
      expect(find.text(AppConstants.fullRoleHeadline), findsOneWidget);
      expect(find.text('View Projects'), findsOneWidget);
      expect(find.text('Download Resume'), findsOneWidget);
      expect(find.text('Contact Me'), findsOneWidget);
    });

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
      'ProjectsSection renders Pandit Near Me and PMP CSV Validator & Preview Tool project cards',
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

        expect(find.text('Pandit Near Me'), findsAtLeastNWidgets(1));
        expect(
          find.text('PMP CSV Validator & Preview Tool'),
          findsAtLeastNWidgets(1),
        );
      },
    );

    testWidgets(
      'NavBar renders cleanly across desktop (1280px), tablet (954px), and mobile (375px)',
      (tester) async {
        final themeController = ThemeController();

        Widget buildNavBarWithWidth(double width) {
          return MediaQuery(
            data: MediaQueryData(
              size: Size(width, 800),
              disableAnimations: true,
            ),
            child: ChangeNotifierProvider<ThemeController>.value(
              value: themeController,
              child: const MaterialApp(home: Scaffold(appBar: NavBar())),
            ),
          );
        }

        // Test Desktop (1280px)
        await tester.binding.setSurfaceSize(const Size(1280, 800));
        await tester.pumpWidget(buildNavBarWithWidth(1280));
        await tester.pump();
        expect(find.text('Dhruvi Patel'), findsOneWidget);
        expect(find.text('Projects'), findsOneWidget);
        expect(find.text('Resume'), findsOneWidget);

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
  });
}
