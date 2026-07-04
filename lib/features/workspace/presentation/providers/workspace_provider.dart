// lib/features/workspace/presentation/providers/workspace_provider.dart
//
// Orynta 2.0 — Workspace State Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkspaceUser {
  const WorkspaceUser({
    required this.name,
    this.photoUrl,
    this.email,
  });

  final String name;
  final String? photoUrl;
  final String? email;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'U';
    if (parts.length == 1) {
      final nameStr = parts[0];
      return nameStr.substring(0, nameStr.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class WorkspaceState {
  const WorkspaceState({
    this.user,
    required this.workspaceName,
  });

  final WorkspaceUser? user;
  final String workspaceName;
}

class WorkspaceNotifier extends StateNotifier<WorkspaceState> {
  // Defaults to a local workspace user "Ragul Chandru" ("RC") to showcase M3 initials
  WorkspaceNotifier()
      : super(
          const WorkspaceState(
            user: WorkspaceUser(
              name: 'Ragul Chandru',
              email: 'ragul@orynta.com',
            ),
            workspaceName: 'Local Workspace',
          ),
        );

  void updateProfile({required String name, String? email, String? photoUrl}) {
    state = WorkspaceState(
      user: WorkspaceUser(name: name, email: email, photoUrl: photoUrl),
      workspaceName: state.workspaceName,
    );
  }

  void signOut() {
    state = WorkspaceState(
      user: null,
      workspaceName: state.workspaceName,
    );
  }
}

final workspaceProvider = StateNotifierProvider<WorkspaceNotifier, WorkspaceState>((ref) {
  return WorkspaceNotifier();
});
