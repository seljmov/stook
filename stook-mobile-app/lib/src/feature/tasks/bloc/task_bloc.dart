import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stook_database/database_context.dart';

part 'task_bloc.freezed.dart';

/// Интерфейс блока задач.
abstract class ITaskBloc extends Bloc<TaskEvent, TaskState> {
  ITaskBloc() : super(const TaskState.initial());
}

/// Блок задач.
class TaskBloc extends ITaskBloc {
  final DatabaseContext _databaseContext;

  TaskBloc({
    required DatabaseContext databaseContext,
  }) : _databaseContext = databaseContext {
    on<TaskEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        openPutTask: (event) => _openPutTask(event, emit),
        savePuttedTask: (event) => _savePuttedTask(event, emit),
        deleteTask: (event) => _deleteTask(event, emit),
      ),
    );
  }

  Future<void> _load(
    _TaskLoadEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final tasks = await _databaseContext.tasksDao.getAllTasks();
    emit(const TaskState.loaderHide());
    emit(TaskState.loaded(tasks: tasks));
  }

  Future<void> _openPutTask(
    _TaskOpenPutTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final allTasks = await _databaseContext.tasksDao.getAllTasks();
    emit(TaskState.openPutTaskScreen(task: event.task, allTasks: allTasks));
    emit(const TaskState.loaderHide());
  }

  Future<void> _savePuttedTask(
    _TaskSavePuttedTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final existedTask =
        await _databaseContext.tasksDao.getTaskById(event.task.id);
    if (existedTask != null) {
      await _databaseContext.tasksDao.updateTask(event.task);
    } else {
      await _databaseContext.tasksDao.insertTask(event.task.toCompanion(false));
    }
    final allTasks = await _databaseContext.tasksDao.getAllTasks();
    emit(TaskState.loaded(tasks: allTasks));
    emit(const TaskState.loaderHide());
  }

  Future<void> _deleteTask(
    _TaskDeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _databaseContext.transaction(() async => {
          await _databaseContext.taskDependOnRelationsDao
              .deleteTaskDependOnRelations(event.task.id),
          await _databaseContext.taskSubtaskRelationsDao
              .deleteTaskSubtaskRelations(event.task.id),
          await _databaseContext.tasksDao.deleteTask(event.task),
        });
    final allTasks = await _databaseContext.tasksDao.getAllTasks();
    emit(TaskState.loaded(tasks: allTasks));
  }
}

/// События блока задач.
@freezed
abstract class TaskEvent with _$TaskEvent {
  /// Загрузка задач.
  const factory TaskEvent.load() = _TaskLoadEvent;

  /// Добавление/изменение задачи.
  const factory TaskEvent.openPutTask({
    required Task? task,
  }) = _TaskOpenPutTaskEvent;

  /// Сохранение добавленной/измененной задачи.
  const factory TaskEvent.savePuttedTask({
    required Task task,
  }) = _TaskSavePuttedTaskEvent;

  /// Удаление задачи.
  const factory TaskEvent.deleteTask({
    required Task task,
  }) = _TaskDeleteTaskEvent;
}

/// Состояния блока задач.
@freezed
abstract class TaskState with _$TaskState {
  /// Начальное состояние.
  const factory TaskState.initial() = _TaskInitialState;

  /// Показать загрузчик.
  const factory TaskState.loaderShow() = _TaskLoaderShowState;

  /// Скрыть загрузчик.
  const factory TaskState.loaderHide() = _TaskLoaderHideState;

  /// Загружены данные.
  const factory TaskState.loaded({
    required List<Task> tasks,
  }) = _TaskLoadedState;

  /// Добавлена/изменена задача.
  const factory TaskState.openPutTaskScreen({
    required Task? task,
    required List<Task> allTasks,
  }) = _TaskOpenPutTaskScreenState;
}
