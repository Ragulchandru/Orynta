// lib/features/dashboard/domain/models/motivation_message.dart
//
// Orynta 2.0 — Motivation Message Domain Model

import 'package:flutter/foundation.dart';

@immutable
class MotivationMessage {
  const MotivationMessage({
    required this.id,
    required this.message,
    this.author,
  });

  final String id;
  final String message;
  final String? author;
}
