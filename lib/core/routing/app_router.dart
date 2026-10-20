import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../sections/portfolio_page.dart';

/// Centralized router configuration for Dhruvi Patel's portfolio.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        // Public Portfolio Root
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const PortfolioPage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.explore_off_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
