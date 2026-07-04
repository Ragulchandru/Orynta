// lib/features/workspace/presentation/widgets/workspace_avatar.dart
//
// Orynta 2.0 — Workspace Avatar button displaying initials or profile image

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_system.dart';
import '../providers/workspace_provider.dart';
import 'workspace_sheet.dart';

class WorkspaceAvatar extends ConsumerWidget {
  const WorkspaceAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final workspaceState = ref.watch(workspaceProvider);
    final user = workspaceState.user;

    final avatarBgColor = theme.primary.withValues(alpha: 0.12);
    final textColor = theme.primary;

    return ScaleOnPress(
      onTap: () {
        HapticFeedback.mediumImpact();
        showWorkspaceSheet(context);
      },
      child: Hero(
        tag: 'workspace_avatar',
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBgColor,
            border: Border.all(
              color: theme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: user?.photoUrl != null
                ? ClipOval(
                    child: Image.network(
                      user!.photoUrl!,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildInitialsText(user.initials, textColor, context),
                    ),
                  )
                : _buildInitialsText(user?.initials ?? 'U', textColor, context),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsText(String initials, Color color, BuildContext context) {
    return Text(
      initials,
      key: ValueKey(initials),
      style: context.typography.labelMedium.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
