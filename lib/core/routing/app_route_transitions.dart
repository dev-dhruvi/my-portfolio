import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable smooth page transitions for Flutter Web & Mobile navigation.
/// Eliminates the default jarring web page switch with sleek easing curves.
class AppRouteTransitions {
  AppRouteTransitions._();

  /// Smooth fade-through transition with subtle scale (ideal for route changes).
  static CustomTransitionPage<T> fadeThrough<T>({
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
          return child;
        }

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final scaleAnimation = Tween<double>(
          begin: 0.97,
          end: 1.0,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    );
  }

  /// Upward slide with fade transition (ideal for detail and directory pages).
  static CustomTransitionPage<T> slideUp<T>({
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 450),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
          return child;
        }

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
    );
  }
}
