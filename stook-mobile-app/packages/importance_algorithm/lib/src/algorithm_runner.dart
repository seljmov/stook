import 'package:stook_importance_algorithm/main.dart';
import 'package:stook_shared/stook_shared.dart';

/// Интерфейс для реализации алгоритма вычисления наиважнейших задач.
abstract class IAlgorithmRunner {
  /// Запускает алгоритм вычисления наиважнейших задач, где [tasks] - список задач.
  Future<AlgorithmResult> run(List<TaskEntity> tasks);
}

/// Реализация алгоритма вычисления наиважнейших задач.
class AlgorithmRunner implements IAlgorithmRunner {
  final IAlgorithmDataPreparer _algorithmDataPreparer;
  final IAlgorithmSolver _algorithmSolver;

  /// Создает экземпляр [AlgorithmRunner].
  const AlgorithmRunner({
    required IAlgorithmDataPreparer algorithmDataPreparer,
    required IAlgorithmSolver algorithmSolver,
  })  : _algorithmDataPreparer = algorithmDataPreparer,
        _algorithmSolver = algorithmSolver;

  @override
  Future<AlgorithmResult> run(List<TaskEntity> tasks) async {
    final algorithmItems = _algorithmDataPreparer.getPreparedData(tasks);
    final ids = _algorithmSolver.getMostImportantItems(algorithmItems);

    return AlgorithmResult(
      taskIds: ids,
      calculationTime: DateTime.now(),
    );
  }
}
