// lib/features/dashboard/domain/services/date_service.dart
//
// Orynta 2.0 — Date Formatting Service

class DateService {
  const DateService();

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Returns formatted date string (e.g., "Wednesday, 8 July").
  String getFormattedDate([DateTime? time]) {
    final date = time ?? DateTime.now();
    final weekday = _weekdays[date.weekday - 1];
    final day = date.day;
    final month = _months[date.month - 1];
    return '$weekday, $day $month';
  }
}
