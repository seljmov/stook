import 'algorithm_item.dart';

/// Интерфейс для подготовки данных для алгоритма.
abstract class IAlgorithmDataPreparer {
  /// Подготовить данные для алгоритма.
  /// [data] - данные для подготовки.
  /// [getAlgorithmItem] - функция, которая преобразует элемент данных в [AlgorithmItem].
  List<AlgorithmItem> getPreparedData<T>(
    List<T> data,
    AlgorithmItem Function(T item) getAlgorithmItem,
  );
}

/// Подготовка данных для алгоритма.
class AlgorithmDataPreparer implements IAlgorithmDataPreparer {
  @override
  List<AlgorithmItem> getPreparedData<T>(
    List<T> data,
    AlgorithmItem Function(T item) getAlgorithmItem,
  ) {
    final List<AlgorithmItem> convertedItems =
        data.map(getAlgorithmItem).toList();
    final itemsDependsPriorities = _getTasksDependsPriorities(convertedItems);
    final itemsForPlanning = _getTasksForPlanning(convertedItems).toList();

    return itemsForPlanning
        .map((item) => item.copyWith(
            dependsPriority: itemsDependsPriorities[item.id] ?? 0))
        .toList();
  }

  /// Получить данные, которые можно запланировать
  List<AlgorithmItem> _getTasksForPlanning(List<AlgorithmItem> tasks) {
    final tasksIds = tasks.map((task) => task.id);
    return tasks
        .where((task) =>
            task.dependsOnTasksIds.where((id) => tasksIds.contains(id)).isEmpty)
        .toList();
  }

  /// Получить идентификаторы заказов, от которых зависят другие заказы с их приоритетом зависимости
  Map<int, int> _getTasksDependsPriorities(List<AlgorithmItem> tasks) {
    final taskByTaskIdMap = Map<int, AlgorithmItem>.fromIterable(
      tasks,
      key: (task) => task.id,
    );
    final dependsIdsByTaskId = tasks
        .where((task) => task.dependsOnTasksIds.isNotEmpty)
        .map((task) => (task.id, task.dependsOnTasksIds))
        .toList();
    final revertedDependsIdsByTaskId = <int, List<int>>{};
    for (var entry in dependsIdsByTaskId) {
      var taskId = entry.$1;
      var dependsIds = entry.$2;

      for (var dependId in dependsIds) {
        revertedDependsIdsByTaskId.putIfAbsent(dependId, () => []);
        revertedDependsIdsByTaskId[dependId]!.add(taskId);
      }
    }

    final dependsPrioritiesByTaskId = <int, int>{};
    for (var entry in revertedDependsIdsByTaskId.entries) {
      var taskId = entry.key;
      var dependsIds = entry.value;

      var dependsPriorities = dependsIds
          .map((dependId) => taskByTaskIdMap[dependId]!.priority)
          .toList();
      var sumDependsPriority = dependsPriorities.isNotEmpty
          ? dependsPriorities.reduce((a, b) => a + b)
          : 0;

      dependsPrioritiesByTaskId[taskId] = sumDependsPriority;
    }

    return dependsPrioritiesByTaskId;
  }
}
