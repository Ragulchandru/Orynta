import 'package:hive_flutter/hive_flutter.dart';
import '../models/focus_session_model.dart';

abstract class FocusLocalDataSource {
  Future<List<FocusSessionModel>> getAllSessions();
  Future<void> saveSession(FocusSessionModel session);
  Future<void> deleteSession(String id);
}

class FocusLocalDataSourceImpl implements FocusLocalDataSource {
  FocusLocalDataSourceImpl(this._box);

  final Box<FocusSessionModel> _box;

  @override
  Future<List<FocusSessionModel>> getAllSessions() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveSession(FocusSessionModel session) async {
    await _box.put(session.id, session);
  }

  @override
  Future<void> deleteSession(String id) async {
    await _box.delete(id);
  }
}
