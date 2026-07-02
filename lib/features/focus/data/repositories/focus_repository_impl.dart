import '../../domain/entities/focus_session_entity.dart';
import '../../domain/repositories/focus_repository.dart';
import '../datasources/focus_local_data_source.dart';
import '../models/focus_session_model.dart';

class FocusRepositoryImpl implements FocusRepository {
  FocusRepositoryImpl(this._dataSource);

  final FocusLocalDataSource _dataSource;

  @override
  Future<List<FocusSessionEntity>> getAllSessions() async {
    final models = await _dataSource.getAllSessions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSession(FocusSessionEntity session) async {
    await _dataSource.saveSession(FocusSessionModel.fromEntity(session));
  }

  @override
  Future<void> deleteSession(String id) async {
    await _dataSource.deleteSession(id);
  }
}
