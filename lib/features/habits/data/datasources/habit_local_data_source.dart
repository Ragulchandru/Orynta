import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getAllHabits();
  Future<HabitModel?> getHabitById(String id);
  Future<void> saveHabit(HabitModel model);
  Future<void> deleteHabit(String id);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  HabitLocalDataSourceImpl(this._box);

  final Box<HabitModel> _box;

  @override
  Future<List<HabitModel>> getAllHabits() async {
    return _box.values.toList();
  }

  @override
  Future<HabitModel?> getHabitById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> saveHabit(HabitModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
}
