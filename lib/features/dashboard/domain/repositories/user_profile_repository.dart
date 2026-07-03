// lib/features/dashboard/domain/repositories/user_profile_repository.dart
//
// Orynta 2.0 — User Profile Repository Interface

abstract interface class UserProfileRepository {
  /// Fetches stored user display name for workspace greetings.
  Future<String> getUserDisplayName();
}
