// lib/features/dashboard/domain/models/productivity_score.dart
//
// Orynta 2.0 — Productivity Score Domain Model

import 'package:flutter/foundation.dart';

@immutable
class ProductivityScore {
  const ProductivityScore({
    this.value,
    this.hasData = false,
    this.label = '--',
    this.subtitle = 'No productivity data yet',
  });

  final int? value;
  final bool hasData;
  final String label;
  final String subtitle;
}
