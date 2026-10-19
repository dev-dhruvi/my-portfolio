import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'repositories/admin_repository.dart';
import 'repositories/portfolio_repository.dart';
import 'services/auth_service.dart';

/// Root application widget configuring state providers, theme, and declarative routing.
class DhruviPortfolioApp extends StatefulWidget {
  const DhruviPortfolioApp({super.key});

  @override
  State<DhruviPortfolioApp> createState() => _DhruviPortfolioAppState();
}

class _DhruviPortfolioAppState extends State<DhruviPortfolioApp> {
  late final ThemeController _themeController;
  late final AuthService _authService;
  late final PortfolioRepository _portfolioRepository;
  late final AdminRepository _adminRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _authService = AuthService();
    _portfolioRepository = PortfolioRepository();
    _adminRepository = AdminRepository();
    _router = AppRouter.createRouter(_authService);
  }

  @override
  void dispose() {
    _themeController.dispose();
    _authService.dispose();
    _portfolioRepository.dispose();
    _adminRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeController),
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _portfolioRepository),
        ChangeNotifierProvider.value(value: _adminRepository),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp.router(
            title:
                '${AppConstants.developerName} | ${AppConstants.primaryRole}',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
