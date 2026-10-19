import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import 'firebase_service.dart';

/// Authentication state model.
class AuthState {
  final bool isAuthenticated;
  final bool isAdmin;
  final String? uid;
  final String? email;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.isAdmin = false,
    this.uid,
    this.email,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isAdmin,
    String? uid,
    String? email,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isAdmin: isAdmin ?? this.isAdmin,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Service handling administrator authentication and authorization checks.
class AuthService extends ChangeNotifier {
  final FirebaseService _firebaseService;
  AuthState _state = const AuthState();

  AuthService({FirebaseService? firebaseService})
    : _firebaseService = firebaseService ?? FirebaseService.instance {
    _initAuthListener();
  }

  AuthState get state => _state;
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isAdmin => _state.isAdmin;
  String? get currentEmail => _state.email;

  void _initAuthListener() {
    final auth = _firebaseService.auth;
    if (auth != null) {
      auth.authStateChanges().listen((user) async {
        if (user != null) {
          final isAuthorized = await checkIsAdmin(user.uid);
          _state = _state.copyWith(
            isAuthenticated: true,
            isAdmin: isAuthorized,
            uid: user.uid,
            email: user.email,
            isLoading: false,
            errorMessage: isAuthorized ? null : 'Unauthorized admin access.',
          );
        } else {
          _state = const AuthState();
        }
        notifyListeners();
      });
    }
  }

  /// Verifies with backend Firestore whether the UID is listed in the `admins` collection.
  Future<bool> checkIsAdmin(String uid) async {
    final firestore = _firebaseService.firestore;
    if (firestore == null) {
      // In local offline fallback mode without Firebase configured,
      // allow testing login with a recognized test admin if offline.
      return false;
    }

    try {
      final doc = await firestore
          .collection(AppConstants.colAdmins)
          .doc(uid)
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists && doc.data()?['role'] == 'admin') {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[AuthService] Admin check failed: $e');
      return false;
    }
  }

  /// Signs in using administrator credentials.
  Future<bool> signIn(String email, String password) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final auth = _firebaseService.auth;

    if (auth == null) {
      // Offline/Demo fallback validation (for review/test when Firebase is unconfigured)
      await Future.delayed(const Duration(milliseconds: 600));
      if (email.trim().toLowerCase() == AppConstants.email.toLowerCase() &&
          password.isNotEmpty) {
        _state = _state.copyWith(
          isAuthenticated: true,
          isAdmin: true,
          uid: 'offline_admin_uid',
          email: email.trim(),
          isLoading: false,
          errorMessage: null,
        );
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(
          isAuthenticated: false,
          isAdmin: false,
          isLoading: false,
          errorMessage: 'Invalid credentials or Firebase unconfigured. Provide verified admin email.',
        );
        notifyListeners();
        return false;
      }
    }

    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('User authentication failed.');
      }

      final isAuthorized = await checkIsAdmin(uid);
      if (!isAuthorized) {
        // Not an authorized admin in Firestore admins collection!
        await auth.signOut();
        _state = const AuthState(
          errorMessage: 'Access denied. This account is not authorized as an administrator.',
        );
        notifyListeners();
        return false;
      }

      _state = _state.copyWith(
        isAuthenticated: true,
        isAdmin: true,
        uid: uid,
        email: userCredential.user?.email,
        isLoading: false,
        errorMessage: null,
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'Authentication failed.';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else if (e.code == 'user-disabled') {
        message = 'This administrator account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
      } else {
        message = e.message ?? 'Authentication error.';
      }

      _state = _state.copyWith(
        isAuthenticated: false,
        isAdmin: false,
        isLoading: false,
        errorMessage: message,
      );
      notifyListeners();
      return false;
    } catch (e) {
      _state = _state.copyWith(
        isAuthenticated: false,
        isAdmin: false,
        isLoading: false,
        errorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  /// Signs out and resets application state.
  Future<void> signOut() async {
    final auth = _firebaseService.auth;
    if (auth != null) {
      await auth.signOut();
    }
    _state = const AuthState();
    notifyListeners();
  }
}
