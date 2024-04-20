import 'algorithm_data_preparer.dart';
import 'algorithm_item.dart';
import 'importance_algorithm.dart';

/// Интерфейс для решателя алгоритма.
abstract class IAlgorithmSolver<T> {
  /// Получить самые важные элементы.
  List<AlgorithmItem> get(
    List<T> items,
    AlgorithmItem Function(T item) getAlgorithmItem, [
    int count = 3,
    DateTime? currentDate,
  ]);
}

/// Решатель алгоритма.
class AlgorithmSolver<T> implements IAlgorithmSolver<T> {
  final IAlgorithmDataPreparer _algorithmDataPreparer;
  final IAlgorithmImportance _algorithmImportance;

  AlgorithmSolver({
    required IAlgorithmDataPreparer algorithmDataPreparer,
    required IAlgorithmImportance algorithmImportance,
  })  : _algorithmDataPreparer = algorithmDataPreparer,
        _algorithmImportance = algorithmImportance;

  @override
  List<AlgorithmItem> get(
    List<T> items,
    AlgorithmItem Function(T item) getAlgorithmItem, [
    int count = 3,
    DateTime? currentDate,
  ]) {
    final preparedData = _algorithmDataPreparer.getPreparedData(
      items,
      getAlgorithmItem,
    );
    return _algorithmImportance.getMostImportantItems(
      preparedData,
      count,
      currentDate,
    );
  }
}
