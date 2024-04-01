import 'package:drift/drift.dart';

import 'enums/task_priority.dart';

/// Таблица задач.
@DataClassName('Task')
@TableIndex(
  name: 'task_index',
  unique: true,
  columns: {#priority},
)
class Tasks extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Описание.
  TextColumn get description => text()();

  /// Дата создания.
  DateTimeColumn get createdDate => dateTime().nullable()();

  /// Дата последнего изменения.
  DateTimeColumn get deadlineDate => dateTime().nullable()();

  /// Приоритет.
  IntColumn get priority => intEnum<TaskPriority>()();
}
