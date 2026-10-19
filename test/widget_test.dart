import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/admin/auth/admin_login_page.dart';
import 'package:dhruvi_portfolio/core/constants/app_constants.dart';
import 'package:dhruvi_portfolio/core/constants/seed_data.dart';
import 'package:dhruvi_portfolio/sections/hero/hero_section.dart';
import 'package:dhruvi_portfolio/sections/projects/projects_section.dart';
import 'package:dhruvi_portfolio/services/auth_service.dart';
import 'package:dhruvi_portfolio/widgets/cards/app_network_image.dart';
import 'package:dhruvi_portfolio/widgets/cards/glass_card.dart';
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
      'AdminLoginPage displays authentication fields and validates input',
      (tester) async {
        final authService = AuthService();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthService>.value(value: authService),
            ],
            child: const MaterialApp(home: AdminLoginPage()),
          ),
        );

        expect(find.text('Admin Authentication'), findsOneWidget);
        expect(find.text('Sign In to Admin Portal'), findsOneWidget);

        // Tap Sign In with empty fields to trigger validation
        await tester.tap(find.text('Sign In to Admin Portal'));
        await tester.pump();

        expect(find.text('Enter administrator email'), findsOneWidget);
      },
    );

    testWidgets('ProjectsSection renders PMP CSV Validator project card', (
      tester,
    ) async {
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

      expect(find.text('PMP CSV Validator'), findsAtLeastNWidgets(1));
    });
  });
}
