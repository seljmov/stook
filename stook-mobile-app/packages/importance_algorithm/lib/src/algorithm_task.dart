import 'package:stook_shared/stook_shared.dart';

/// Сущность задачи.
class TaskEntity {
  final int id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime? deadlineDate;
  final TaskPriority? priority;
  final TaskStatus status;
  final List<int> subtasksIds;
  final List<int> dependOnTasksIds;

  /// Создает сущность задачи.
  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.deadlineDate,
    this.priority,
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
}
