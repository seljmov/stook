import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/enums.dart';

/// День расписания.
class ScheduleDayEntity {
  final DateTime date;
  final List<ScheduleLessonEntity> lessons;

  const ScheduleDayEntity({required this.date, required this.lessons});
}

/// Занятие календаря.
class ScheduleLessonEntity {
  final String name;
  final String place;
  final String teacher;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;
  final LessonType type;

  const ScheduleLessonEntity({
    required this.name,
    required this.place,
    required this.teacher,
    required this.timeStart,
    required this.timeEnd,
    required this.type,
  });
}
