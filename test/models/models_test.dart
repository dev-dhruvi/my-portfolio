import 'package:flutter_test/flutter_test.dart';
import 'package:dhruvi_portfolio/models/education.dart';
import 'package:dhruvi_portfolio/models/experience.dart';
import 'package:dhruvi_portfolio/models/profile.dart';
import 'package:dhruvi_portfolio/models/project.dart';
import 'package:dhruvi_portfolio/models/skill.dart';

void main() {
  group('Profile Model Tests', () {
    test('serialization and deserialization round-trip', () {
      const profile = Profile(
        id: 'test_id',
        name: 'Dhruvi Patel',
        headline: 'Sr. Flutter Developer',
        bio: 'Expert in mobile development',
        email: 'dhruvi39604@gmail.com',
        phone: '+91 9925589405',
        location: 'Surat, Gujarat, India',
        githubUrl: 'https://github.com/dhruvipatel',
        linkedinUrl: 'https://linkedin.com',
        resumeUrl: 'assets/docs/resume.pdf',
        yearsOfExperience: '4+',
        openToWork: true,
      );

      final map = profile.toMap();
      final reconstituted = Profile.fromMap(map);

      expect(reconstituted.id, equals(profile.id));
      expect(reconstituted.name, equals(profile.name));
      expect(reconstituted.email, equals(profile.email));
      expect(reconstituted.phone, equals(profile.phone));
      expect(reconstituted.location, equals(profile.location));
      expect(reconstituted.openToWork, isTrue);
    });

    test('copyWith works correctly', () {
      const profile = Profile(
        name: 'Dhruvi Patel',
        headline: 'Flutter Dev',
        bio: 'Bio',
        email: 'email@test.com',
        phone: '123',
        location: 'Surat',
      );

      final updated = profile.copyWith(headline: 'Lead Mobile Architect');
      expect(updated.headline, equals('Lead Mobile Architect'));
      expect(updated.name, equals('Dhruvi Patel'));
    });
  });

  group('Experience Model Tests', () {
    test('serialization round-trip', () {
      const exp = Experience(
        id: 'exp_1',
        role: 'Flutter Developer',
        company: 'DinJan Infotech Private Limited',
        location: 'Surat, India',
        startDate: 'June 2024',
        endDate: 'April 2025',
        isCurrent: false,
        responsibilities: ['UI development', 'API integration'],
        technologies: ['Flutter', 'Dart'],
        award: 'Code Craft Excellence Award (2025)',
        orderIndex: 1,
        isPublished: true,
      );

      final map = exp.toMap();
      final restored = Experience.fromMap(map);

      expect(restored.id, equals(exp.id));
      expect(restored.role, equals(exp.role));
      expect(restored.company, equals(exp.company));
      expect(restored.award, equals('Code Craft Excellence Award (2025)'));
      expect(restored.responsibilities.length, equals(2));
      expect(restored.technologies.length, equals(2));
      expect(restored.isPublished, isTrue);
    });
  });

  group('Project Model Tests', () {
    test('handles optional links and missing URLs cleanly', () {
      const proj = Project(
        id: 'p1',
        slug: 'the-healthi-indian',
        title: 'The Healthi Indian',
        shortDescription: 'Health & nutrition',
        fullDescription: 'Full recipe app description',
        category: 'Mobile App',
        technologies: ['Flutter', 'GetX'],
        playStoreUrl: '',
        appStoreUrl: '',
        isFeatured: true,
        isPublished: true,
      );

      expect(proj.playStoreUrl, isEmpty);
      expect(proj.appStoreUrl, isEmpty);
      expect(proj.githubUrl, isEmpty);
      expect(proj.isFeatured, isTrue);
      expect(proj.isPublished, isTrue);

      final map = proj.toMap();
      final restored = Project.fromMap(map);
      expect(restored.title, equals('The Healthi Indian'));
      expect(restored.category, equals('Mobile App'));
    });

    test('supports imageUrl, displayImageUrl, keyFeatures, and appleStoreUrl fallback', () {
      final mapWithApple = {
        'id': 'p2',
        'slug': 'test-proj',
        'title': 'Test Project',
        'shortDescription': 'Short',
        'fullDescription': 'Full',
        'category': 'Mobile App',
        'companyName': 'Test Company',
        'imageUrl': 'https://example.com/banner.png',
        'keyFeatures': ['Feature 1', 'Feature 2'],
        'appleStoreUrl': 'https://apps.apple.com/test',
        'playStoreUrl': 'https://play.google.com/test',
      };

      final project = Project.fromMap(mapWithApple);
      expect(project.companyName, equals('Test Company'));
      expect(project.imageUrl, equals('https://example.com/banner.png'));
      expect(project.displayImageUrl, equals('https://example.com/banner.png'));
      expect(project.keyFeatures, contains('Feature 1'));
      expect(project.appStoreUrl, equals('https://apps.apple.com/test'));

      // Test fallback to thumbnailUrl when imageUrl is empty
      final fallbackProj = project.copyWith(
        imageUrl: '',
        thumbnailUrl: 'https://example.com/thumb.png',
      );
      expect(
        fallbackProj.displayImageUrl,
        equals('https://example.com/thumb.png'),
      );
      expect(fallbackProj.hasCustomImage, isTrue);

      // Test fallback to defaultProjectImageUrl when both are empty
      final defaultProj = project.copyWith(imageUrl: '', thumbnailUrl: '');
      expect(
        defaultProj.displayImageUrl,
        equals(Project.defaultProjectImageUrl),
      );
      expect(
        defaultProj.displayImageUrl,
        equals('assets/images/project/default.webp'),
      );
      expect(defaultProj.hasCustomImage, isFalse);
    });

    test('supports is_status_active flag in serialization and parsing', () {
      final activeMap = {
        'id': 'p_active',
        'slug': 'active-proj',
        'title': 'Active Project',
        'shortDescription': 'Active',
        'fullDescription': 'Active Project Description',
        'category': 'Mobile App',
        'is_status_active': true,
      };
      final activeProject = Project.fromMap(activeMap);
      expect(activeProject.isStatusActive, isTrue);
      expect(activeProject.toMap()['is_status_active'], isTrue);

      final inactiveMap = {
        'id': 'p_inactive',
        'slug': 'inactive-proj',
        'title': 'Inactive Project',
        'shortDescription': 'Inactive',
        'fullDescription': 'Inactive Project Description',
        'category': 'Mobile App',
        'is_status_active': false,
      };
      final inactiveProject = Project.fromMap(inactiveMap);
      expect(inactiveProject.isStatusActive, isFalse);
      expect(inactiveProject.toMap()['is_status_active'], isFalse);
    });
  });

  group('Skill & Education Model Tests', () {
    test('Skill serialization', () {
      const skill = Skill(
        id: 'sk_flutter',
        name: 'Flutter',
        category: 'Mobile & Frameworks',
        isHighlighted: true,
      );

      final map = skill.toMap();
      final restored = Skill.fromMap(map);
      expect(restored.name, equals('Flutter'));
      expect(restored.isHighlighted, isTrue);
    });

    test('Education serialization', () {
      const edu = Education(
        id: 'edu_1',
        degree: 'MCA',
        institution: 'Sarvajanik College',
        location: 'Surat',
        startDate: 'Dec 2020',
        endDate: 'May 2022',
        cgpa: '7.61',
        honors: 'Distinction',
      );

      final map = edu.toMap();
      final restored = Education.fromMap(map);
      expect(restored.degree, equals('MCA'));
      expect(restored.cgpa, equals('7.61'));
    });
  });
}
