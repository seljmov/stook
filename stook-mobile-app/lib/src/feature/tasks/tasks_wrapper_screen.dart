import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/widget/thesis_tab_bar.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_scope.dart';
import 'task_importance/task_importance_screen.dart';
import 'task_put/task_put_screen.dart';
import 'widget/tasks_screen.dart';

/// Страница экрана задач.
class TasksWrapperScreen extends StatefulWidget {
  const TasksWrapperScreen({super.key});

  @override
  State<TasksWrapperScreen> createState() => _TasksWrapperScreenState();
}

class _TasksWrapperScreenState extends State<TasksWrapperScreen> {
  final tabIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    tabIndexNotifier.dispose();
    super.dispose();
  }

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
                        task: state.task,
                        allTasks: state.allTasks,
                        fromScreenIndex: state.fromScreenIndex,
                      )))
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
          floatingActionButton: ValueListenableBuilder(
            valueListenable: tabIndexNotifier,
            builder: (context, tabIndex, child) => FloatingActionButton(
              onPressed: () => TaskScope.openPutTask(
                context,
                fromScreenIndex: tabIndex,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          body: Center(
            child: state.whenOrNull(
              loaded: (tasks, mostImportanceTasks,
                      lastImportanceAlgorithmRunTime, initialScreenIndex) =>
                  Visibility(
                visible: tasks.isEmpty,
                child: const Center(
                  child: Text('Задачи пусты'),
                ),
                replacement: ThesisTabBar(
                  initialScreenIndex: tabIndexNotifier.value,
                  tabs: const ['Все', 'Важные'],
                  onTap: (index) => tabIndexNotifier.value = index,
                  children: [
                    TasksScreen(tasks: tasks),
                    TaskImportanceScreen(
                      tasks: mostImportanceTasks,
                      lastImportanceAlgorithmRunTime:
                          lastImportanceAlgorithmRunTime,
                    ),
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
