import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/task_priority.dart';
import 'package:stook_database/models/enums/task_status.dart';

import '../../../common/constants/constants.dart';
import '../bloc/task_scope.dart';
import '../entities/task_base_entity.dart';
import 'task_status_card.dart';

/// Карточка задачи.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onPressed,
  });

  final TaskBaseEntity task;
  final void Function(TaskBaseEntity task)? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newStatus = switch (task.status) {
          TaskStatus.pending =>
            await _TaskStatusHelper().takeTaskInWork(context) ?? false
                ? TaskStatus.inProgress
                : null,
          TaskStatus.inProgress =>
            await _TaskStatusHelper().cancelOrCompleteTask(context),
          _ => null,
        };

        if (newStatus != null) {
          TaskScope.changeTaskStatus(
            context,
            taskId: task.id,
            status: newStatus,
            fromScreenIndex: 0,
          );
        }
      },
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TaskStatusCard(taskStatus: task.status),
                    ),
                    const SizedBox(width: 8.0),
                    if (task.priority != null)
                      Flexible(
                        child: Text(
                          task.priority!.name,
                          style: TextStyle(
                            color: task.priority!.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2.0),
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (task.deadlineDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                        'Крайний срок: ${kDateFormat.format(task.deadlineDate!)}'),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: onPressed != null,
            child: IconButton(
              onPressed: () => onPressed?.call(task),
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskStatusHelper {
  /// Взять задачу в работу.
  Future<bool?> takeTaskInWork(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Взять задачу в работу?'),
          content: const Text('Вы уверены, что хотите взять задачу в работу?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Взять в работу'),
            ),
          ],
        );
      },
    );
  }

  /// Вернуть в состояние "создана" или завершить задачу.
  Future<TaskStatus?> cancelOrCompleteTask(BuildContext context) async {
    return await showDialog<TaskStatus>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Завершить задачу?'),
          content: const Text('Вы уверены, что хотите завершить задачу?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(TaskStatus.pending),
              child: const Text('Вернуть в "Создана"'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(TaskStatus.completed),
              child: const Text('Завершить задачу'),
            ),
          ],
        );
      },
    );
  }
}
