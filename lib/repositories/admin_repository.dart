import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/seed_data.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/profile.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../services/firebase_service.dart';

/// Repository for Administrator CRUD operations across all portfolio entities.
class AdminRepository extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final Uuid _uuid = const Uuid();

  Profile _profile = SeedData.initialProfile;
  List<Experience> _experiences = List.from(SeedData.initialExperiences);
  List<Project> _projects = List.from(SeedData.initialProjects);
  List<Skill> _skills = List.from(SeedData.initialSkills);
  List<Education> _education = List.from(SeedData.initialEducation);

  bool _isLoading = false;
  String? _errorMessage;

  AdminRepository({FirebaseService? firebaseService})
    : _firebaseService = firebaseService ?? FirebaseService.instance {
    loadAllAdminData();
  }

  Profile get profile => _profile;
  List<Experience> get experiences => List.unmodifiable(_experiences);
  List<Project> get projects => List.unmodifiable(_projects);
  List<Skill> get skills => List.unmodifiable(_skills);
  List<Education> get education => List.unmodifiable(_education);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Total metrics
  int get totalExperiences => _experiences.length;
  int get totalProjects => _projects.length;
  int get totalSkills => _skills.length;
  int get totalEducation => _education.length;
  int get draftCount =>
      _experiences.where((e) => !e.isPublished).length +
      _projects.where((p) => !p.isPublished).length +
      _skills.where((s) => !s.isPublished).length +
      _education.where((e) => !e.isPublished).length;

  Future<void> loadAllAdminData() async {
    final firestore = _firebaseService.firestore;
    if (firestore == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Profile
      final pDoc = await firestore
          .collection(AppConstants.colProfile)
          .doc('default')
          .get();
      if (pDoc.exists && pDoc.data() != null) {
        _profile = Profile.fromMap(pDoc.data()!, id: pDoc.id);
      }

      // 2. Experiences (all, including drafts)
      final expSnap = await firestore
          .collection(AppConstants.colExperiences)
          .get();
      if (expSnap.docs.isNotEmpty) {
        _experiences =
            expSnap.docs
                .map((d) => Experience.fromMap(d.data(), id: d.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 3. Projects (all, including drafts)
      final projSnap = await firestore
          .collection(AppConstants.colProjects)
          .get();
      if (projSnap.docs.isNotEmpty) {
        _projects =
            projSnap.docs
                .map((d) => Project.fromMap(d.data(), id: d.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 4. Skills (all)
      final skillSnap = await firestore
          .collection(AppConstants.colSkills)
          .get();
      if (skillSnap.docs.isNotEmpty) {
        _skills =
            skillSnap.docs
                .map((d) => Skill.fromMap(d.data(), id: d.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }

      // 5. Education (all)
      final eduSnap = await firestore
          .collection(AppConstants.colEducation)
          .get();
      if (eduSnap.docs.isNotEmpty) {
        _education =
            eduSnap.docs
                .map((d) => Education.fromMap(d.data(), id: d.id))
                .toList()
              ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // Profile Management
  // -------------------------------------------------------------
  Future<bool> saveProfile(Profile profile) async {
    _profile = profile.copyWith(updatedAt: DateTime.now());
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colProfile)
            .doc('default')
            .set(_profile.toMap(), SetOptions(merge: true));
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  // -------------------------------------------------------------
  // Experience Management
  // -------------------------------------------------------------
  Future<bool> saveExperience(Experience experience) async {
    Experience itemToSave = experience;
    if (itemToSave.id.isEmpty) {
      itemToSave = itemToSave.copyWith(
        id: _uuid.v4(),
        orderIndex: _experiences.length,
        createdAt: DateTime.now(),
      );
      _experiences.add(itemToSave);
    } else {
      final index = _experiences.indexWhere((e) => e.id == itemToSave.id);
      if (index >= 0) {
        _experiences[index] = itemToSave;
      } else {
        _experiences.add(itemToSave);
      }
    }
    _experiences.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colExperiences)
            .doc(itemToSave.id)
            .set(itemToSave.toMap(), SetOptions(merge: true));
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<bool> deleteExperience(String id) async {
    _experiences.removeWhere((e) => e.id == id);
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colExperiences)
            .doc(id)
            .delete();
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<void> reorderExperiences(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _experiences.removeAt(oldIndex);
    _experiences.insert(newIndex, item);

    for (int i = 0; i < _experiences.length; i++) {
      _experiences[i] = _experiences[i].copyWith(orderIndex: i);
      final firestore = _firebaseService.firestore;
      if (firestore != null) {
        firestore
            .collection(AppConstants.colExperiences)
            .doc(_experiences[i].id)
            .update({'orderIndex': i});
      }
    }
    notifyListeners();
  }

  // -------------------------------------------------------------
  // Project Management
  // -------------------------------------------------------------
  Future<bool> saveProject(Project project) async {
    Project itemToSave = project;
    if (itemToSave.id.isEmpty) {
      itemToSave = itemToSave.copyWith(
        id: _uuid.v4(),
        orderIndex: _projects.length,
        createdAt: DateTime.now(),
      );
      _projects.add(itemToSave);
    } else {
      final index = _projects.indexWhere((p) => p.id == itemToSave.id);
      if (index >= 0) {
        _projects[index] = itemToSave;
      } else {
        _projects.add(itemToSave);
      }
    }
    _projects.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colProjects)
            .doc(itemToSave.id)
            .set(itemToSave.toMap(), SetOptions(merge: true));
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<bool> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore.collection(AppConstants.colProjects).doc(id).delete();
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<void> reorderProjects(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _projects.removeAt(oldIndex);
    _projects.insert(newIndex, item);

    for (int i = 0; i < _projects.length; i++) {
      _projects[i] = _projects[i].copyWith(orderIndex: i);
      final firestore = _firebaseService.firestore;
      if (firestore != null) {
        firestore
            .collection(AppConstants.colProjects)
            .doc(_projects[i].id)
            .update({'orderIndex': i});
      }
    }
    notifyListeners();
  }

  // -------------------------------------------------------------
  // Skill Management
  // -------------------------------------------------------------
  Future<bool> saveSkill(Skill skill) async {
    Skill itemToSave = skill;
    if (itemToSave.id.isEmpty) {
      itemToSave = itemToSave.copyWith(
        id: _uuid.v4(),
        orderIndex: _skills.length,
      );
      _skills.add(itemToSave);
    } else {
      final index = _skills.indexWhere((s) => s.id == itemToSave.id);
      if (index >= 0) {
        _skills[index] = itemToSave;
      } else {
        _skills.add(itemToSave);
      }
    }
    _skills.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colSkills)
            .doc(itemToSave.id)
            .set(itemToSave.toMap(), SetOptions(merge: true));
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<bool> deleteSkill(String id) async {
    _skills.removeWhere((s) => s.id == id);
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore.collection(AppConstants.colSkills).doc(id).delete();
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  // -------------------------------------------------------------
  // Education Management
  // -------------------------------------------------------------
  Future<bool> saveEducation(Education education) async {
    Education itemToSave = education;
    if (itemToSave.id.isEmpty) {
      itemToSave = itemToSave.copyWith(
        id: _uuid.v4(),
        orderIndex: _education.length,
      );
      _education.add(itemToSave);
    } else {
      final index = _education.indexWhere((e) => e.id == itemToSave.id);
      if (index >= 0) {
        _education[index] = itemToSave;
      } else {
        _education.add(itemToSave);
      }
    }
    _education.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore
            .collection(AppConstants.colEducation)
            .doc(itemToSave.id)
            .set(itemToSave.toMap(), SetOptions(merge: true));
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }

  Future<bool> deleteEducation(String id) async {
    _education.removeWhere((e) => e.id == id);
    notifyListeners();

    final firestore = _firebaseService.firestore;
    if (firestore != null) {
      try {
        await firestore.collection(AppConstants.colEducation).doc(id).delete();
        return true;
      } catch (e) {
        _errorMessage = e.toString();
        return false;
      }
    }
    return true;
  }
}
