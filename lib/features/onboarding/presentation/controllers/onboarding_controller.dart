// lib/features/onboarding/presentation/controllers/onboarding_controller.dart
//
// Orynta 2.0 — Onboarding Controller & State

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/onboarding_config.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../providers/onboarding_providers.dart';
import 'onboarding_analytics.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    required this.currentPage,
    required this.config,
    this.displayName = '',
    this.defaultHomeScreen = '/',
    this.defaultNotesLayout = 'grid',
    this.preferredTheme = 'system',
    this.isDirty = false,
    this.isPreparing = false,
  });

  final int currentPage;
  final OnboardingConfig config;
  final String displayName;
  final String defaultHomeScreen;
  final String defaultNotesLayout;
  final String preferredTheme;
  final bool isDirty;
  final bool isPreparing;

  /// Returns cleaned display name or 'Guest' fallback.
  String get effectiveDisplayName {
    final cleaned = displayName.trim().replaceAll(RegExp(r'\s+'), ' ');
    return cleaned.isEmpty ? 'Guest' : cleaned;
  }

  OnboardingState copyWith({
    int? currentPage,
    OnboardingConfig? config,
    String? displayName,
    String? defaultHomeScreen,
    String? defaultNotesLayout,
    String? preferredTheme,
    bool? isDirty,
    bool? isPreparing,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      config: config ?? this.config,
      displayName: displayName ?? this.displayName,
      defaultHomeScreen: defaultHomeScreen ?? this.defaultHomeScreen,
      defaultNotesLayout: defaultNotesLayout ?? this.defaultNotesLayout,
      preferredTheme: preferredTheme ?? this.preferredTheme,
      isDirty: isDirty ?? this.isDirty,
      isPreparing: isPreparing ?? this.isPreparing,
    );
  }
}

final onboardingConfigProvider = Provider<OnboardingConfig>((ref) {
  return const OnboardingConfig();
});


final onboardingControllerProvider =
    StateNotifierProvider.autoDispose<OnboardingController, OnboardingState>((ref) {
  final config = ref.watch(onboardingConfigProvider);
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingController(config, repository, ref);
});

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(OnboardingConfig config, this._repository, this._ref)
      : super(OnboardingState(currentPage: 0, config: config)) {
    OnboardingAnalytics.log(OnboardingAnalytics.eventStarted);
  }

  final OnboardingRepository _repository;
  final Ref _ref;

  void setPage(int page) {
    if (page < 0 || page >= state.config.totalPages) return;
    state = state.copyWith(currentPage: page);
  }

  void updateDisplayName(String name) {
    final trimmed = name.length > state.config.maxDisplayNameLength
        ? name.substring(0, state.config.maxDisplayNameLength)
        : name;

    state = state.copyWith(
      displayName: trimmed,
      isDirty: true,
    );
    OnboardingAnalytics.log(OnboardingAnalytics.eventNameEntered, {'name_len': trimmed.length});
  }

  void setHomeScreen(String route) {
    state = state.copyWith(
      defaultHomeScreen: route,
      isDirty: true,
    );
    OnboardingAnalytics.log(OnboardingAnalytics.eventStartupSelected, {'route': route});
  }

  void setNotesLayout(String layout) {
    state = state.copyWith(
      defaultNotesLayout: layout,
      isDirty: true,
    );
    OnboardingAnalytics.log(OnboardingAnalytics.eventLayoutSelected, {'layout': layout});
  }

  void setTheme(String theme) {
    state = state.copyWith(
      preferredTheme: theme,
      isDirty: true,
    );
    OnboardingAnalytics.log(OnboardingAnalytics.eventThemeSelected, {'theme': theme});
  }

  /// Performs Smart Skip applying defaults and saving state.
  Future<void> smartSkip(VoidCallback onComplete) async {
    OnboardingAnalytics.log(OnboardingAnalytics.eventSkipped);
    await _persistAllPreferences(
      name: '',
      homeScreen: '/',
      layout: 'grid',
      theme: 'system',
    );
    onComplete();
  }

  /// Finalizes onboarding with chosen preferences and triggers 800ms preparation transition.
  Future<void> completeOnboarding(VoidCallback onComplete) async {
    if (state.isPreparing) return;

    state = state.copyWith(isPreparing: true);

    await _persistAllPreferences(
      name: state.effectiveDisplayName == 'Guest' ? '' : state.effectiveDisplayName,
      homeScreen: state.defaultHomeScreen,
      layout: state.defaultNotesLayout,
      theme: state.preferredTheme,
    );

    // 800ms workspace preparation transition
    await Future.delayed(state.config.preparationDuration);

    OnboardingAnalytics.log(OnboardingAnalytics.eventCompleted);
    onComplete();
  }

  Future<void> _persistAllPreferences({
    required String name,
    required String homeScreen,
    required String layout,
    required String theme,
  }) async {
    await _repository.setUserDisplayName(name);
    await _repository.setDefaultHomeScreen(homeScreen);
    await _repository.setDefaultNotesLayout(layout);
    await _repository.setPreferredTheme(theme);
    await _repository.setOnboardingCompleted(true);

    if (name.trim().isNotEmpty) {
      _ref.read(profileProvider.notifier).updateProfile(
            name: name.trim(),
            workspaceName: 'Local Workspace',
            avatarColor: 0xFF3A86F0, // Default blue avatar color
          );
    } else {
      _ref.read(profileProvider.notifier).resetProfile();
    }
  }
}
