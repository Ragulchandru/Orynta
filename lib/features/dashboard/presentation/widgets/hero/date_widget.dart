// lib/features/dashboard/presentation/widgets/hero/date_widget.dart
//
// Orynta 2.0 — Date Widget Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.formattedDate,
  });

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: context.colors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          formattedDate,
          style: context.typography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
