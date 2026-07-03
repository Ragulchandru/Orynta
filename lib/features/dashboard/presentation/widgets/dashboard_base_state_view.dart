// lib/features/dashboard/presentation/widgets/dashboard_base_state_view.dart
//
// Orynta 2.0 — Dashboard Common Base State View
//
// Shared container framework for loading, empty, and error views.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class DashboardBaseStateView extends StatelessWidget {
  const DashboardBaseStateView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.spacing.paddingHorizontalLg,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 480),
          padding: context.spacing.paddingCard,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
            borderRadius: context.radius.borderRadiusLg,
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: child,
        ),
      ),
    );
  }
}
