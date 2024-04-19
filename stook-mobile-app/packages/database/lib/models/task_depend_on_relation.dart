import 'package:drift/drift.dart';

/// Таблица связей задач и зависимостей.
@DataClassName('TaskDependOnRelation')
class TaskDependOnRelations extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Идентификатор задачи.
  IntColumn get taskId => integer()();

  /// Идентификатор зависимой задачи.
  IntColumn get dependOnTaskId => integer()();
}
