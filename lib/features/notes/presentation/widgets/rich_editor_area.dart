// lib/features/notes/presentation/widgets/rich_editor_area.dart
//
// Orynta 2.0 — Editor Rich Text Canvas Area Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class RichEditorArea extends StatelessWidget {
  const RichEditorArea({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: context.typography.bodyMedium.copyWith(
        color: context.colors.textPrimary,
        height: 1.5,
      ),
      decoration: InputDecoration(
        hintText: 'Start writing...',
        hintStyle: context.typography.bodyMedium.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          height: 1.5,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: 40.0,
        ),
      ),
    );
  }
}
