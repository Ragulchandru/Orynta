// lib/features/planner/domain/services/recurrence_engine.dart
//
// Orynta 2.0 — Recurrence Calculator Engine (Offline-First)

class RecurrenceEngine {
  const RecurrenceEngine._();

  static DateTime? computeNextDueDate(DateTime baseDate, String? recurrenceRule) {
    if (recurrenceRule == null || recurrenceRule.isEmpty) return null;

    final rule = recurrenceRule.trim().toUpperCase();

    if (rule == 'DAILY') {
      return baseDate.add(const Duration(days: 1));
    } else if (rule == 'WEEKDAYS') {
      var next = baseDate.add(const Duration(days: 1));
      while (next.weekday == DateTime.saturday || next.weekday == DateTime.sunday) {
        next = next.add(const Duration(days: 1));
      }
      return next;
    } else if (rule == 'WEEKLY') {
      return baseDate.add(const Duration(days: 7));
    } else if (rule == 'MONTHLY') {
      final year = baseDate.month == 12 ? baseDate.year + 1 : baseDate.year;
      final month = baseDate.month == 12 ? 1 : baseDate.month + 1;
      final day = baseDate.day > 28 ? 28 : baseDate.day;
      return DateTime(year, month, day, baseDate.hour, baseDate.minute);
    } else if (rule == 'YEARLY') {
      return DateTime(baseDate.year + 1, baseDate.month, baseDate.day, baseDate.hour, baseDate.minute);
    } else if (rule.startsWith('CUSTOM:')) {
      final parts = rule.split(':');
      if (parts.length > 1) {
        final days = int.tryParse(parts[1]) ?? 1;
        return baseDate.add(Duration(days: days));
      }
    }

    return baseDate.add(const Duration(days: 1));
  }
}
