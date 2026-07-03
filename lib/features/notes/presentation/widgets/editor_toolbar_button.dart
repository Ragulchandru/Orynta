// lib/features/notes/presentation/widgets/editor_toolbar_button.dart
//
// Orynta 2.0 — Editor Formatting Toolbar Button

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class EditorToolbarButton extends StatelessWidget {
  const EditorToolbarButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Material(
          color: isDisabled
              ? Colors.transparent
              : isSelected
                  ? primaryColor.withValues(alpha: 0.12)
                  : Colors.transparent,
          borderRadius: context.radius.borderRadiusMd,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: context.radius.borderRadiusMd,
            hoverColor: primaryColor.withValues(alpha: 0.04),
            splashColor: primaryColor.withValues(alpha: 0.08),
            child: Opacity(
              opacity: isDisabled ? 0.35 : 1.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? primaryColor : context.colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
