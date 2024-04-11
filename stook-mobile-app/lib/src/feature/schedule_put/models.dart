import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/enums.dart';
import 'package:stook_database/database_context.dart' as database;

import '../../common/extension/time_of_day_x.dart';

/// Неделя расписания.
class Week {
  /// Номер недели.
  int number;

  /// Скрыта ли неделя.
  bool isHidden;

  /// Дни недели.
  final List<Day> days;

  /// Конструктор.
  Week({required this.number, this.isHidden = false, List<Day>? days})
      : days = days ?? [];

  /// Неделя не пуста, если все дни содержат хотя бы одно занятие.
  bool get isCorrect => days.every((day) => day.lessons.isNotEmpty);

  /// Преобразовать неделю в список занятий.
  List<database.LessonsCompanion> toLessons() {
    return days.expand((day) {
      return day.lessons.map((lesson) {
        return database.LessonsCompanion.insert(
          title: lesson.name,
          place: lesson.place,
          teacher: lesson.teacher,
          timeStart: lesson.timeStart.toDateTime(),
          timeEnd: lesson.timeEnd.toDateTime(),
          weekNumber: number,
          dayOfWeek: day.dayOfWeek,
          lessonType: lesson.type,
        );
      });
    }).toList();
  }
}

/// День недели.
class Day {
  /// Номер дня недели.
  final DayOfWeek dayOfWeek;

  /// Занятия дня.
  final List<Lesson> lessons;

  /// Конструктор.
  Day({required this.dayOfWeek, List<Lesson>? lessons})
      : lessons = lessons ?? [];

  /// Добавить занятие.
  void addLesson() {
    lessons.add(const Lesson());
  }

  /// Полуить название дня недели.
  String get name {
    switch (dayOfWeek) {
      case DayOfWeek.monday:
        return 'Понедельник';
      case DayOfWeek.tuesday:
        return 'Вторник';
      case DayOfWeek.wednesday:
        return 'Среда';
      case DayOfWeek.thursday:
        return 'Четверг';
      case DayOfWeek.friday:
        return 'Пятница';
      case DayOfWeek.saturday:
        return 'Суббота';
      case DayOfWeek.sunday:
        return 'Воскресенье';
    }
  }
}

/// Занятие.
class Lesson {
  /// Идентификатор занятия.
  final int id;

  /// Название занятия.
  final String name;

  /// Место проведения занятия.
  final String place;

  /// Преподаватель.
  final String teacher;

  /// Время начала занятия.
  final TimeOfDay timeStart;

  /// Время окончания занятия.
  final TimeOfDay timeEnd;

  /// Тип занятия.
  final LessonType type;

  /// Конструктор.
  const Lesson({
    this.id = 0,
    this.name = 'Занятие',
    this.place = '',
    this.teacher = '',
    this.timeStart = const TimeOfDay(hour: 8, minute: 30),
    this.timeEnd = const TimeOfDay(hour: 10, minute: 0),
    this.type = LessonType.lecture,
  });

  /// Копировать занятие с изменением указанных полей.
  Lesson copyWith({
    int? id,
    String? name,
    String? place,
    String? teacher,
    TimeOfDay? timeStart,
    TimeOfDay? timeEnd,
    LessonType? type,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      teacher: teacher ?? this.teacher,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      type: type ?? this.type,
    );
  }

  String get toStr =>
      'Lesson(id: $id, name: $name, place: $place, teacher: $teacher, timeStart: $timeStart, timeEnd: $timeEnd, type: $type)';
}
