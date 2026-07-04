// lib/shared/widgets/premium_chip.dart
//
// Orynta 2.0 — Custom premium chip/tag indicator

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumChip extends StatelessWidget {
  const PremiumChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: theme.surfaceContainer,
      selectedColor: theme.primary,
      checkmarkColor: theme.isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF),
      labelStyle: context.typography.labelMedium.copyWith(
        color: isSelected
            ? (theme.isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF))
            : (theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isSelected ? theme.primary : theme.outlineVariant,
          width: 1.0,
        ),
      ),
    );
  }
}
