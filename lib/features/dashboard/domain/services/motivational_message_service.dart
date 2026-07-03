// lib/features/dashboard/domain/services/motivational_message_service.dart
//
// Orynta 2.0 — Motivational Message Service
//
// Maintains 20 short motivational quotes (< 60 chars) randomized once per day.

import 'dart:math';
import '../models/motivation_message.dart';

class MotivationalMessageService {
  const MotivationalMessageService();

  static const List<MotivationMessage> _quotes = [
    MotivationMessage(id: 'q1', message: 'Stay focused.'),
    MotivationMessage(
      id: 'q2',
      message: 'Small progress every day creates remarkable results.',
    ),
    MotivationMessage(id: 'q3', message: 'Consistency beats intensity.'),
    MotivationMessage(id: 'q4', message: 'One task at a time.'),
    MotivationMessage(
      id: 'q5',
      message: 'Focus on progress, not perfection.',
    ),
    MotivationMessage(
      id: 'q6',
      message: 'Great things are done by a series of small things.',
    ),
    MotivationMessage(
      id: 'q7',
      message: 'Your future self will thank you for today.',
    ),
    MotivationMessage(id: 'q8', message: 'Keep showing up.'),
    MotivationMessage(id: 'q9', message: 'Clarity precedes success.'),
    MotivationMessage(
      id: 'q10',
      message: 'Build momentum with single-tasking.',
    ),
    MotivationMessage(id: 'q11', message: 'Habits shape your identity.'),
    MotivationMessage(id: 'q12', message: 'Make today count.'),
    MotivationMessage(
      id: 'q13',
      message: 'Quiet focus unlocks deep work.',
    ),
    MotivationMessage(id: 'q14', message: 'Small wins add up quickly.'),
    MotivationMessage(
      id: 'q15',
      message: 'Stay curious and persistent.',
    ),
    MotivationMessage(id: 'q16', message: 'Master the present moment.'),
    MotivationMessage(
      id: 'q17',
      message: 'Simple steps lead to grand achievements.',
    ),
    MotivationMessage(
      id: 'q18',
      message: 'Protect your focus and energy.',
    ),
    MotivationMessage(
      id: 'q19',
      message: 'Consistency turns effort into excellence.',
    ),
    MotivationMessage(
      id: 'q20',
      message: 'Organize your mind, elevate your work.',
    ),
  ];

  /// Returns quote seeded by the current day of year (remains stable all day).
  MotivationMessage getDailyQuote([DateTime? time]) {
    final date = time ?? DateTime.now();
    final seed = date.year * 1000 + date.ordinalDay;
    final index = Random(seed).nextInt(_quotes.length);
    return _quotes[index];
  }
}

extension _OrdinalDayExtension on DateTime {
  int get ordinalDay {
    final firstDay = DateTime(year, 1, 1);
    return difference(firstDay).inDays + 1;
  }
}
