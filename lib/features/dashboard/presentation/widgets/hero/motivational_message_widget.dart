// lib/features/dashboard/presentation/widgets/hero/motivational_message_widget.dart
//
// Orynta 2.0 — Motivational Message Widget Component (Italic & Animated Fade)

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
    final theme = context.appTheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Container(
        key: ValueKey(motivationMessage.id),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 20,
              color: theme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '"${motivationMessage.message}"',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
