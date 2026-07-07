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

  PlannerCategory copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    int? taskCount,
  }) {
    return PlannerCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      taskCount: taskCount ?? this.taskCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon.codePoint,
        'color': color.toARGB32(),
      };

  factory PlannerCategory.fromJson(Map<String, dynamic> json) {
    return PlannerCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      // ignore: non_const_argument_for_const_parameter
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
    );
  }

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
