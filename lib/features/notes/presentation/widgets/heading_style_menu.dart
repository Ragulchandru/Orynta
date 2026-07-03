// lib/features/notes/presentation/widgets/heading_style_menu.dart
//
// Orynta 2.0 — Editor Heading Style Popup Menu

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class HeadingStyleMenu extends StatelessWidget {
  const HeadingStyleMenu({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: context.colors.surfaceContainerHigh,
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Text Style',
        icon: Icon(
          Icons.text_fields_rounded,
          color: context.colors.textSecondary,
        ),
        onSelected: onSelected,
        offset: const Offset(0, -180),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'normal',
            child: Text(
              'Normal Text',
              style: context.typography.bodyMedium.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'h1',
            child: Text(
              'Heading 1',
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'h2',
            child: Text(
              'Heading 2',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'h3',
            child: Text(
              'Heading 3',
              style: context.typography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
