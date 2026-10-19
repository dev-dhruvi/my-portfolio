import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Service managing Firebase initialization and access.
/// Safely falls back if Firebase is not yet configured or offline.
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  FirebaseAuth? get auth => _initialized ? FirebaseAuth.instance : null;
  FirebaseFirestore? get firestore =>
      _initialized ? FirebaseFirestore.instance : null;

  /// Initializes Firebase with optional options. If options are not provided
  /// or initialization fails, the app continues gracefully in fallback mode.
  Future<void> initialize({FirebaseOptions? options}) async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _initialized = true;
        return;
      }

      if (options != null) {
        await Firebase.initializeApp(options: options);
        _initialized = true;
        debugPrint(
          '[FirebaseService] Firebase initialized successfully with options.',
        );
      } else {
        // Try default initialize (e.g. from google-services / firebase_options.dart)
        await Firebase.initializeApp();
        _initialized = true;
        debugPrint(
          '[FirebaseService] Firebase initialized with default options.',
        );
      }
    } catch (e) {
      _initialized = false;
      debugPrint(
        '[FirebaseService] Firebase not initialized (${e.toString()}). Running in fallback mode.',
      );
    }
  }
}
