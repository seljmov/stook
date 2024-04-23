import 'package:drift/drift.dart';

import '../../database_context.dart';
import '../../models/task_subtask_relation.dart';

part 'task_subtask_relation_dao.g.dart';

/// DAO для таблицы зависимостей задач.
@DriftAccessor(tables: [TaskSubtaskRelations])
class TaskSubtaskRelationsDao extends DatabaseAccessor<DatabaseContext>
    with _$TaskSubtaskRelationsDaoMixin {
  TaskSubtaskRelationsDao(super.db);

  /// Получить все зависимости задач.
  Future<List<int>> getTaskSubtaskRelations(int taskId) async {
    final relations = await (select(taskSubtaskRelations)
          ..where((t) => t.taskId.equals(taskId)))
        .get();
    return relations.map((e) => e.subtaskId).toList();
  }

  /// Вставить зависимость задач.
  Future<int> insertTaskSubtaskRelation(TaskSubtaskRelation relation) =>
      into(taskSubtaskRelations).insert(relation);

  /// Вставить список зависимостей задач.
  Future<void> insertTaskSubtaskRelations(
          List<TaskSubtaskRelation> relations) =>
      batch((batch) => batch.insertAll(taskSubtaskRelations, relations));

  /// Удалить зависимости задач.
  Future<void> deleteTaskSubtaskRelations(int taskId) async {
    await (delete(taskSubtaskRelations)..where((t) => t.taskId.equals(taskId)))
        .go();
  }
}
