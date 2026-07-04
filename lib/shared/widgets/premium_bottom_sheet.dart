// lib/shared/widgets/premium_bottom_sheet.dart
//
// Orynta 2.0 — Custom premium bottom sheet wrapper

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({
    super.key,
    required this.child,
    this.title,
  });

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        border: Border.all(color: theme.outlineVariant, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: theme.outlineVariant,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                title!,
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
