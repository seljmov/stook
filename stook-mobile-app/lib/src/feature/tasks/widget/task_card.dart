import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/task_priority.dart';

import '../../../common/constants/constants.dart';
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
    return Row(
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
                  Flexible(
                    child: Text(
                      task.priority.name,
                      style: TextStyle(
                        color: task.priority.color,
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
              const SizedBox(height: 2.0),
              Text('Крайний срок: ${kDateFormat.format(task.deadlineDate)}'),
            ],
          ),
        ),
        Visibility(
          visible: onPressed != null,
          child: IconButton(
            onPressed: () => onPressed?.call(task),
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
