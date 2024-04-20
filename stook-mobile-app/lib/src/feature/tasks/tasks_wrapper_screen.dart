import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stook_database/database_context.dart';

import '../../common/infrastructure/di_configurator.dart';
import '../../common/widget/thesis_tab_bar.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_scope.dart';
import 'task_importance/task_importance_screen.dart';
import 'task_put/task_put_screen.dart';
import 'widget/tasks_screen.dart';

/// Страница экрана задач.
class TasksWrapperScreen extends StatelessWidget {
  const TasksWrapperScreen({super.key});

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
                builder: (context) =>
                    TaskPutScreen(task: state.task, allTasks: state.allTasks),
              ))
              .whenComplete(() => TaskScope.load(context)),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Задачи'),
            centerTitle: false,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DriftDbViewer(
                      injector.get<DatabaseContext>(),
                    ),
                  ),
                ),
                icon: const Icon(Icons.insert_comment_sharp),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => TaskScope.openPutTask(context),
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: state.whenOrNull(
              loaded: (tasks) => Visibility(
                visible: tasks.isEmpty,
                child: const Center(
                  child: Text('Задачи пусты'),
                ),
                replacement: ThesisTabBar(
                  tabs: const ['Все', 'Важные'],
                  children: [
                    TasksScreen(tasks: tasks),
                    const TaskImportanceScreen(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
