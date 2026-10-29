import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../sections/portfolio_page.dart';
import '../../sections/projects/all_projects_page.dart';
import '../../sections/projects/project_detail_page.dart';
import 'app_route_transitions.dart';

/// Centralized router configuration for Dhruvi Patel's portfolio.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        // Public Portfolio Root (smooth fadeThrough transition)
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => AppRouteTransitions.fadeThrough(
            state: state,
            child: const PortfolioPage(),
          ),
        ),
        // Dedicated All Projects Directory Page (smooth slideUp transition)
        GoRoute(
          path: '/projects',
          name: 'projects',
          pageBuilder: (context, state) => AppRouteTransitions.slideUp(
            state: state,
            child: const AllProjectsPage(),
          ),
        ),
        // Dedicated Project Detail & Case Study Page
        GoRoute(
          path: '/projects/:slug',
          name: 'project_detail',
          pageBuilder: (context, state) {
            final slug = state.pathParameters['slug'] ?? '';
            return AppRouteTransitions.slideUp(
              state: state,
              child: ProjectDetailPage(slug: slug),
            );
          },
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
