import 'package:drift/drift.dart';

/// Таблица заметок.
class Notes extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Содержимое.
  TextColumn get content => text()();

  /// Дата создания.
  DateTimeColumn get createdDate =>
      dateTime().withDefault(currentDateAndTime)();

  /// Дата последнего изменения.
  DateTimeColumn get lastModifiedDate =>
      dateTime().withDefault(currentDateAndTime)();

  /// Признак избранной заметки.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
