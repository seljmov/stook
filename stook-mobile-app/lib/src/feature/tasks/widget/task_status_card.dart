import 'package:flutter/material.dart';
import 'package:stook_shared/stook_shared.dart';

/// Карточка статуса задачи.
class TaskStatusCard extends StatelessWidget {
  const TaskStatusCard({
    super.key,
    required this.taskStatus,
  });

  final TaskStatus taskStatus;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: taskStatus.color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: Text(
          taskStatus.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
