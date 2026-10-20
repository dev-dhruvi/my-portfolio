import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'repositories/portfolio_repository.dart';

/// Root application widget configuring state providers, theme, and declarative routing.
class DhruviPortfolioApp extends StatefulWidget {
  const DhruviPortfolioApp({super.key});

  @override
  State<DhruviPortfolioApp> createState() => _DhruviPortfolioAppState();
}

class _DhruviPortfolioAppState extends State<DhruviPortfolioApp> {
  late final ThemeController _themeController;
  late final PortfolioRepository _portfolioRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _portfolioRepository = PortfolioRepository();
    _router = AppRouter.createRouter();
  }

  @override
  void dispose() {
    _themeController.dispose();
    _portfolioRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeController),
        ChangeNotifierProvider.value(value: _portfolioRepository),
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
