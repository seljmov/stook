/// Элемент алгоритма.
class AlgorithmItem {
  final int id;
  final DateTime deadlineDate;
  final int priority;
  final int dependsPriority;

  /// Конструктор элемента алгоритма.
  AlgorithmItem({
    required this.id,
    required this.deadlineDate,
    required this.priority,
    this.dependsPriority = 0,
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
    );
  }
}
