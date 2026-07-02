import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Future<List<HabitEntity>> getAllHabits();
  Future<HabitEntity?> getHabitById(String id);
  Future<void> saveHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(String id);
}
