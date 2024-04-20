import 'algorithm_item.dart';

/// Интерфейс для алгоритма важности.
abstract class IAlgorithmImportance {
  /// Получить самые важные элементы.
  List<AlgorithmItem> getMostImportantItems(
    List<AlgorithmItem> items, [
    int count = 3,
    DateTime? currentDate,
  ]);
}

/// Алгоритм важности.
class AlgorithmImportance implements IAlgorithmImportance {
  @override
  List<AlgorithmItem> getMostImportantItems(List<AlgorithmItem> items,
      [int count = 3, DateTime? currentDate]) {
    if (items.isEmpty) {
      return [];
    }
    if (items.length <= count) {
      return items;
    }

    currentDate ??= DateTime.now();
    final algorithmItems = _getAlgorithmItemsWithImportance(items, currentDate);
    final sortedItems = algorithmItems.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return sortedItems.take(count).map((e) => e.value).toList();
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
    return (item.priority + item.dependsPriority) /
        (_findSecondsBetweenDates(now, item.deadlineDate) + 1);
  }

  /// Получить разницу между датами в секундах
  int _findSecondsBetweenDates(DateTime first, DateTime second) {
    return second.difference(first).inSeconds;
  }
}
