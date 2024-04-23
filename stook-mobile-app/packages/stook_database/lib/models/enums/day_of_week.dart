/// День недели.
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Расширение для перечисления дней недели.
extension DayOfWeekExtension on DayOfWeek {
  /// Возвращает строковое представление дня недели.
  String get name {
    switch (this) {
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
      default:
        throw ArgumentError('Unknown day of week: $this');
    }
  }
}
