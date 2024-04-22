import 'package:flutter/material.dart';

/// Возвращает статусы для планирования.
List<TaskStatus> get planningStatuses =>
    [TaskStatus.pending, TaskStatus.inProgress];

/// Статус задачи.
enum TaskStatus {
  /// Задача создана, но еще не начата.
  pending,

  /// Задача в процессе выполнения.
  inProgress,

  /// Задача завершена.
  completed,

  /// Задача просрочена.
  overdue,
}

/// Расширение для работы с перечислением [TaskStatus].
extension TaskStatusExtension on TaskStatus {
  /// Возвращает строковое представление перечисления.
  String get name {
    switch (this) {
      case TaskStatus.pending:
        return 'Создана';
      case TaskStatus.inProgress:
        return 'В процессе';
      case TaskStatus.completed:
        return 'Завершена';
      case TaskStatus.overdue:
        return 'Просрочена';
      default:
        throw Exception('Unknown task status: $this');
    }
  }

  /// Возвращает цвет для перечисления.
  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.overdue:
        return Colors.red;
      default:
        throw Exception('Unknown task status: $this');
    }
  }
}
