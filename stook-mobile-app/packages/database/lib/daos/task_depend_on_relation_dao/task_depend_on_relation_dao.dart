import 'package:drift/drift.dart';

import '../../database_context.dart';
import '../../models/task_depend_on_relation.dart';

part 'task_depend_on_relation_dao.g.dart';

/// DAO для таблицы зависимостей задач.
@DriftAccessor(tables: [TaskDependOnRelations])
class TaskDependOnRelationsDao extends DatabaseAccessor<DatabaseContext>
    with _$TaskDependOnRelationsDaoMixin {
  TaskDependOnRelationsDao(super.db);

  /// Получить все зависимости задач.
  Future<List<int>> getTaskDependOnRelations(int taskId) async {
    final relations = await (select(taskDependOnRelations)
          ..where((t) => t.taskId.equals(taskId)))
        .get();
    return relations.map((e) => e.dependOnTaskId).toList();
  }

  /// Удалить зависимости задач.
  Future<void> deleteTaskDependOnRelations(int taskId) async {
    await (delete(taskDependOnRelations)..where((t) => t.taskId.equals(taskId)))
        .go();
  }
}
