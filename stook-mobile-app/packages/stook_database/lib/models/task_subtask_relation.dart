import 'package:drift/drift.dart';

/// Таблица связей задач и подзадач.
class TaskSubtaskRelations extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Идентификатор задачи.
  IntColumn get taskId => integer()();

  /// Идентификатор подзадачи.
  IntColumn get subtaskId => integer()();
}
