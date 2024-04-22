import 'package:stook_database/models/enums/enums.dart';

/// Базовая сущность задачи.
class TaskBaseEntity {
  final int id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime? deadlineDate;
  final TaskPriority? priority;
  final TaskStatus status;

  /// Создает базовую сущность задачи.
  TaskBaseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.deadlineDate,
    this.priority,
    required this.status,
  });

  /// Создает копию базовой сущности задачи с измененными полями.
  TaskBaseEntity copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return TaskBaseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate,
      deadlineDate: deadlineDate,
      priority: priority,
      status: status,
    );
  }
}
