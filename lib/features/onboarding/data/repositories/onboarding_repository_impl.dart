// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart
//
// Orynta 2.0 — Onboarding Repository Implementation
//
// Manages the 5 onboarding preference keys stored in Hive settings_box:
//   - is_onboarding_completed
//   - user_display_name
//   - default_home_screen
//   - default_notes_layout
//   - preferred_theme

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._box);

  final Box<String> _box;

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      final val = _box.get(AppStrings.onboardingCompletedSetting);
      return val == 'true';
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error reading completion: $e');
        return true;
      }());
      return false;
    }
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    try {
      await _box.put(AppStrings.onboardingCompletedSetting, completed ? 'true' : 'false');
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error saving completion: $e');
        return true;
      }());
    }
  }

  @override
  Future<String?> getUserDisplayName() async {
    try {
      return _box.get(AppStrings.userDisplayNameSetting);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setUserDisplayName(String name) async {
    try {
      await _box.put(AppStrings.userDisplayNameSetting, name.trim());
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error saving display name: $e');
        return true;
      }());
    }
  }

  @override
  Future<String> getDefaultHomeScreen() async {
    try {
      return _box.get(AppStrings.defaultHomeScreenSetting) ?? '/';
    } catch (e) {
      return '/';
    }
  }

  @override
  Future<void> setDefaultHomeScreen(String route) async {
    try {
      await _box.put(AppStrings.defaultHomeScreenSetting, route);
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error saving home screen: $e');
        return true;
      }());
    }
  }

  @override
  Future<String> getDefaultNotesLayout() async {
    try {
      return _box.get(AppStrings.defaultNotesLayoutSetting) ?? 'grid';
    } catch (e) {
      return 'grid';
    }
  }

  @override
  Future<void> setDefaultNotesLayout(String layout) async {
    try {
      await _box.put(AppStrings.defaultNotesLayoutSetting, layout);
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error saving notes layout: $e');
        return true;
      }());
    }
  }

  @override
  Future<String> getPreferredTheme() async {
    try {
      return _box.get(AppStrings.preferredThemeSetting) ?? 'system';
    } catch (e) {
      return 'system';
    }
  }

  @override
  Future<void> setPreferredTheme(String theme) async {
    try {
      await _box.put(AppStrings.preferredThemeSetting, theme);
    } catch (e) {
      assert(() {
        debugPrint('[OnboardingRepositoryImpl] Error saving preferred theme: $e');
        return true;
      }());
    }
  }
}
