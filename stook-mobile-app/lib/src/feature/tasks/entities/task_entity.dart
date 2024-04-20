import 'package:stook_database/database_context.dart';
import 'package:stook_database/models/enums/enums.dart';

import 'task_base_entity.dart';

/// Сущность задачи.
class TaskEntity {
  final int id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime deadlineDate;
  final TaskPriority priority;
  final TaskStatus status;
  final List<int> subtasksIds;
  final List<int> dependOnTasksIds;

  /// Создает сущность задачи.
  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.deadlineDate,
    required this.priority,
    required this.status,
    this.subtasksIds = const [],
    this.dependOnTasksIds = const [],
  });

  /// Создает копию сущности задачи с измененными полями.
  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdDate,
    DateTime? deadlineDate,
    TaskPriority? priority,
    TaskStatus? status,
    List<int>? subtasksIds,
    List<int>? dependOnTasksIds,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subtasksIds: subtasksIds ?? this.subtasksIds,
      dependOnTasksIds: dependOnTasksIds ?? this.dependOnTasksIds,
    );
  }

  /// Создает базовую сущность задачи.
  TaskBaseEntity toBaseEntity() {
    return TaskBaseEntity(
      id: id,
      title: title,
      description: description,
      createdDate: createdDate,
      deadlineDate: deadlineDate,
      priority: priority,
      status: status,
    );
  }

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
