// lib/features/dashboard/presentation/widgets/dashboard_empty_view.dart
//
// Orynta 2.0 — Dashboard Empty State View

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import 'dashboard_base_state_view.dart';

class DashboardEmptyView extends StatelessWidget {
  const DashboardEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardBaseStateView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.space_dashboard_outlined,
            size: 48,
            color: context.colors.primary.withValues(alpha: 0.8),
          ),
          SizedBox(height: context.spacing.md),
          Text(
            'Your dashboard is ready',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            'As you use Orynta, your workspace will become more personalized.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
