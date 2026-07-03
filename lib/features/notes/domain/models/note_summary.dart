// lib/features/notes/domain/models/note_summary.dart
//
// Orynta 2.0 — Note Summary Domain Entity

import 'package:flutter/foundation.dart';

@immutable
class NoteSummary {
  const NoteSummary({
    required this.id,
    required this.title,
    required this.preview,
    required this.updatedAt,
    this.colorHex,
    required this.isPinned,
    required this.isFavorite,
    required this.isArchived,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime updatedAt;
  final String? colorHex;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;

  /// Returns friendly relative timestamp ("Just now", "12 min ago", etc.).
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else {
      final days = difference.inDays;
      return '$days days ago';
    }
  }

  /// Returns note preview or default text if empty.
  String get previewText {
    if (preview.trim().isEmpty) return 'No additional text';
    return preview;
  }
}
