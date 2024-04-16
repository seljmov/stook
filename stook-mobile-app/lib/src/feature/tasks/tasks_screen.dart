import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'bloc/task_bloc.dart';
import 'bloc/task_scope.dart';
import 'task_put/task_put_screen.dart';

/// Страница экрана задач.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ITaskBloc, TaskState>(
      bloc: TaskScope.of(context)..add(const TaskEvent.load()),
      listener: (context, state) {
        state.mapOrNull(
          initial: (_) => TaskScope.load(context),
          loaderShow: (_) => context.loaderOverlay.show(),
          loaderHide: (_) => context.loaderOverlay.hide(),
          openPutTaskScreen: (state) => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => TaskPutScreen(
                      task: state.task, allTasks: state.allTasks)))
              .whenComplete(() => TaskScope.load(context)),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Задачи'),
            centerTitle: false,
            surfaceTintColor: Colors.transparent,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => TaskScope.openPutTask(context),
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: state.whenOrNull(
              loaded: (tasks) {
                // desc sort tasks by created date, but createdDate can be null
                final sortedTasks = tasks.toList();
                sortedTasks.sort((a, b) {
                  final aDate = a.createdDate ?? DateTime(0);
                  final bDate = b.createdDate ?? DateTime(0);
                  return bDate.compareTo(aDate);
                });
                return Visibility(
                  visible: tasks.isEmpty,
                  child: const Center(
                    child: Text('Задачи пусты'),
                  ),
                  replacement: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return GestureDetector(
                        onTap: () => TaskScope.openPutTask(context, task: task),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
