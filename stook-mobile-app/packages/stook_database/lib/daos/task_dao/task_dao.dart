import 'package:drift/drift.dart';
import 'package:stook_shared/stook_shared.dart';

import '../../database_context.dart';
import '../../models/task.dart';

part 'task_dao.g.dart';

/// DAO для работы с задачами.
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<DatabaseContext> with _$TasksDaoMixin {
  TasksDao(super.db);

  /// Получить все задачи.
  Future<List<Task>> getAllTasks() async {
    await transaction(() async {
      final needUpdateTasks = await (select(tasks)
            ..where((t) => t.deadlineDate.isSmallerThanValue(DateTime.now())))
          .get();
      for (final task in needUpdateTasks) {
        await updateTask(task.copyWith(status: TaskStatus.overdue));
      }
    });

    return select(tasks).get();
  }

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
