import 'package:flutter/material.dart';

/// Тип занятия.
enum LessonType {
  /// Лекция.
  lecture,

  /// Практика.
  practice,

  /// Лабораторная работа.
  lab,

  /// Другое.
  other,
}

/// Расширение для работы с перечислением [LessonType].
extension LessonTypeX on LessonType {
  /// Возвращает строковое представление перечисления [LessonType].
  String get name {
    switch (this) {
      case LessonType.lecture:
        return 'Лекция';
      case LessonType.practice:
        return 'Практика';
      case LessonType.lab:
        return 'Лабораторная работа';
      case LessonType.other:
        return 'Другое';
      default:
        throw ArgumentError('Unknown lesson type: $this');
    }
  }

  /// Возвращает цвет для отображения типа занятия.
  Color get color {
    switch (this) {
      case LessonType.lecture:
        return Colors.blue;
      case LessonType.practice:
        return Colors.green;
      case LessonType.lab:
        return Colors.orange;
      case LessonType.other:
        return Colors.grey;
      default:
        throw ArgumentError('Unknown lesson type: $this');
    }
  }
}
