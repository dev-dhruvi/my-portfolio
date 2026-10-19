import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/seed_data.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/profile.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../services/firebase_service.dart';

/// Repository managing public portfolio data fetching and real-time streams.
class PortfolioRepository extends ChangeNotifier {
  final FirebaseService _firebaseService;

  Profile _profile = SeedData.initialProfile;
  List<Experience> _experiences = SeedData.initialExperiences;
  List<Project> _projects = SeedData.initialProjects;
  List<Skill> _skills = SeedData.initialSkills;
  List<Education> _education = SeedData.initialEducation;

  bool _isLoading = false;
  String? _error;
  bool _isUsingFallback = true;

  PortfolioRepository({FirebaseService? firebaseService})
    : _firebaseService = firebaseService ?? FirebaseService.instance {
    loadPortfolioData();
  }

  Profile get profile => _profile;
  List<Experience> get experiences =>
      _experiences.where((e) => e.isPublished).toList();
  List<Project> get projects => _projects.where((p) => p.isPublished).toList();
  List<Skill> get skills => _skills.where((s) => s.isPublished).toList();
  List<Education> get education =>
      _education.where((e) => e.isPublished).toList();

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUsingFallback => _isUsingFallback;

  /// Loads portfolio data from Firestore or fallback seed data.
  Future<void> loadPortfolioData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore == null) {
      _isUsingFallback = true;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // 1. Profile
      final profileDoc = await firestore
          .collection(AppConstants.colProfile)
          .doc('default')
          .get();
      if (profileDoc.exists && profileDoc.data() != null) {
        _profile = Profile.fromMap(profileDoc.data()!, id: profileDoc.id);
      }

      // 2. Experiences
      final expSnapshot = await firestore
          .collection(AppConstants.colExperiences)
          .where('isPublished', isEqualTo: true)
          .get();
      if (expSnapshot.docs.isNotEmpty) {
        _experiences =
            expSnapshot.docs
                .map((doc) => Experience.fromMap(doc.data(), id: doc.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 3. Projects
      final projSnapshot = await firestore
          .collection(AppConstants.colProjects)
          .where('isPublished', isEqualTo: true)
          .get();
      if (projSnapshot.docs.isNotEmpty) {
        _projects =
            projSnapshot.docs
                .map((doc) => Project.fromMap(doc.data(), id: doc.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 4. Skills
      final skillSnapshot = await firestore
          .collection(AppConstants.colSkills)
          .where('isPublished', isEqualTo: true)
          .get();
      if (skillSnapshot.docs.isNotEmpty) {
        _skills =
            skillSnapshot.docs
                .map((doc) => Skill.fromMap(doc.data(), id: doc.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 5. Education
      final eduSnapshot = await firestore
          .collection(AppConstants.colEducation)
          .where('isPublished', isEqualTo: true)
          .get();
      if (eduSnapshot.docs.isNotEmpty) {
        _education =
            eduSnapshot.docs
                .map((doc) => Education.fromMap(doc.data(), id: doc.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      _isUsingFallback = false;
    } catch (e) {
      _error = e.toString();
      _isUsingFallback = true;
      debugPrint(
        '[PortfolioRepository] Firestore fetch error: $e. Using verified seed data.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes data
  Future<void> refresh() => loadPortfolioData();
}
