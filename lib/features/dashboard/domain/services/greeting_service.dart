// lib/features/dashboard/domain/services/greeting_service.dart
//
// Orynta 2.0 — Greeting Service

class GreetingService {
  const GreetingService();

  /// Returns time-of-day greeting based on current hour.
  String getGreeting([DateTime? time]) {
    final hour = (time ?? DateTime.now()).hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
