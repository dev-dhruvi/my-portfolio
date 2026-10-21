import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/repositories/portfolio_repository.dart';

void main() {
  group('Repository Tests', () {
    test('PortfolioRepository provides verified seed data', () {
      final repo = PortfolioRepository();

      expect(repo.profile.name, equals('Dhruvi Patel'));
      expect(repo.experiences.isNotEmpty, isTrue);
      expect(repo.projects.isNotEmpty, isTrue);
      expect(repo.skills.isNotEmpty, isTrue);
      expect(repo.education.isNotEmpty, isTrue);

      // Verify only published items are exposed to public visitors
      for (final exp in repo.experiences) {
        expect(exp.isPublished, isTrue);
      }
      for (final proj in repo.projects) {
        expect(proj.isPublished, isTrue);
      }

      // Verify Logix Built Solutions Limited award
      final logixExp = repo.experiences.firstWhere(
        (e) => e.company.contains('Logix Built Solutions Limited'),
      );
      expect(logixExp.award, contains('Code Craft Excellence Award'));

      // Verify Pandits Near Me - Instant Puja project
      final panditsProject = repo.projects.firstWhere(
        (p) => p.title.contains('Pandit'),
      );
      expect(panditsProject.category, equals('On-Demand Marketplace'));
      expect(
        panditsProject.companyName,
        equals('Logix Built Solutions Limited'),
      );
      expect(panditsProject.technologies, contains('AWS IoT Core (MQTT)'));
      expect(panditsProject.technologies, contains('Dio'));
      expect(panditsProject.technologies, contains('Mocktail'));
      expect(
        panditsProject.personalContribution,
        contains('AWS IoT Core and MQTT'),
      );
      expect(panditsProject.personalContribution, contains('CustomPainter'));

      // Verify newly added projects exist
      expect(repo.projects.any((p) => p.title == 'PMP Exam Prep App'), isTrue);
      expect(repo.projects.any((p) => p.title == 'Nirvana App'), isTrue);
      expect(repo.projects.any((p) => p.title == 'Reutbyitforme App'), isTrue);
      expect(repo.projects.any((p) => p.title == 'Milos Paddle App'), isTrue);
      expect(repo.projects.any((p) => p.title == 'Minder App'), isTrue);
      expect(
        repo.projects.any((p) => p.title == 'AI-Assisted UI-to-Code Research'),
        isTrue,
      );

      // Verify PMP CSV Validator project
      final pmpProject = repo.projects.firstWhere(
        (p) => p.title.contains('PMP CSV Validator'),
      );
      expect(pmpProject.category, equals('Flutter Web'));
      expect(pmpProject.technologies, contains('Flutter Web'));
      expect(pmpProject.technologies, contains('CSV Parsing'));
      expect(pmpProject.technologies, contains('flutter_math_fork'));
      expect(
        pmpProject.personalContribution,
        contains('responsive CSV validation tool'),
      );
      expect(
        pmpProject.personalContribution,
        contains('TRAIN/FLIP card previews'),
      );

      // Verify enriched project features and URLs
      final healthiProject = repo.projects.firstWhere(
        (p) => p.slug == 'the-healthi-indian',
      );
      expect(healthiProject.companyName, equals('Dinjan Infotech'));
      expect(healthiProject.keyFeatures.isNotEmpty, isTrue);
      expect(healthiProject.imageUrl.isNotEmpty, isTrue);
      expect(healthiProject.playStoreUrl.isNotEmpty, isTrue);
      expect(healthiProject.appStoreUrl.isNotEmpty, isTrue);

      // Verify updated profile URLs
      expect(
        repo.profile.githubUrl,
        equals('https://github.com/dhruvi-mobiledev'),
      );
      expect(
        repo.profile.linkedinUrl,
        equals('https://www.linkedin.com/in/duvi03'),
      );
      expect(repo.profile.headline, equals('Senior Flutter Developer'));
    });
  });
}
