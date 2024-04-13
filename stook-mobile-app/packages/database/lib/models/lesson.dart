import 'package:drift/drift.dart';

import 'enums/day_of_week.dart';
import 'enums/lesson_type.dart';

/// Таблица занятий.
@DataClassName('Lesson')
class Lessons extends Table {
  /// Идентификатор.
  IntColumn get id => integer().autoIncrement()();

  /// Название.
  TextColumn get title => text()();

  /// Место проведения.
  TextColumn get place => text()();

  /// Преподаватель.
  TextColumn get teacher => text()();

  /// Время начала.
  DateTimeColumn get timeStart => dateTime()();

  /// Время окончания.
  DateTimeColumn get timeEnd => dateTime()();

  /// Номер недели.
  IntColumn get weekNumber => integer()();

  /// День недели.
  IntColumn get dayOfWeek => intEnum<DayOfWeek>()();

  /// Тип занятия.
  IntColumn get lessonType => intEnum<LessonType>()();
}
