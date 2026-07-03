// lib/features/dashboard/data/repositories/user_profile_repository_impl.dart
//
// Orynta 2.0 — User Profile Repository Implementation

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this._box);

  final Box<String> _box;

  @override
  Future<String> getUserDisplayName() async {
    try {
      final val = _box.get(AppStrings.userDisplayNameSetting);
      if (val != null && val.trim().isNotEmpty) {
        return val.trim();
      }
      return 'Guest';
    } catch (e) {
      assert(() {
        debugPrint('[UserProfileRepositoryImpl] Error reading name: $e');
        return true;
      }());
      return 'Guest';
    }
  }
}
