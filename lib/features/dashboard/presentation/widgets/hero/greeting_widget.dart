// lib/features/dashboard/presentation/widgets/hero/greeting_widget.dart
//
// Orynta 2.0 — Greeting Widget

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({
    super.key,
    required this.greeting,
    required this.displayName,
  });

  final String greeting;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              greeting,
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '👋',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          displayName,
          style: context.typography.headlineLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
