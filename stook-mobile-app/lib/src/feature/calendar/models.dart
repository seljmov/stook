import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/enums.dart';

/// День расписания.
class CalendarDayEntity {
  final DateTime date;
  final List<CalendarLessonEntity> lessons;

  const CalendarDayEntity({required this.date, required this.lessons});
}

/// Занятие календаря.
class CalendarLessonEntity {
  final String name;
  final String place;
  final String teacher;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;
  final LessonType type;

  const CalendarLessonEntity({
    required this.name,
    required this.place,
    required this.teacher,
    required this.timeStart,
    required this.timeEnd,
    required this.type,
  });
}
