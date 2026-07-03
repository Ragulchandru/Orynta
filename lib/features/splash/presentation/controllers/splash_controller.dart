// lib/features/splash/presentation/controllers/splash_controller.dart
//
// Orynta 2.0 — Splash Controller
//
// Controls splash presentation state and synchronizes minimum animation duration
// with background initialization completion. Ensures navigation NEVER hangs indefinitely.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/splash_config.dart';
import 'startup_coordinator.dart';

enum SplashStatus {
  initial,
  animating,
  initialized,
  navigating,
}

@immutable
class SplashState {
  const SplashState({
    required this.status,
    required this.config,
    this.targetRoute,
  });

  final SplashStatus status;
  final SplashConfig config;
  final String? targetRoute;

  SplashState copyWith({
    SplashStatus? status,
    SplashConfig? config,
    String? targetRoute,
  }) {
    return SplashState(
      status: status ?? this.status,
      config: config ?? this.config,
      targetRoute: targetRoute ?? this.targetRoute,
    );
  }
}

final splashConfigProvider = Provider<SplashConfig>((ref) {
  return const SplashConfig();
});

// NON-autoDispose provider to prevent premature lifecycle disposal during startup
final splashControllerProvider =
    StateNotifierProvider<SplashController, SplashState>((ref) {
  final config = ref.watch(splashConfigProvider);
  final coordinator = ref.watch(startupCoordinatorProvider);
  return SplashController(config, coordinator);
});

class SplashController extends StateNotifier<SplashState> {
  SplashController(SplashConfig config, this._coordinator)
      : super(SplashState(status: SplashStatus.initial, config: config));

  final StartupCoordinator _coordinator;
  Timer? _fallbackTimer;
  bool _hasTriggeredNavigation = false;

  /// Starts the splash timeline and background startup synchronization.
  Future<void> startSplash({
    required bool isReducedMotion,
    required VoidCallback onReadyToNavigate,
  }) async {
    if (state.status != SplashStatus.initial) return;

    state = state.copyWith(status: SplashStatus.animating);

    final minDuration = isReducedMotion
        ? state.config.reducedMotionDuration
        : state.config.minSplashDuration;

    // Hard fallback timer — guarantees navigation after 3.5s under any circumstance
    _fallbackTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted && !_hasTriggeredNavigation) {
        assert(() {
          debugPrint('[SplashController] Hard fallback timer triggered navigation to /');
          return true;
        }());
        _triggerNavigation('/', onReadyToNavigate);
      }
    });

    try {
      final results = await Future.wait([
        Future.delayed(minDuration),
        _coordinator.initialize(),
      ]);

      final startupResult = results[1] as StartupResult;

      if (mounted && !_hasTriggeredNavigation) {
        state = state.copyWith(
          status: SplashStatus.initialized,
          targetRoute: startupResult.targetRoute,
        );
        _triggerNavigation(startupResult.targetRoute, onReadyToNavigate);
      }
    } catch (e, stack) {
      assert(() {
        debugPrint('[SplashController] Error in startSplash: $e\n$stack');
        return true;
      }());
      if (mounted && !_hasTriggeredNavigation) {
        _triggerNavigation('/', onReadyToNavigate);
      }
    }
  }

  void _triggerNavigation(String targetRoute, VoidCallback onReadyToNavigate) {
    if (_hasTriggeredNavigation) return;
    _hasTriggeredNavigation = true;
    _fallbackTimer?.cancel();

    state = state.copyWith(
      status: SplashStatus.navigating,
      targetRoute: targetRoute,
    );

    onReadyToNavigate();
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }
}
