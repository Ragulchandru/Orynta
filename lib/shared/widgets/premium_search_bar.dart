// lib/shared/widgets/premium_search_bar.dart
//
// Orynta 2.0 — Custom premium search bar input field

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.focusNode,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.notes.searchBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.notes.searchBorder, width: 1.0),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: context.typography.bodyMedium.copyWith(
          color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.typography.bodyMedium.copyWith(
            color: (theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68)).withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
    );
  }
}
