import '../entities/focus_session_entity.dart';

abstract class FocusRepository {
  Future<List<FocusSessionEntity>> getAllSessions();
  Future<void> saveSession(FocusSessionEntity session);
  Future<void> deleteSession(String id);
}
