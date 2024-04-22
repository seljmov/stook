import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/task_entity.dart';
import 'task_bloc.dart';

/// Область видимости блока задач.
abstract class TaskScope {
  /// Получить блок.
  static ITaskBloc of(BuildContext context) {
    return BlocProvider.of<ITaskBloc>(context);
  }

  /// Загрузить данные.
  static void load(BuildContext context) {
    of(context).add(const TaskEvent.load());
  }

  /// Добавить/изменить задачу.
  static void openPutTask(
    BuildContext context, {
    int? taskId,
    int fromScreenIndex = 0,
  }) {
    of(context).add(TaskEvent.openPutTask(
      taskId: taskId,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Сохранить задачу.
  static void savePuttedTask(BuildContext context, {required TaskEntity task}) {
    of(context).add(TaskEvent.savePuttedTask(task: task));
  }

  /// Удалить задачу.
  static void deleteTask(BuildContext context, TaskEntity task,
      [int fromScreenIndex = 0]) {
    of(context).add(TaskEvent.deleteTask(
      task: task,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Запустить алгоритм важности.
  static void runImportanceAlgorithm(BuildContext context) {
    of(context).add(const TaskEvent.runImportanceAlgorithm());
  }
}
