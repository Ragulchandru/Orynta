// lib/features/auth/data/repositories/app_lock_repository_impl.dart
//
// AppLockRepositoryImpl — Hive and local_auth implementation of AppLockRepository.
//
// Manages App Lock configuration persistence in Hive settings_box and wraps
// local_auth for device biometrics verification.

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/repositories/app_lock_repository.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  AppLockRepositoryImpl(this._box);

  final Box<String> _box;
  final LocalAuthentication _localAuth = LocalAuthentication();

  // ─── Settings Keys ────────────────────────────────────────────────────────
  static const String _keyEnabled = 'app_lock_enabled';
  static const String _keyPinHash = 'app_lock_pin_hash';
  static const String _keyBiometricEnabled = 'app_lock_biometrics_enabled';
  static const String _keyDuration = 'app_lock_duration';
  static const String _keyLastActive = 'app_lock_last_active_time';
  static const String _keyPinLength = 'app_lock_pin_length';

  // ─── PIN Hashing Utility ──────────────────────────────────────────────────
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ─── Repository Interface Methods ─────────────────────────────────────────

  @override
  Future<bool> isAppLockEnabled() async {
    return _box.get(_keyEnabled) == 'true';
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return _box.get(_keyBiometricEnabled) == 'true';
  }

  @override
  Future<int> getPinLength() async {
    final storedValue = _box.get(_keyPinLength);
    if (storedValue == null) return 4;
    return int.tryParse(storedValue) ?? 4;
  }

  @override
  Future<int> getAutoLockDuration() async {
    final storedValue = _box.get(_keyDuration);
    if (storedValue == null) return 0; // Default to immediately
    return int.tryParse(storedValue) ?? 0;
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final storedHash = _box.get(_keyPinHash);
    if (storedHash == null) return false;
    return _hashPin(pin) == storedHash;
  }

  @override
  Future<void> enableAppLock(String pin) async {
    final hash = _hashPin(pin);
    await _box.put(_keyEnabled, 'true');
    await _box.put(_keyPinHash, hash);
    await _box.put(_keyPinLength, pin.length.toString());
  }

  @override
  Future<void> disableAppLock() async {
    await _box.put(_keyEnabled, 'false');
    await _box.delete(_keyPinHash);
    await _box.delete(_keyPinLength);
    await _box.put(_keyBiometricEnabled, 'false');
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _box.put(_keyBiometricEnabled, enabled ? 'true' : 'false');
  }

  @override
  Future<void> setAutoLockDuration(int seconds) async {
    await _box.put(_keyDuration, seconds.toString());
  }

  @override
  Future<void> updateLastActiveTime() async {
    final ms = DateTime.now().millisecondsSinceEpoch.toString();
    await _box.put(_keyLastActive, ms);
  }

  @override
  Future<bool> shouldLockOnResume() async {
    if (!await isAppLockEnabled()) return false;

    final lastActiveStr = _box.get(_keyLastActive);
    if (lastActiveStr == null) return true; // Lock if no record exists

    final lastActiveMs = int.tryParse(lastActiveStr);
    if (lastActiveMs == null) return true;

    final durationSeconds = await getAutoLockDuration();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = (nowMs - lastActiveMs) / 1000.0;

    return elapsedSeconds >= durationSeconds;
  }

  @override
  Future<bool> isBiometricsSupported() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    if (!await isBiometricsSupported() || !await isBiometricEnabled()) {
      return false;
    }
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock Orynta',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
