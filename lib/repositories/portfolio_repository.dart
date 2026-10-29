import 'package:flutter/foundation.dart';

import '../core/constants/seed_data.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/profile.dart';
import '../models/project.dart';
import '../models/skill.dart';

/// Repository providing verified portfolio data for Dhruvi Patel's portfolio.
class PortfolioRepository extends ChangeNotifier {
  Profile _profile = SeedData.initialProfile;
  List<Experience> _experiences = SeedData.initialExperiences;
  List<Project> _projects = SeedData.initialProjects;
  List<Skill> _skills = SeedData.initialSkills;
  List<Education> _education = SeedData.initialEducation;

  PortfolioRepository() {
    loadPortfolioData();
  }

  Profile get profile => _profile;
  List<Experience> get experiences =>
      _experiences.where((e) => e.isPublished).toList();
  List<Project> get projects =>
      _projects.where((p) => p.isPublished && p.isStatusActive).toList();
  List<Skill> get skills => _skills.where((s) => s.isPublished).toList();
  List<Education> get education =>
      _education.where((e) => e.isPublished).toList();

  bool get isLoading => false;
  String? get error => null;

  Project? getProjectBySlug(String slug) {
    final normalized = slug.trim().toLowerCase();
    try {
      return _projects.firstWhere(
        (p) =>
            p.slug.toLowerCase() == normalized ||
            p.id.toLowerCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  void loadPortfolioData() {
    _profile = SeedData.initialProfile;
    _experiences = SeedData.initialExperiences;
    _projects = SeedData.initialProjects;
    _skills = SeedData.initialSkills;
    _education = SeedData.initialEducation;
    notifyListeners();
  }

  Future<void> refresh() async {
    loadPortfolioData();
  }
}
