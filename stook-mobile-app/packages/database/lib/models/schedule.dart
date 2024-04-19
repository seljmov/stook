import 'package:drift/drift.dart';

/// Таблица расписания.
@DataClassName('Schedule')
class Schedules extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Признак активности.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
}
