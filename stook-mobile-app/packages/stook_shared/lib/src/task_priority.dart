import 'package:flutter/material.dart';

/// Приоритет задачи.
enum TaskPriority {
  /// Нужно сделать как можно быстрее.
  A,

  /// Нужно сделать в ближайшее время.
  B,

  /// Нужно сделать, когда будет свободное время.
  C,
}

/// Расширение для [TaskPriority].
extension TaskPriorityExtension on TaskPriority {
  /// Возвращает название приоритета.
  String get name {
    switch (this) {
      case TaskPriority.A:
        return 'A';
      case TaskPriority.B:
        return 'B';
      case TaskPriority.C:
        return 'C';
      default:
        throw Exception('Unknown task priority: $this');
    }
  }

  /// Возвращает описание приоритета.
  String get description {
    switch (this) {
      case TaskPriority.A:
        return 'Очень важно сделать задачу приоритета "A" как можно быстрее (важно и срочно)';
      case TaskPriority.B:
        return 'Важно сделать задачу приоритета "B" в ближайшее время (важно, но не срочно)';
      case TaskPriority.C:
        return 'Важно сделать задачу приоритета "C" когда будет свободное время (не важно, но срочно)';
      default:
        throw Exception('Unknown task priority: $this');
    }
  }

  /// Возвращает цвет приоритета.
  Color get color {
    switch (this) {
      case TaskPriority.A:
        return Colors.redAccent;
      case TaskPriority.B:
        return Colors.blueAccent;
      case TaskPriority.C:
        return Colors.green;
      default:
        throw Exception('Unknown task priority: $this');
    }
  }

  /// Возвращает числовое значение приоритета.
  int get toPriorityNumber {
    switch (this) {
      case TaskPriority.A:
        return 9;
      case TaskPriority.B:
        return 6;
      case TaskPriority.C:
        return 3;
      default:
        throw Exception('Unknown task priority: $this');
    }
  }
}
