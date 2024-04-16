import 'package:drift/drift.dart';

/// Таблица связей задач и подзадач.
@DataClassName('TaskSubtaskRelation')
class TaskSubtaskRelations extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Идентификатор задачи.
  IntColumn get taskId => integer()();

  /// Идентификатор подзадачи.
  IntColumn get subtaskId => integer()();
}
