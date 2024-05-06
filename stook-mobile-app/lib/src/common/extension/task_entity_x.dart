import 'package:stook_database/database_context.dart';
import 'package:stook_shared/stook_shared.dart';

/// Расширение для сущности задачи.
extension TaskEntityX on TaskEntity {
  /// Создает сущность задачи из базы данных.
  TasksCompanion toTaskCompanion() {
    return toTask().toCompanion(false);
  }

  /// Создает сущность задачи из базы данных.
  Task toTask() {
    return Task(
      id: id,
      title: title,
      description: description,
      createdDate: createdDate,
      deadlineDate: deadlineDate,
      priority: priority,
      status: status,
    );
  }
}
