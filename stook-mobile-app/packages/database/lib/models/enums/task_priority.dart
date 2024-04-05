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
        return 'Нужно сделать как можно быстрее';
      case TaskPriority.B:
        return 'Нужно сделать в ближайшее время';
      case TaskPriority.C:
        return 'Нужно сделать, когда будет свободное время';
      default:
        throw Exception('Unknown task priority: $this');
    }
  }
}
