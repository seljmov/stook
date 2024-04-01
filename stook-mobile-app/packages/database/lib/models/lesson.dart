import 'package:drift/drift.dart';

import 'enums/day_of_week.dart';
import 'enums/lesson_type.dart';

/// Таблица занятий.
@DataClassName('Lesson')
@TableIndex(
  name: 'lesson_index',
  unique: true,
  columns: {#number, #weekNumber, #dayOfWeek},
)
class Lessons extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Номер.
  IntColumn get number => integer()();

  /// Номер недели.
  IntColumn get weekNumber => integer()();

  /// День недели.
  IntColumn get dayOfWeek => intEnum<DayOfWeek>()();

  /// Тип занятия.
  IntColumn get lessonType => intEnum<LessonType>()();
}
