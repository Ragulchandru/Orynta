// lib/features/auth/presentation/providers/app_lock_provider.dart
//
// AppLockProvider — Riverpod state notifier for managing the App Lock authentication state.
//
// Observes AppLifecycleState changes (via WidgetsBindingObserver) to enforce
// auto-lock timeouts and handles PIN setup/verification/biometrics.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/app_lock_repository.dart';
import '../../data/repositories/app_lock_repository_impl.dart';

class AppLockState {
  const AppLockState({
    required this.isLocked,
    required this.isEnabled,
    required this.isBiometricsEnabled,
    required this.autoLockDuration,
    required this.isBiometricsSupported,
  });

  final bool isLocked;
  final bool isEnabled;
  final bool isBiometricsEnabled;
  final int autoLockDuration; // in seconds
  final bool isBiometricsSupported;

  AppLockState copyWith({
    bool? isLocked,
    bool? isEnabled,
    bool? isBiometricsEnabled,
    int? autoLockDuration,
    bool? isBiometricsSupported,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      autoLockDuration: autoLockDuration ?? this.autoLockDuration,
      isBiometricsSupported: isBiometricsSupported ?? this.isBiometricsSupported,
    );
  }
}

class AppLockNotifier extends StateNotifier<AppLockState> with WidgetsBindingObserver {
  AppLockNotifier(this._repository)
      : super(
          const AppLockState(
            isLocked: false,
            isEnabled: false,
            isBiometricsEnabled: false,
            autoLockDuration: 0,
            isBiometricsSupported: false,
          ),
        ) {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  final AppLockRepository _repository;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _init() async {
    final isEnabled = await _repository.isAppLockEnabled();
    final isBiometricsEnabled = await _repository.isBiometricEnabled();
    final duration = await _repository.getAutoLockDuration();
    final isSupported = await _repository.isBiometricsSupported();

    state = AppLockState(
      isLocked: isEnabled, // Guard on launch if enabled
      isEnabled: isEnabled,
      isBiometricsEnabled: isBiometricsEnabled,
      autoLockDuration: duration,
      isBiometricsSupported: isSupported,
    );
  }

  bool _isAuthenticating = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isAuthenticating) return;
    if (state == AppLifecycleState.paused) {
      _repository.updateLastActiveTime();
    } else if (state == AppLifecycleState.resumed) {
      _checkAutoLock();
    }
  }

  Future<void> _checkAutoLock() async {
    if (state.isEnabled && !state.isLocked) {
      final shouldLock = await _repository.shouldLockOnResume();
      if (shouldLock) {
        state = state.copyWith(isLocked: true);
      }
    }
  }

  // ─── Mutations & Verification ─────────────────────────────────────────────

  Future<bool> verifyPin(String pin) async {
    final isValid = await _repository.verifyPin(pin);
    if (isValid) {
      state = state.copyWith(isLocked: false);
      return true;
    }
    return false;
  }

  Future<void> enableAppLock(String pin) async {
    await _repository.enableAppLock(pin);
    state = state.copyWith(
      isEnabled: true,
      isLocked: false,
    );
  }

  Future<void> disableAppLock() async {
    await _repository.disableAppLock();
    state = state.copyWith(
      isEnabled: false,
      isLocked: false,
      isBiometricsEnabled: false,
    );
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _repository.setBiometricsEnabled(enabled);
    state = state.copyWith(isBiometricsEnabled: enabled);
  }

  Future<void> setAutoLockDuration(int seconds) async {
    await _repository.setAutoLockDuration(seconds);
    state = state.copyWith(autoLockDuration: seconds);
  }

  Future<bool> authenticateWithBiometrics() async {
    _isAuthenticating = true;
    try {
      final success = await _repository.authenticateWithBiometrics();
      if (success) {
        state = state.copyWith(isLocked: false);
        return true;
      }
      return false;
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
      _isAuthenticating = false;
    }
  }

  /// Manually locks the app (useful when testing or forcing lock)
  void lock() {
    if (state.isEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }
}

// ─── Providers ──────────────────────────────────────────────────────────────

final appLockRepositoryProvider = Provider<AppLockRepository>(
  (ref) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    return AppLockRepositoryImpl(box);
  },
);

final appLockStateProvider =
    StateNotifierProvider<AppLockNotifier, AppLockState>(
  (ref) {
    final repo = ref.watch(appLockRepositoryProvider);
    return AppLockNotifier(repo);
  },
);
