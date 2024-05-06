import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_importance_algorithm/main.dart';
import 'package:stook_shared/stook_shared.dart';

import '../../../common/extension/task_entity_x.dart';
import '../repositories/importance_tasks_storage.dart';

part 'task_bloc.freezed.dart';

/// Интерфейс блока задач.
abstract class ITaskBloc extends Bloc<TaskEvent, TaskState> {
  ITaskBloc() : super(const TaskState.initial());
}

/// Блок задач.
class TaskBloc extends ITaskBloc {
  final DatabaseContext _databaseContext;
  final IImportanceTasksStorage _importanceTasksStorage;
  final IAlgorithmRunner _algorithmRunner;

  TaskBloc({
    required DatabaseContext databaseContext,
    required IImportanceTasksStorage importanceTasksStorage,
    required IAlgorithmRunner algorithmRunner,
  })  : _databaseContext = databaseContext,
        _importanceTasksStorage = importanceTasksStorage,
        _algorithmRunner = algorithmRunner {
    on<TaskEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        openPutTask: (event) => _openPutTask(event, emit),
        savePuttedTask: (event) => _savePuttedTask(event, emit),
        deleteTask: (event) => _deleteTask(event, emit),
        changeTaskStatus: (event) => _changeTaskStatus(event, emit),
        runImportanceAlgorithm: (event) => _runImportanceAlgorithm(event, emit),
      ),
    );
  }

  Future<void> _load(
    _TaskLoadEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final entities = await _getBaseTasks();
    final mostImportanceTasksIds =
        await _importanceTasksStorage.getMostImportanceTasks();
    final mostImportanceTasks = entities
        .where((task) => mostImportanceTasksIds.contains(task.id))
        .toList();
    final lastImportanceAlgorithmRunTime =
        await _importanceTasksStorage.getMostImportanceTasksTime();
    emit(const TaskState.loaderHide());
    emit(TaskState.loaded(
      tasks: entities,
      mostImportanceTasks: mostImportanceTasks,
      lastImportanceAlgorithmRunTime: lastImportanceAlgorithmRunTime,
      initialScreenIndex: 0,
    ));
  }

  Future<void> _openPutTask(
    _TaskOpenPutTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final allEntities = await _getTasks();
    final allSubtasksIds = allEntities
        .expand((task) => task.subtasksIds + task.dependOnTasksIds)
        .toSet()
        .toList();
    final entities = (await _getTasks())
        .where((task) =>
            planningStatuses.contains(task.status) ||
            allSubtasksIds.contains(task.id))
        .toList();
    if (event.taskId == null) {
      emit(const TaskState.loaderHide());
      emit(TaskState.openPutTaskScreen(
        task: null,
        allTasks: entities,
        fromScreenIndex: event.fromScreenIndex,
      ));
      return;
    }
    final taskSubtasks = await _databaseContext.taskSubtaskRelationsDao
        .getTaskSubtaskRelations(event.taskId!);
    final taskDependOns = await _databaseContext.taskDependOnRelationsDao
        .getTaskDependOnRelations(event.taskId!);
    final taskEntity = allEntities
        .firstWhere((task) => task.id == event.taskId)
        .copyWith(subtasksIds: taskSubtasks, dependOnTasksIds: taskDependOns);
    emit(const TaskState.loaderHide());
    emit(TaskState.openPutTaskScreen(
      task: taskEntity,
      allTasks: entities,
      fromScreenIndex: event.fromScreenIndex,
    ));
  }

  Future<void> _savePuttedTask(
    _TaskSavePuttedTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final existedTask =
        await _databaseContext.tasksDao.getTaskById(event.task.id);
    await _databaseContext.transaction(() async {
      if (existedTask != null) {
        var updatedTask = event.task;
        if (event.task.status == TaskStatus.overdue &&
            event.task.deadlineDate != null &&
            event.task.deadlineDate!.isAfter(DateTime.now())) {
          updatedTask = updatedTask.copyWith(status: TaskStatus.pending);
        }
        await _databaseContext.tasksDao.updateTask(updatedTask.toTask());
      } else {
        await _databaseContext.tasksDao
            .insertTask(event.task.toTaskCompanion());
      }

      await _databaseContext.taskDependOnRelationsDao
          .deleteTaskDependOnRelations(event.task.id);
      await _databaseContext.taskSubtaskRelationsDao
          .deleteTaskSubtaskRelations(event.task.id);

      final dependOnrelations =
          event.task.dependOnTasksIds.map((dependOnTaskId) {
        return TaskDependOnRelation(
          id: DateTime.now().millisecondsSinceEpoch + dependOnTaskId,
          taskId: event.task.id,
          dependOnTaskId: dependOnTaskId,
        );
      }).toList();
      final subtaskRelations = event.task.subtasksIds.map((subtaskId) {
        return TaskSubtaskRelation(
          id: DateTime.now().millisecondsSinceEpoch + subtaskId,
          taskId: event.task.id,
          subtaskId: subtaskId,
        );
      }).toList();

      if (dependOnrelations.isNotEmpty) {
        await _databaseContext.taskDependOnRelationsDao
            .insertTaskDependOnRelations(dependOnrelations);
      }
      if (subtaskRelations.isNotEmpty) {
        await _databaseContext.taskSubtaskRelationsDao
            .insertTaskSubtaskRelations(subtaskRelations);
      }
    });
    final entities = await _getBaseTasks();
    final mostImportanceTasksIds =
        await _importanceTasksStorage.getMostImportanceTasks();
    final mostImportanceTasks = entities
        .where((task) => mostImportanceTasksIds.contains(task.id))
        .toList();
    final lastImportanceAlgorithmRunTime =
        await _importanceTasksStorage.getMostImportanceTasksTime();
    emit(const TaskState.loaderHide());
    emit(TaskState.loaded(
      tasks: entities,
      mostImportanceTasks: mostImportanceTasks,
      lastImportanceAlgorithmRunTime: lastImportanceAlgorithmRunTime,
      initialScreenIndex: 0,
    ));
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
          await _databaseContext.tasksDao.deleteTask(event.task.toTask()),
        });
    final entities = await _getBaseTasks();
    final mostImportanceTasksIds =
        await _importanceTasksStorage.getMostImportanceTasks();
    final mostImportanceTasks = entities
        .where((task) => mostImportanceTasksIds.contains(task.id))
        .toList();
    final lastImportanceAlgorithmRunTime =
        await _importanceTasksStorage.getMostImportanceTasksTime();
    emit(TaskState.loaded(
      tasks: entities,
      mostImportanceTasks: mostImportanceTasks,
      lastImportanceAlgorithmRunTime: lastImportanceAlgorithmRunTime,
      initialScreenIndex: event.fromScreenIndex,
    ));
  }

  Future<void> _changeTaskStatus(
    _TaskChangeTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final task = await _databaseContext.tasksDao.getTaskById(event.taskId);
    if (task == null) {
      emit(const TaskState.loaderHide());
      return;
    }
    await _databaseContext.tasksDao
        .updateTask(task.copyWith(status: event.status));
    final entities = await _getBaseTasks();
    final mostImportanceTasksIds =
        await _importanceTasksStorage.getMostImportanceTasks();
    final mostImportanceTasks = entities
        .where((task) => mostImportanceTasksIds.contains(task.id))
        .toList();
    final lastImportanceAlgorithmRunTime =
        await _importanceTasksStorage.getMostImportanceTasksTime();
    emit(const TaskState.loaderHide());
    emit(TaskState.loaded(
      tasks: entities,
      mostImportanceTasks: mostImportanceTasks,
      lastImportanceAlgorithmRunTime: lastImportanceAlgorithmRunTime,
      initialScreenIndex: event.fromScreenIndex,
    ));
  }

  Future<void> _runImportanceAlgorithm(
    _TaskRunImportanceAlgorithmEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loaderShow());
    final tasks = await _getTasks();
    final algorithmResult = await _algorithmRunner.run(tasks);
    if (algorithmResult.taskIds.isNotEmpty) {
      await _importanceTasksStorage.saveMostImportanceTasks(
        algorithmResult.taskIds,
      );
    }

    final taskBaseEntities = tasks.map((task) => task.toBaseEntity()).toList();
    final tasksWithImportance = taskBaseEntities
        .where((task) => algorithmResult.taskIds.contains(task.id))
        .toList();

    final lastImportanceAlgorithmRunTime =
        await _importanceTasksStorage.getMostImportanceTasksTime();
    emit(const TaskState.loaderHide());
    emit(TaskState.loaded(
      tasks: taskBaseEntities,
      mostImportanceTasks: tasksWithImportance,
      lastImportanceAlgorithmRunTime: lastImportanceAlgorithmRunTime,
      initialScreenIndex: 1,
    ));
  }

  Future<List<TaskEntity>> _getTasks() async {
    final tasks = await _databaseContext.tasksDao.getAllTasks();
    final entities = tasks.map((task) async {
      final subTaskIds = await _databaseContext.taskSubtaskRelationsDao
          .getTaskSubtaskRelations(task.id);
      final dependOnTaskIds = await _databaseContext.taskDependOnRelationsDao
          .getTaskDependOnRelations(task.id);
      return TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        status: task.status,
        createdDate: task.createdDate ?? DateTime.now(),
        deadlineDate: task.deadlineDate,
        subtasksIds: subTaskIds,
        dependOnTasksIds: dependOnTaskIds,
      );
    }).toList();

    return Future.wait(entities);
  }

  Future<List<TaskBaseEntity>> _getBaseTasks() async {
    final tasks = await _databaseContext.tasksDao.getAllTasks();
    return tasks
        .map((task) => TaskBaseEntity(
              id: task.id,
              title: task.title,
              description: task.description,
              priority: task.priority,
              status: task.status,
              createdDate: task.createdDate ?? DateTime.now(),
              deadlineDate: task.deadlineDate,
            ))
        .toList();
  }
}

