// lib/shared/widgets/premium_dialog.dart
//
// Orynta 2.0 — Custom premium dialogue modal

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumDialog extends StatelessWidget {
  const PremiumDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return AlertDialog(
      title: Text(
        title,
        style: context.typography.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
        ),
      ),
      content: content,
      actions: actions,
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(color: theme.outlineVariant, width: 1.0),
      ),
    );
  }
}
