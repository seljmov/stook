import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stook_shared/stook_shared.dart';

import '../bloc/task_scope.dart';
import 'task_card.dart';

/// Экран задач.
class TasksScreen extends StatelessWidget {
  const TasksScreen({
    super.key,
    required this.tasks,
  });

  final List<TaskBaseEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final sortedTasks = tasks.toList();
    sortedTasks.sort(
      (a, b) => (a.deadlineDate?.millisecondsSinceEpoch ?? 0).compareTo(
        b.deadlineDate?.millisecondsSinceEpoch ?? 0,
      ),
    );
    sortedTasks.sort(
      (a, b) => a.status.sortIndex.compareTo(b.status.sortIndex),
    );
    // TODO: Подумать над рефакторингом.
    final multi = Platform.isIOS ? 0.69 : 0.76;
    return SizedBox(
      height: MediaQuery.of(context).size.height * multi,
      child: ListView.builder(
        itemCount: sortedTasks.length,
        itemBuilder: (context, index) {
          final task = sortedTasks[index];
          return Padding(
            padding: EdgeInsets.only(top: index != 0 ? 16 : 0).copyWith(
              left: 16,
              right: 8,
              bottom: index == sortedTasks.length - 1 ? 64 : 0,
            ),
            child: TaskCard(
              task: task,
              onPressed: (task) => TaskScope.openPutTask(
                context,
                taskId: task.id,
                fromScreenIndex: 0,
              ),
            ),
          );
        },
      ),
    );
  }
}
