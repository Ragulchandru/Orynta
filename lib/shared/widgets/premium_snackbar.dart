// lib/shared/widgets/premium_snackbar.dart
//
// Orynta 2.0 — Custom premium snackbar controller helper

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final theme = context.appTheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: context.typography.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: isError ? theme.error : theme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
