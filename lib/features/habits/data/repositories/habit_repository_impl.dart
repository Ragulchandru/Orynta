import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._dataSource);

  final HabitLocalDataSource _dataSource;

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    final models = await _dataSource.getAllHabits();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HabitEntity?> getHabitById(String id) async {
    final model = await _dataSource.getHabitById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveHabit(HabitEntity habit) async {
    await _dataSource.saveHabit(HabitModel.fromEntity(habit));
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await _dataSource.saveHabit(HabitModel.fromEntity(habit));
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _dataSource.deleteHabit(id);
  }
}
