// lib/features/auth/domain/repositories/app_lock_repository.dart
//
// AppLockRepository — Domain interface for App Lock settings and authentication.
//
// Follows the Dependency Inversion Principle. The data layer will implement
// this repository using Hive (for storage) and local_auth (for biometrics).

abstract interface class AppLockRepository {
  /// Checks whether App Lock is enabled in settings.
  Future<bool> isAppLockEnabled();

  /// Checks whether biometric authentication is enabled in settings.
  Future<bool> isBiometricEnabled();

  /// Gets the configured PIN length (4 or 6).
  Future<int> getPinLength();

  /// Gets the configured auto-lock duration in seconds.
  Future<int> getAutoLockDuration();

  /// Verifies if the entered [pin] matches the stored PIN hash.
  Future<bool> verifyPin(String pin);

  /// Enables App Lock and saves the SHA-256 hash of the [pin].
  Future<void> enableAppLock(String pin);

  /// Disables App Lock and clears the stored PIN hash and biometric preferences.
  Future<void> disableAppLock();

  /// Sets whether biometric authentication is enabled.
  Future<void> setBiometricsEnabled(bool enabled);

  /// Sets the auto-lock timeout duration in seconds.
  Future<void> setAutoLockDuration(int seconds);

  /// Updates the timestamp when the app was last actively used.
  Future<void> updateLastActiveTime();

  /// Checks if the app has been in the background longer than the auto-lock duration.
  Future<bool> shouldLockOnResume();

  /// Checks if the device's hardware supports biometrics (fingerprint/face unlock).
  Future<bool> isBiometricsSupported();

  /// Triggers the device's native biometric prompt. Returns true if successful.
  Future<bool> authenticateWithBiometrics();
}
