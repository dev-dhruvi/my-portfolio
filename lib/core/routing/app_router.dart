import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../admin/auth/admin_login_page.dart';
import '../../admin/dashboard/admin_dashboard_page.dart';
import '../../sections/portfolio_page.dart';
import '../../services/auth_service.dart';

/// Centralized router configuration with static web hosting compatibility
/// and admin route authentication guards.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authService,
      routes: [
        // Public Portfolio Root
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const PortfolioPage(),
        ),

        // Admin Root Redirect
        GoRoute(
          path: '/admin',
          redirect: (context, state) {
            if (authService.isAuthenticated && authService.isAdmin) {
              return '/admin/dashboard';
            }
            return '/admin/login';
          },
        ),

        // Admin Login
        GoRoute(
          path: '/admin/login',
          name: 'admin-login',
          builder: (context, state) => const AdminLoginPage(),
          redirect: (context, state) {
            if (authService.isAuthenticated && authService.isAdmin) {
              return '/admin/dashboard';
            }
            return null;
          },
        ),

        // Admin Dashboard (Guarded)
        GoRoute(
          path: '/admin/dashboard',
          name: 'admin-dashboard',
          builder: (context, state) => const AdminDashboardPage(),
          redirect: (context, state) {
            if (!authService.isAuthenticated || !authService.isAdmin) {
              return '/admin/login';
            }
            return null;
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
