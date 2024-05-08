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

    final taskPriorityById = _getTaskPriorityById2(tasks);

    final taskStatusById = Map<int, TaskStatus>.fromIterable(
      data,
      key: (task) => task.id,
      value: (task) => task.status,
    );

    // Получить задачи, которые можно планировать, то есть
    // 1. В статусе "Создана" или "В процессе".
    // 2. Не имеют подзадач в статусе "Создана" или "В процессе".
    // 3. Не зависят от задач, находящихся в статусе "Создана" или "В процессе".
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

  /// Получить приоритет задачи по идентификатору, где [tasks] - задачи для подсчета приоритета.
  ///
  /// Работает по принципу:
  /// 1. Если у задачи (А) есть подзадачи, то к каждой подзадаче в приоритет зависимости добавляется приоритет задачи А.
  /// 2. Если у задачи (А) есть задачи, от которых она зависит, то к каждой задаче, от которой зависит задача А, в приоритет зависимости добавляется приоритет задачи А.
  ///
  /// Возвращает [Map], где ключ - идентификатор задачи, значение - приоритет задачи.
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

  Map<int, int> _getTaskPriorityById2(List<TaskEntity> tasks) {
    final taskPriorityById = <int, int>{
      for (final task in tasks) task.id: task.priority!.toPriorityNumber,
    };

    final dependOnTasksById = <int, List<int>>{};

    for (final task in tasks) {
      for (final dependOnId in task.dependOnTasksIds) {
        dependOnTasksById.putIfAbsent(dependOnId, () => []);
        dependOnTasksById[dependOnId]!.add(task.id);
      }

      for (final subtaskId in task.subtasksIds) {
        dependOnTasksById.putIfAbsent(subtaskId, () => []);
        dependOnTasksById[subtaskId]!.add(task.id);
      }
    }

    for (final dependOnTasks in dependOnTasksById.entries) {
      final taskId = dependOnTasks.key;
      taskPriorityById[taskId] = dependOnTasks.value.fold<int>(
        0,
        (sum, id) => sum + (taskPriorityById[id] ?? 0),
      );
    }

    return taskPriorityById;
  }
}
