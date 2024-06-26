import 'package:injector/injector.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_importance_algorithm/main.dart';

import '../../feature/calendar/bloc/calendar_bloc.dart';
import '../../feature/notes/bloc/note_bloc.dart';
import '../../feature/resources/bloc/resource_bloc.dart';
import '../../feature/schedule_put/bloc/schedule_put_bloc.dart';
import '../../feature/tasks/bloc/task_bloc.dart';
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
    injector.registerDependency<IAlgorithmSolver>(
      () => AlgorithmSolver(),
    );
    injector.registerDependency<IImportanceTasksStorage>(
      () => ImportanceTasksStorage(),
    );
    injector.registerDependency<IAlgorithmRunner>(
      () => AlgorithmRunner(
        algorithmDataPreparer: injector.get<IAlgorithmDataPreparer>(),
        algorithmSolver: injector.get<IAlgorithmSolver>(),
      ),
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
        algorithmRunner: injector.get<IAlgorithmRunner>(),
      ),
    );
    injector.registerDependency<INoteBloc>(
      () => NoteBloc(databaseContext: injector.get<DatabaseContext>()),
    );
    injector.registerDependency<IResourceBloc>(
      () => ResourceBloc(databaseContext: injector.get<DatabaseContext>()),
    );
  }
}
