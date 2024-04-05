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
}
