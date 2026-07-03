// lib/features/dashboard/domain/models/recent_note_summary.dart
//
// Orynta 2.0 — Recent Note Summary Domain Entity

import 'package:flutter/foundation.dart';

@immutable
class RecentNoteSummary {
  const RecentNoteSummary({
    required this.id,
    required this.title,
    required this.preview,
    required this.updatedAt,
    this.colorHex,
    this.isPinned = false,
    this.isFavorite = false,
    this.tags = const [],
    this.folderName,
    this.hasAttachments = false,
    this.aiSummary,
    this.isShared = false,
    this.isLocked = false,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime updatedAt;
  final String? colorHex;
  final bool isPinned;
  final bool isFavorite;
  final List<String> tags;
  final String? folderName;
  final bool hasAttachments;
  final String? aiSummary;
  final bool isShared;
  final bool isLocked;

  /// Returns friendly relative timestamp ("Just now", "12 min ago", "1 hour ago", "Yesterday", "2 days ago").
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
}
