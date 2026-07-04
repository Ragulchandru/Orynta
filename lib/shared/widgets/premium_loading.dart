// lib/shared/widgets/premium_loading.dart
//
// Orynta 2.0 — Custom premium loading/progress indicator

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumLoading extends StatelessWidget {
  const PremiumLoading({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
            strokeWidth: 3.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: context.typography.bodyMedium.copyWith(
                color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
