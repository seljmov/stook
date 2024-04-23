/// Элемент алгоритма.
class AlgorithmItem {
  final int id;
  final DateTime deadlineDate;
  final int priority;
  final int dependsPriority;
  final List<int> dependsOnTasksIds;

  /// Конструктор элемента алгоритма.
  AlgorithmItem({
    required this.id,
    required this.deadlineDate,
    required this.priority,
    this.dependsPriority = 0,
    required this.dependsOnTasksIds,
  });

  /// Создать копию элемента алгоритма.
  AlgorithmItem copyWith({
    int? id,
    DateTime? deadlineDate,
    int? priority,
    int? dependsPriority,
    List<int>? dependsOnTasksIds,
  }) {
    return AlgorithmItem(
      id: id ?? this.id,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      priority: priority ?? this.priority,
      dependsPriority: dependsPriority ?? this.dependsPriority,
      dependsOnTasksIds: dependsOnTasksIds ?? this.dependsOnTasksIds,
    );
  }
}
