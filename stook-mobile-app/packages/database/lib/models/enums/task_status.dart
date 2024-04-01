/// Статус задачи.
enum TaskStatus {
  /// Задача создана, но еще не начата.
  pending,

  /// Задача в процессе выполнения.
  inProgress,

  /// Задача завершена.
  completed,
}

/// Расширение для работы с перечислением [TaskStatus].
extension TaskStatusExtension on TaskStatus {
  /// Возвращает строковое представление перечисления.
  String get name {
    switch (this) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.completed:
        return 'completed';
      default:
        throw Exception('Unknown task status: $this');
    }
  }
}
