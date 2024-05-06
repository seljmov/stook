import 'algorithm_item.dart';

/// Интерфейс для алгоритма важности.
abstract class IAlgorithmSolver {
  /// Получить самые важные элементы.
  List<int> getMostImportantItems(
    List<AlgorithmItem> items, [
    int count = 3,
    DateTime? currentDate,
  ]);
}

/// Алгоритм важности.
class AlgorithmSolver implements IAlgorithmSolver {
  @override
  List<int> getMostImportantItems(List<AlgorithmItem> items,
      [int count = 3, DateTime? currentDate]) {
    if (items.isEmpty) {
      return [];
    }
    if (items.length <= count) {
      return items.map((e) => e.id).toList();
    }

    currentDate ??= DateTime.now();
    final algorithmItems = _getAlgorithmItemsWithImportance(items, currentDate);
    final sortedItems = algorithmItems.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return sortedItems.take(count).map((e) => e.value.id).toList();
  }

  /// Получить самые важные элементы.
  Map<double, AlgorithmItem> _getAlgorithmItemsWithImportance(
    List<AlgorithmItem> algorithmItems,
    DateTime now,
  ) {
    return {
      for (final item in algorithmItems) _calculateImportance(item, now): item
    };
  }

  /// Получить важность задачи
  double _calculateImportance(AlgorithmItem item, DateTime now) {
    return (item.priority * (item.dependsPriority + 1)) /
        (_findSecondsBetweenDates(now, item.deadlineDate) + 1);
  }

  /// Получить разницу между датами в секундах
  int _findSecondsBetweenDates(DateTime first, DateTime second) {
    return second.difference(first).inSeconds;
  }
}
