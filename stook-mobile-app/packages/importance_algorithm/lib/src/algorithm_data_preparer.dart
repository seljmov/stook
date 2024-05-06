// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:stook_shared/stook_shared.dart';

import 'algorithm_item.dart';

/// Интерфейс для подготовки данных для алгоритма.
abstract class IAlgorithmDataPreparer {
  /// Подготовить данные для алгоритма.
  List<AlgorithmItem> getPreparedData(List<TaskEntity> data);
}

/// Подготовка данных для алгоритма.
class AlgorithmDataPreparer implements IAlgorithmDataPreparer {
  @override
  List<AlgorithmItem> getPreparedData(List<TaskEntity> data) {
    final tasks = data
        .where((task) => task.deadlineDate != null && task.priority != null)
        .toList();

    final taskPriorityById = _getTaskPriorityById(tasks);

    final taskStatusById = Map<int, TaskStatus>.fromIterable(
      data,
      key: (task) => task.id,
      value: (task) => task.status,
    );

    final algorithmItems = tasks
        .where((task) =>
            planningStatuses.contains(task.status) &&
            (task.subtasksIds.isEmpty ||
                task.subtasksIds.every((subtaskId) =>
                    !planningStatuses.contains(taskStatusById[subtaskId]))) &&
            (task.dependOnTasksIds.isEmpty ||
                task.dependOnTasksIds.every((dependOnId) =>
                    !planningStatuses.contains(taskStatusById[dependOnId]))))
        .map((task) => AlgorithmItem(
              id: task.id,
              deadlineDate: task.deadlineDate!,
              priority: task.priority!.toPriorityNumber,
              dependsPriority: taskPriorityById[task.id] ?? 0,
            ))
        .toList();

    return algorithmItems;
  }

  /// Получить приоритет задачи по идентификатору.
  /// [tasks] - задачи для подсчета приоритета.
  Map<int, int> _getTaskPriorityById(List<TaskEntity> tasks) {
    final tasksById = Map<int, TaskEntity>.fromIterable(
      tasks,
      key: (task) => task.id,
      value: (task) => task,
    );

    final taskPriorityById = Map<int, int>.fromIterable(
      tasks,
      key: (task) => task.id,
      value: (task) => 0,
    );

    for (final task in tasks) {
      var summa = taskPriorityById[task.id] ?? 0;
      summa += task.priority!.toPriorityNumber;

      final mergeIds = Set<int>.from(task.subtasksIds)
        ..addAll(task.dependOnTasksIds);

      for (final id in mergeIds) {
        final mergeTask = tasksById[id];
        if (mergeTask != null && planningStatuses.contains(mergeTask.status)) {
          var mergeSumma = taskPriorityById[mergeTask.id] ?? 0;
          mergeSumma += summa;
          taskPriorityById[mergeTask.id] = mergeSumma;
        }
      }
    }

    return taskPriorityById;
  }
}
