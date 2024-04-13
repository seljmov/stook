import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/enums.dart';

/// Неделя расписания.
class WeekEntity {
  /// Номер недели.
  int number;

  /// Скрыта ли неделя.
  bool isHidden;

  /// Дни недели.
  final List<DayEntity> days;

  /// Конструктор.
  WeekEntity({
    required this.number,
    this.isHidden = false,
    List<DayEntity>? days,
  }) : days = days ?? [];

  /// Неделя корректна, если в ней содежится хотя бы одно занятие.
  bool get isCorrect => days.any((day) => day.lessons.isNotEmpty);
}

/// День недели.
class DayEntity {
  /// Номер дня недели.
  final DayOfWeek dayOfWeek;

  /// Занятия дня.
  final List<LessonEntity> lessons;

  /// Конструктор.
  DayEntity({
    required this.dayOfWeek,
    List<LessonEntity>? lessons,
  }) : lessons = lessons ?? [];

  /// Добавить занятие.
  void addLesson() {
    lessons.add(const LessonEntity());
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
class LessonEntity {
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
  const LessonEntity({
    this.id = 0,
    this.name = 'Занятие',
    this.place = '',
    this.teacher = '',
    this.timeStart = const TimeOfDay(hour: 8, minute: 30),
    this.timeEnd = const TimeOfDay(hour: 10, minute: 0),
    this.type = LessonType.lecture,
  });

  /// Копировать занятие с изменением указанных полей.
  LessonEntity copyWith({
    int? id,
    String? name,
    String? place,
    String? teacher,
    TimeOfDay? timeStart,
    TimeOfDay? timeEnd,
    LessonType? type,
  }) {
    return LessonEntity(
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
