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
    final hasDependIds = tasks
        .where((task) => task.dependsOnTasksIds.isNotEmpty)
        .map((task) => task.dependsOnTasksIds)
        .reduce((value, element) => value + element);

    // Количество зависимостей для каждого идентификатора
    final dependIdCount = hasDependIds.fold<Map<int, int>>(
      {},
      (map, id) => map..update(id, (value) => value + 1, ifAbsent: () => 1),
    );

    // Идентификаторы заказов, от которых зависят другие заказы с их приоритетом зависимости
    final dependPrioritiesByTaskId = <int, int>{};
    for (final item in dependIdCount.keys) {
      dependPrioritiesByTaskId[item] = dependIdCount[item]! * 2;
    }

    return dependPrioritiesByTaskId;
  }
}
