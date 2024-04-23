import 'package:shared_preferences/shared_preferences.dart';

/// Интерфейс хранилища самых важных задач.
abstract class IImportanceTasksStorage {
  /// Получить самые важные задачи.
  Future<List<int>> getMostImportanceTasks();

  /// Сохранить самые важные задачи.
  Future<bool> saveMostImportanceTasks(List<int> tasksIds);

  /// Очистить самые важные задачи.
  Future<bool> clearMostImportanceTasks();

  /// Получить время сохранения самых важных задач.
  Future<DateTime?> getMostImportanceTasksTime();
}

/// Хранилище самых важных задач.
class ImportanceTasksStorage implements IImportanceTasksStorage {
  final String _key = '_most_importance_tasks_key';
  final String _timeKey = '_most_importance_tasks_time_key';

  @override
  Future<bool> clearMostImportanceTasks() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_key);
  }

  @override
  Future<List<int>> getMostImportanceTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksIds = prefs.getStringList(_key);
    return tasksIds?.map((id) => int.parse(id)).toList() ?? [];
  }

  @override
  Future<bool> saveMostImportanceTasks(List<int> tasksIds) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setStringList(
      _key,
      tasksIds.map((id) => id.toString()).toList(),
    );
    if (result) {
      final time = DateTime.now().millisecondsSinceEpoch;
      return await prefs.setInt(_timeKey, time);
    }
    return false;
  }

  @override
  Future<DateTime?> getMostImportanceTasksTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt(_timeKey);
    return time != null ? DateTime.fromMillisecondsSinceEpoch(time) : null;
  }
}
