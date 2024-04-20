import 'package:flutter/material.dart';

import '../bloc/task_scope.dart';
import '../entities/task_base_entity.dart';
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
      (a, b) => a.createdDate.compareTo(b.createdDate),
    );
    final reversedTasks = sortedTasks.reversed.toList();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: ListView.builder(
        itemCount: reversedTasks.length,
        itemBuilder: (context, index) {
          final task = reversedTasks[index];
          return Padding(
            padding: EdgeInsets.only(top: index != 0 ? 16 : 0).copyWith(
              left: 16,
              right: 8,
              bottom: index == reversedTasks.length - 1 ? 64 : 0,
            ),
            child: TaskCard(
              task: task,
              onPressed: (task) =>
                  TaskScope.openPutTask(context, taskId: task.id),
            ),
          );
        },
      ),
    );
  }
}