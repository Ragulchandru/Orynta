// lib/features/workspace/presentation/widgets/workspace_avatar.dart
//
// Orynta 2.0 — Workspace Avatar button displaying initials or profile image

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/router/route_names.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class WorkspaceAvatar extends ConsumerWidget {
  const WorkspaceAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    final profileColors = context.appTheme.profile;
    final avatarBgColor = profileColors.avatarBackground;
    final borderColor = profileColors.avatarBorder;
    final textColor = profileColors.avatarText;

    return ScaleOnPress(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.pushNamed(RouteNames.profile);
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
              color: borderColor,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: profile.profilePhotoPath != null && profile.profilePhotoPath!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      profile.profilePhotoPath!,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildInitialsText(profile.initials, textColor, context),
                    ),
                  )
                : _buildInitialsText(profile.displayName.isNotEmpty ? profile.initials : 'U', textColor, context),
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
