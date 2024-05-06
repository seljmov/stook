/// Результат работы алгоритма.
class AlgorithmResult {
  /// Идентификаторы задач.
  final List<int> taskIds;

  /// Время выполнения расчета.
  final DateTime calculationTime;

  const AlgorithmResult({
    required this.taskIds,
    required this.calculationTime,
  });
}
