import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/models/experience.dart';
import 'package:dhruvi_portfolio/repositories/admin_repository.dart';
import 'package:dhruvi_portfolio/repositories/portfolio_repository.dart';

void main() {
  group('Repository Tests', () {
    test(
      'PortfolioRepository provides verified seed data in fallback mode',
      () {
        final repo = PortfolioRepository();

        expect(repo.isUsingFallback, isTrue);
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
      },
    );

    test('AdminRepository manages CRUD operations and draft status', () async {
      final repo = AdminRepository();

      final initialCount = repo.totalExperiences;

      // Add new draft experience
      const draftExp = Experience(
        id: 'draft_1',
        role: 'Contract Lead',
        company: 'Remote Tech',
        location: 'Remote',
        startDate: 'Jan 2026',
        endDate: 'Present',
        isPublished: false,
      );

      await repo.saveExperience(draftExp);
      expect(repo.totalExperiences, equals(initialCount + 1));
      expect(repo.draftCount, greaterThanOrEqualTo(1));

      // Delete draft experience
      await repo.deleteExperience('draft_1');
      expect(repo.totalExperiences, equals(initialCount));
    });

    test('AdminRepository reorders projects', () async {
      final repo = AdminRepository();
      expect(repo.projects.length, greaterThanOrEqualTo(2));

      final firstProjectTitle = repo.projects[0].title;
      final secondProjectTitle = repo.projects[1].title;
      await repo.reorderProjects(0, 2);

      expect(repo.projects[0].title, equals(secondProjectTitle));
      expect(repo.projects[1].title, equals(firstProjectTitle));
    });
  });
}
