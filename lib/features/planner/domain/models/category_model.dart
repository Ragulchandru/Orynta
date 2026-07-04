// lib/features/planner/domain/models/category_model.dart
//
// Orynta 2.0 — Planner Category Model

import 'package:flutter/material.dart';

class PlannerCategory {
  const PlannerCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.taskCount = 0,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int taskCount;

  static List<PlannerCategory> get builtInCategories => const [
        PlannerCategory(
          id: 'Work',
          name: 'Work',
          icon: Icons.work_rounded,
          color: Colors.blue,
        ),
        PlannerCategory(
          id: 'Personal',
          name: 'Personal',
          icon: Icons.person_rounded,
          color: Colors.purple,
        ),
        PlannerCategory(
          id: 'Study',
          name: 'Study',
          icon: Icons.school_rounded,
          color: Colors.orange,
        ),
        PlannerCategory(
          id: 'Health',
          name: 'Health',
          icon: Icons.favorite_rounded,
          color: Colors.red,
        ),
        PlannerCategory(
          id: 'Shopping',
          name: 'Shopping',
          icon: Icons.shopping_cart_rounded,
          color: Colors.green,
        ),
        PlannerCategory(
          id: 'Finance',
          name: 'Finance',
          icon: Icons.account_balance_wallet_rounded,
          color: Colors.teal,
        ),
      ];
}
