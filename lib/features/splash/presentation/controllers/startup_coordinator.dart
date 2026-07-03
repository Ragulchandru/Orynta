// lib/features/splash/presentation/controllers/startup_coordinator.dart
//
// Orynta 2.0 — Startup Coordinator
//
// Pure non-UI coordinator responsible for background startup initialization,
// executing startup tasks (e.g. auth check, migrations), and determining the
// target navigation route. Guarantees returning a result within 2.5 seconds max.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/app_lock_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';

/// Contract for individual startup initialization tasks (e.g. Sync, Migrations).
abstract interface class StartupTask {
  String get name;
  Future<void> execute(Ref ref);
}

/// Result object holding the evaluated target destination.
@immutable
class StartupResult {
  const StartupResult({
    required this.targetRoute,
    this.isSuccessful = true,
  });

  final String targetRoute;
  final bool isSuccessful;
}

/// Riverpod provider for [StartupCoordinator].
final startupCoordinatorProvider = Provider<StartupCoordinator>((ref) {
  return StartupCoordinator(ref);
});

/// Evaluates application state and determines the initial navigation destination.
class StartupCoordinator {
  StartupCoordinator(this._ref, {List<StartupTask>? tasks})
      : _tasks = tasks ?? const [];

  final Ref _ref;
  final List<StartupTask> _tasks;

  /// Runs all registered startup tasks with timeout protection and returns the target route.
  Future<StartupResult> initialize() async {
    try {
      return await _performInit().timeout(
        const Duration(milliseconds: 2500),
        onTimeout: () {
          assert(() {
            debugPrint('[StartupCoordinator] Init timed out after 2.5s fallback applied');
            return true;
          }());
          return const StartupResult(targetRoute: '/');
        },
      );
    } catch (e, stack) {
      assert(() {
        debugPrint('[StartupCoordinator] Exception during init: $e\n$stack');
        return true;
      }());
      return const StartupResult(targetRoute: '/');
    }
  }

  Future<StartupResult> _performInit() async {
    for (final task in _tasks) {
      try {
        await task.execute(_ref);
      } catch (e, stack) {
        assert(() {
          debugPrint('[StartupCoordinator] Task ${task.name} failed: $e\n$stack');
          return true;
        }());
      }
    }

    // Evaluate destination route based on application guards
    try {
      final lockState = _ref.read(appLockStateProvider);
      if (lockState.isLocked) {
        return const StartupResult(targetRoute: '/lock');
      }

      final onboardingRepo = _ref.read(onboardingRepositoryProvider);
      final isCompleted = await onboardingRepo.isOnboardingCompleted();
      if (!isCompleted) {
        return const StartupResult(targetRoute: '/onboarding');
      }

      final defaultHome = await onboardingRepo.getDefaultHomeScreen();
      return StartupResult(targetRoute: defaultHome);
    } catch (e) {
      assert(() {
        debugPrint('[StartupCoordinator] Error reading startup guards: $e');
        return true;
      }());
    }

    // Default route: Dashboard ('/')
    return const StartupResult(targetRoute: '/');
  }
}
