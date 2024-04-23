import 'package:drift/drift.dart';
import 'package:stook_database/models/enums/enums.dart';

/// Таблица задач.
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
  IntColumn get priority => intEnum<TaskPriority>().nullable()();

  /// Статус.
  IntColumn get status => intEnum<TaskStatus>()();
}
