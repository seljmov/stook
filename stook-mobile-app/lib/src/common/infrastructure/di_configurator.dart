import 'package:injector/injector.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_importance_algorithm/main.dart';

import '../../feature/calendar/bloc/calendar_bloc.dart';
import '../../feature/schedule_put/bloc/schedule_put_bloc.dart';
import '../../feature/tasks/bloc/task_bloc.dart';
import '../../feature/tasks/entities/task_entity.dart';
import '../../feature/tasks/repositories/importance_tasks_storage.dart';

/// Глобальный инжектор.
final injector = Injector.appInstance;

/// Конфигуратор для внедрения зависимостей.
class DiConfigurator {
  /// Конфигурирует инжектор.
  static void configure() {
    // Importance algorithm dependencies
    injector.registerDependency<IAlgorithmDataPreparer>(
      () => AlgorithmDataPreparer(),
    );
    injector.registerDependency<IAlgorithmImportance>(
      () => AlgorithmImportance(),
    );
    injector.registerDependency<IAlgorithmSolver<TaskEntity>>(
      () => AlgorithmSolver<TaskEntity>(
        algorithmDataPreparer: injector.get<IAlgorithmDataPreparer>(),
        algorithmImportance: injector.get<IAlgorithmImportance>(),
      ),
    );
    injector.registerDependency<IImportanceTasksStorage>(
      () => ImportanceTasksStorage(),
    );

    injector.registerSingleton<DatabaseContext>(() => DatabaseContext());
    injector.registerDependency<ISchedulePutBloc>(
      () => SchedulePutBloc(databaseContext: injector.get<DatabaseContext>()),
    );
    injector.registerDependency<ICalendarBloc>(
      () => CalendarBloc(databaseContext: injector.get<DatabaseContext>()),
    );
    injector.registerDependency<ITaskBloc>(
      () => TaskBloc(
        databaseContext: injector.get<DatabaseContext>(),
        importanceTasksStorage: injector.get<IImportanceTasksStorage>(),
        algorithmSolver: injector.get<IAlgorithmSolver<TaskEntity>>(),
      ),
    );
  }
}
