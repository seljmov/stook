import 'package:drift/drift.dart';
import 'package:stook_database/models/task.dart';

import '../../database_context.dart';

part 'task_dao.g.dart';

/// DAO для работы с задачами.
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<DatabaseContext> with _$TasksDaoMixin {
  TasksDao(super.db);

  /// Получить все задачи.
  Future<List<Task>> getAllTasks() => select(tasks).get();

  /// Получить задачу по идентификатору.
  Future<Task?> getTaskById(int id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Вставить задачу.
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  /// Вставить все задачи.
  Future<void> insertTasksCompanions(List<TasksCompanion> tasks) =>
      batch((batch) => batch.insertAll(this.tasks, tasks));

  /// Вставить все задачи.
  Future<void> insertTasks(List<Task> tasks) =>
      batch((batch) => batch.insertAll(this.tasks, tasks));

  /// Обновить задачу.
  Future updateTask(Task task) => update(tasks).replace(task);

  /// Удалить задачу.
  Future deleteTask(Task task) => delete(tasks).delete(task);

  /// Удалить все задачи.
  Future deleteAllTasks() => delete(tasks).go();
}
