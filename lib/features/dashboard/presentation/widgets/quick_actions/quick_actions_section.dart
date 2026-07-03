// lib/features/dashboard/presentation/widgets/quick_actions/quick_actions_section.dart
//
// Orynta 2.0 — Quick Actions Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/quick_actions_providers.dart';
import 'quick_actions_grid.dart';

class QuickActionsSection extends ConsumerWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickActionsControllerProvider);
    final controller = ref.read(quickActionsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            children: [
              Icon(
                Icons.flash_on_outlined,
                size: 20,
                color: context.colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: context.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Grid Content
        if (!state.isLoading)
          QuickActionsGrid(
            actions: state.actions,
            onActionTap: (action) => controller.onActionTap(action, context),
          ),
      ],
    );
  }
}
