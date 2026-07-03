// lib/features/notes/presentation/widgets/editor_status_bar.dart
//
// Orynta 2.0 — Editor Status Bar Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class EditorStatusBar extends StatelessWidget {
  const EditorStatusBar({
    super.key,
    required this.saving,
    required this.saved,
  });

  final bool saving;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    String text = '';
    IconData? icon;

    if (saving) {
      text = 'Saving...';
      icon = Icons.sync_rounded;
    } else if (saved) {
      text = 'Saved';
      icon = Icons.cloud_done_outlined;
    }

    final show = saving || saved;

    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: AppDurations.medium,
      curve: AppCurves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: context.typography.labelSmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
