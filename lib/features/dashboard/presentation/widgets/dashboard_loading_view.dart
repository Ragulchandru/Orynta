// lib/features/dashboard/presentation/widgets/dashboard_loading_view.dart
//
// Orynta 2.0 — Dashboard Loading State View (Skeleton)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import 'dashboard_base_state_view.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colors.outlineVariant.withValues(alpha: 0.3);

    return DashboardBaseStateView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: context.radius.borderRadiusSm,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 140,
                height: 18,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: context.radius.borderRadiusSm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: context.radius.borderRadiusSm,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: context.radius.borderRadiusSm,
            ),
          ),
        ],
      ),
    );
  }
}
