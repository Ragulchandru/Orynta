// lib/features/dashboard/presentation/widgets/dashboard_error_view.dart
//
// Orynta 2.0 — Dashboard Error State View

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import 'dashboard_base_state_view.dart';

class DashboardErrorView extends StatelessWidget {
  const DashboardErrorView({
    super.key,
    this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DashboardBaseStateView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 44,
            color: context.colors.error,
          ),
          SizedBox(height: context.spacing.md),
          Text(
            'Unable to load dashboard',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            errorMessage ?? 'Something went wrong while loading your workspace.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing.lg),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
