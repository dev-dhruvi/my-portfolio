import 'package:flutter/material.dart';

import 'app.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safely attempt Firebase initialization (falls back gracefully if unconfigured)
  await FirebaseService.instance.initialize();

  runApp(const DhruviPortfolioApp());
}
