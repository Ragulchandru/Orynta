// lib/features/dashboard/presentation/widgets/hero/motivational_message_widget.dart
//
// Orynta 2.0 — Motivational Message Widget Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/motivation_message.dart';

class MotivationalMessageWidget extends StatelessWidget {
  const MotivationalMessageWidget({
    super.key,
    required this.motivationMessage,
  });

  final MotivationMessage motivationMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.06),
        borderRadius: context.radius.borderRadiusMd,
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 20,
            color: context.colors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              motivationMessage.message,
              style: context.typography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
