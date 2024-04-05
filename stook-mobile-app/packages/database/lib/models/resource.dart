import 'package:drift/drift.dart';

import 'enums/resource_type.dart';

/// Таблица ресурсов.
@DataClassName('Resource')
@TableIndex(
  name: 'resource_index',
  unique: true,
  columns: {#isFavorite},
)
class Resources extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Описание.
  TextColumn get description => text().nullable()();

  /// URL.
  TextColumn get url => text().nullable()();

  /// Тип ресурса.
  IntColumn get type => intEnum<ResourceType>()();

  /// Дата создания.
  DateTimeColumn get createdDate =>
      dateTime().withDefault(currentDateAndTime)();

  /// Признак избранного ресурса.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
