// lib/features/profile/presentation/providers/profile_provider.dart
//
// Orynta 2.0 — User Profile Reactive Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/profile.dart';

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier() : super(_initialState());

  static Profile _initialState() {
    final box = Hive.box<String>(AppStrings.settingsBoxName);

    // Read display name
    final name = box.get(AppStrings.userDisplayNameSetting) ?? '';

    // Read or initialize member since
    var memberSince = box.get('member_since');
    if (memberSince == null || memberSince.trim().isEmpty) {
      memberSince = DateFormat('MMMM yyyy').format(DateTime.now());
      box.put('member_since', memberSince);
    }

    final workspaceName = box.get('workspace_name') ?? 'Local Workspace';
    final avatarColorValStr = box.get('avatar_color') ?? '0xFF3A86F0';
    final avatarColor = int.tryParse(avatarColorValStr) ?? 0xFF3A86F0;
    final avatarStyle = box.get('avatar_style') ?? 'initials';
    final lastProfileUpdate = box.get('last_profile_update') ?? '';
    final profilePhotoPath = box.get('profile_photo_path');
    final email = box.get('profile_email') ?? 'ragul@orynta.com';
    final bio = box.get('profile_bio') ?? '';
    final preferredLanguage = box.get('profile_preferred_language') ?? 'English';
    final cloudSyncEnabled = box.get('profile_cloud_sync_enabled') == 'true';
    final lastBackup = box.get('profile_last_backup');

    return Profile(
      displayName: name,
      workspaceName: workspaceName,
      avatarColor: avatarColor,
      avatarStyle: avatarStyle,
      memberSince: memberSince,
      lastProfileUpdate: lastProfileUpdate,
      profilePhotoPath: profilePhotoPath,
      email: email,
      bio: bio,
      preferredLanguage: preferredLanguage,
      cloudSyncEnabled: cloudSyncEnabled,
      lastBackup: lastBackup,
    );
  }

  void updateDisplayName(String name) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    final cleaned = name.trim();
    box.put(AppStrings.userDisplayNameSetting, cleaned);
    final nowStr = DateTime.now().toIso8601String();
    box.put('last_profile_update', nowStr);

    state = state.copyWith(
      displayName: cleaned,
      lastProfileUpdate: nowStr,
    );
  }

  void updateWorkspaceName(String workspaceName) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    final cleaned = workspaceName.trim();
    box.put('workspace_name', cleaned);
    final nowStr = DateTime.now().toIso8601String();
    box.put('last_profile_update', nowStr);

    state = state.copyWith(
      workspaceName: cleaned,
      lastProfileUpdate: nowStr,
    );
  }

  void updateAvatarColor(int colorValue) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    box.put('avatar_color', colorValue.toString());
    final nowStr = DateTime.now().toIso8601String();
    box.put('last_profile_update', nowStr);

    state = state.copyWith(
      avatarColor: colorValue,
      lastProfileUpdate: nowStr,
    );
  }

  void updateAvatarStyle(String style) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    box.put('avatar_style', style);
    final nowStr = DateTime.now().toIso8601String();
    box.put('last_profile_update', nowStr);

    state = state.copyWith(
      avatarStyle: style,
      lastProfileUpdate: nowStr,
    );
  }

  void updateProfile({
    required String name,
    required String workspaceName,
    required int avatarColor,
  }) {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    final cleanedName = name.trim();
    final cleanedWorkspace = workspaceName.trim();
    box.put(AppStrings.userDisplayNameSetting, cleanedName);
    box.put('workspace_name', cleanedWorkspace);
    box.put('avatar_color', avatarColor.toString());
    final nowStr = DateTime.now().toIso8601String();
    box.put('last_profile_update', nowStr);

    state = state.copyWith(
      displayName: cleanedName,
      workspaceName: cleanedWorkspace,
      avatarColor: avatarColor,
      lastProfileUpdate: nowStr,
    );
  }

  void resetProfile() {
    final box = Hive.box<String>(AppStrings.settingsBoxName);
    box.delete(AppStrings.userDisplayNameSetting);
    box.delete('workspace_name');
    box.delete('avatar_color');
    box.delete('avatar_style');
    box.delete('last_profile_update');
    box.delete('profile_photo_path');
    box.delete('profile_email');
    box.delete('profile_bio');
    box.delete('profile_preferred_language');
    box.delete('profile_cloud_sync_enabled');
    box.delete('profile_last_backup');

    state = _initialState();
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile>((ref) {
  return ProfileNotifier();
});
