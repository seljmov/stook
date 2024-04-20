import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../bloc/task_scope.dart';
import '../entities/task_base_entity.dart';
import '../widget/task_card.dart';

/// Экран важности задачи.
class TaskImportanceScreen extends StatelessWidget {
  const TaskImportanceScreen({
    super.key,
    required this.tasks,
    this.lastImportanceAlgorithmRunTime,
  });

  final List<TaskBaseEntity> tasks;
  final DateTime? lastImportanceAlgorithmRunTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: Visibility(
        visible: tasks.isNotEmpty,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(tasks.length, (index) {
                final task = tasks[index];
                return Padding(
                  padding: EdgeInsets.only(top: index != 0 ? 16 : 0).copyWith(
                    left: 16,
                    right: 8,
                    bottom: index == tasks.length - 1 ? 64 : 0,
                  ),
                  child: TaskCard(
                    task: task,
                    onPressed: (task) =>
                        TaskScope.openPutTask(context, taskId: task.id),
                  ),
                );
              }),
              Text(
                'Актуально на: \n${kDateTimeFormat.format(lastImportanceAlgorithmRunTime!)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => TaskScope.runImportanceAlgorithm(context),
                child: const Text('Обновить'),
              ),
            ],
          ),
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.data_exploration_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Список пуст. \nЗапустите алгоритм, чтобы \nвыявить наиболее важные задачи',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => TaskScope.runImportanceAlgorithm(context),
              child: const Text('Запустить'),
            ),
          ],
        ),
      ),
    );
  }
}
