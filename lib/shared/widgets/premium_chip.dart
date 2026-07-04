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
      backgroundColor: theme.notes.chipBackground,
      selectedColor: theme.notes.chipSelected,
      checkmarkColor: theme.notes.chipTextSelected,
      labelStyle: context.typography.labelMedium.copyWith(
        color: isSelected ? theme.notes.chipTextSelected : theme.notes.chipText,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isSelected ? theme.notes.chipSelected : theme.outlineVariant,
          width: 1.0,
        ),
      ),
    );
  }
}
