// lib/features/profile/domain/models/profile.dart
//
// Orynta 2.0 — User Profile Model

class Profile {
  const Profile({
    required this.displayName,
    required this.workspaceName,
    required this.avatarColor,
    required this.avatarStyle,
    required this.memberSince,
    required this.lastProfileUpdate,
    this.profilePhotoPath,
    this.email,
    this.bio,
    this.preferredLanguage,
    this.cloudSyncEnabled = false,
    this.lastBackup,
  });

  final String displayName;
  final String workspaceName;
  final int avatarColor;
  final String avatarStyle;
  final String memberSince;
  final String lastProfileUpdate;
  final String? profilePhotoPath;
  final String? email;
  final String? bio;
  final String? preferredLanguage;
  final bool cloudSyncEnabled;
  final String? lastBackup;

  /// Returns 1-2 initials from the display name.
  String get initials {
    final cleaned = displayName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return 'U';
    final parts = cleaned.split(' ');
    if (parts.length == 1) {
      final nameStr = parts[0];
      return nameStr.substring(0, nameStr.length >= 2 ? 2 : 1).toUpperCase();
    }
    final firstInitial = parts[0][0];
    final secondInitial = parts[parts.length - 1][0];
    return (firstInitial + secondInitial).toUpperCase();
  }

  Profile copyWith({
    String? displayName,
    String? workspaceName,
    int? avatarColor,
    String? avatarStyle,
    String? memberSince,
    String? lastProfileUpdate,
    String? profilePhotoPath,
    String? email,
    String? bio,
    String? preferredLanguage,
    bool? cloudSyncEnabled,
    String? lastBackup,
  }) {
    return Profile(
      displayName: displayName ?? this.displayName,
      workspaceName: workspaceName ?? this.workspaceName,
      avatarColor: avatarColor ?? this.avatarColor,
      avatarStyle: avatarStyle ?? this.avatarStyle,
      memberSince: memberSince ?? this.memberSince,
      lastProfileUpdate: lastProfileUpdate ?? this.lastProfileUpdate,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }
}
