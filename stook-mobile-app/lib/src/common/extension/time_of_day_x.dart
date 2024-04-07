import 'package:flutter/material.dart';

/// Расширение для TimeOfDay.
extension TimeOfDayX on TimeOfDay {
  /// Возвращает true, если текущее время раньше, чем переданное.
  bool isBefore(TimeOfDay other) {
    return this.hour < other.hour ||
        (this.hour == other.hour && this.minute < other.minute);
  }

  /// Возвращает true, если текущее время позже, чем переданное.
  bool isAfter(TimeOfDay other) {
    return this.hour > other.hour ||
        (this.hour == other.hour && this.minute > other.minute);
  }

  /// Добавляет переданное количество минут к текущему времени.
  TimeOfDay addMinutes(int minutes) {
    final newMinutes = this.minute + minutes;
    final newHour = this.hour + newMinutes ~/ 60;
    return TimeOfDay(hour: newHour, minute: newMinutes % 60);
  }

  /// Сравнивает текущее время с переданным.
  int compareTo(TimeOfDay other) {
    if (this.hour != other.hour) {
      return this.hour - other.hour;
    }
    return this.minute - other.minute;
  }
}