/// События блока задач.
@freezed
abstract class TaskEvent with _$TaskEvent {
  /// Загрузка задач.
  const factory TaskEvent.load() = _TaskLoadEvent;

  /// Добавление/изменение задачи.
  const factory TaskEvent.openPutTask({
    required int? taskId,
    required int fromScreenIndex,
  }) = _TaskOpenPutTaskEvent;

  /// Сохранение добавленной/измененной задачи.
  const factory TaskEvent.savePuttedTask({
    required TaskEntity task,
  }) = _TaskSavePuttedTaskEvent;

  /// Удаление задачи.
  const factory TaskEvent.deleteTask({
    required TaskEntity task,
    required int fromScreenIndex,
  }) = _TaskDeleteTaskEvent;

  /// Удаление задачи.
  const factory TaskEvent.changeTaskStatus({
    required int taskId,
    required TaskStatus status,
    required int fromScreenIndex,
  }) = _TaskChangeTaskStatusEvent;

  /// Запуск алгоритма важности.
  const factory TaskEvent.runImportanceAlgorithm() =
      _TaskRunImportanceAlgorithmEvent;
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
    required List<TaskBaseEntity> tasks,
    required List<TaskBaseEntity> mostImportanceTasks,
    required DateTime? lastImportanceAlgorithmRunTime,
    required int initialScreenIndex,
  }) = _TaskLoadedState;

  /// Добавлена/изменена задача.
  const factory TaskState.openPutTaskScreen({
    required TaskEntity? task,
    required List<TaskEntity> allTasks,
    required int fromScreenIndex,
  }) = _TaskOpenPutTaskScreenState;
}
