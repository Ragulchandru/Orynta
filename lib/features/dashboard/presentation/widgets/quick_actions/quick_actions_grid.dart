// lib/features/dashboard/presentation/widgets/quick_actions/quick_actions_grid.dart
//
// Orynta 2.0 — Quick Actions Grid Component

import 'package:flutter/material.dart';
import '../../../domain/models/quick_action.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  final List<QuickAction> actions;
  final void Function(QuickAction action) onActionTap;

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 2;
    if (screenWidth < 1000) return 4;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: screenWidth < 400 ? 1.05 : 1.25,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return QuickActionCard(
          action: action,
          onTap: () => onActionTap(action),
        );
      },
    );
  }
}
