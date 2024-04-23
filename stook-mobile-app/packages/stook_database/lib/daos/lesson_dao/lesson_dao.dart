import 'package:drift/drift.dart';
import 'package:stook_database/models/lesson.dart';

import '../../database_context.dart';

part 'lesson_dao.g.dart';

/// DAO для работы с занятиями.
@DriftAccessor(tables: [Lessons])
class LessonsDao extends DatabaseAccessor<DatabaseContext>
    with _$LessonsDaoMixin {
  LessonsDao(super.db);

  /// Получить все занятия.
  Future<List<Lesson>> getAllLessons() => select(lessons).get();

  /// Получить занятие по идентификатору.
  Future<Lesson?> getLessonById(int id) =>
      (select(lessons)..where((l) => l.id.equals(id))).getSingleOrNull();

  /// Вставить занятие.
  Future<int> insertLesson(LessonsCompanion lesson) =>
      into(lessons).insert(lesson);

  /// Вставить все занятия.
  Future<void> insertLessonsCompanions(List<LessonsCompanion> lessons) =>
      batch((batch) => batch.insertAll(this.lessons, lessons));

  /// Вставить все занятия.
  Future<void> insertLessons(List<Lesson> lessons) =>
      batch((batch) => batch.insertAll(this.lessons, lessons));

  /// Обновить занятие.
  Future updateLesson(Lesson lesson) => update(lessons).replace(lesson);

  /// Удалить занятие.
  Future deleteLesson(Lesson lesson) => delete(lessons).delete(lesson);

  /// Удалить все занятия.
  Future deleteAllLessons() => delete(lessons).go();
}
