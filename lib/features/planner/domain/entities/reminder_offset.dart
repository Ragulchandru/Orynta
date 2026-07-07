// lib/features/planner/domain/entities/reminder_offset.dart

enum ReminderOffset {
  none,
  atTime,
  fiveMinutes,
  tenMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  oneDay,
  twoDays,
  oneWeek;

  int? get minutes {
    switch (this) {
      case ReminderOffset.none:
        return null;
      case ReminderOffset.atTime:
        return 0;
      case ReminderOffset.fiveMinutes:
        return 5;
      case ReminderOffset.tenMinutes:
        return 10;
      case ReminderOffset.fifteenMinutes:
        return 15;
      case ReminderOffset.thirtyMinutes:
        return 30;
      case ReminderOffset.oneHour:
        return 60;
      case ReminderOffset.twoHours:
        return 120;
      case ReminderOffset.oneDay:
        return 1440;
      case ReminderOffset.twoDays:
        return 2880;
      case ReminderOffset.oneWeek:
        return 10080;
    }
  }

  String get label {
    switch (this) {
      case ReminderOffset.none:
        return 'None';
      case ReminderOffset.atTime:
        return 'At time';
      case ReminderOffset.fiveMinutes:
        return '5 minutes before';
      case ReminderOffset.tenMinutes:
        return '10 minutes before';
      case ReminderOffset.fifteenMinutes:
        return '15 minutes before';
      case ReminderOffset.thirtyMinutes:
        return '30 minutes before';
      case ReminderOffset.oneHour:
        return '1 hour before';
      case ReminderOffset.twoHours:
        return '2 hours before';
      case ReminderOffset.oneDay:
        return '1 day before';
      case ReminderOffset.twoDays:
        return '2 days before';
      case ReminderOffset.oneWeek:
        return '1 week before';
    }
  }

  static ReminderOffset fromMinutes(int? mins) {
    if (mins == null) return ReminderOffset.none;
    for (final val in ReminderOffset.values) {
      if (val.minutes == mins) {
        return val;
      }
    }
    return ReminderOffset.none;
  }
}
