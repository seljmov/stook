import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stook_database/database_context.dart';

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
  static void openPutTask(BuildContext context, {Task? task}) {
    of(context).add(TaskEvent.openPutTask(task: task));
  }

  /// Сохранить задачу.
  static void savePuttedTask(BuildContext context, Task task) {
    of(context).add(TaskEvent.savePuttedTask(task: task));
  }

  /// Удалить задачу.
  static void deleteTask(BuildContext context, Task task) {
    of(context).add(TaskEvent.deleteTask(task: task));
  }
}
