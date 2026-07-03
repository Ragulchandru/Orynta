// lib/features/onboarding/domain/repositories/onboarding_repository.dart
//
// Orynta 2.0 — Onboarding Repository Interface
//
// Contract for persisting user onboarding status and workspace preferences.

abstract interface class OnboardingRepository {
  /// Whether the user has completed the onboarding flow.
  Future<bool> isOnboardingCompleted();

  /// Marks onboarding as completed.
  Future<void> setOnboardingCompleted(bool completed);

  /// Gets stored user display name.
  Future<String?> getUserDisplayName();

  /// Stores user display name.
  Future<void> setUserDisplayName(String name);

  /// Gets stored default home screen route (`/`, `/notes`, `/planner`, `/insights`).
  Future<String> getDefaultHomeScreen();

  /// Stores default home screen route preference.
  Future<void> setDefaultHomeScreen(String route);

  /// Gets stored notes layout preference (`grid`, `list`, `comfortable`).
  Future<String> getDefaultNotesLayout();

  /// Stores default notes layout preference.
  Future<void> setDefaultNotesLayout(String layout);

  /// Gets stored preferred theme (`system`, `light`, `dark`, `amoled`).
  Future<String> getPreferredTheme();

  /// Stores preferred theme preference.
  Future<void> setPreferredTheme(String theme);
}
