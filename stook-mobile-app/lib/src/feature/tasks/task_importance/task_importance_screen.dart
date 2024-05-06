import 'package:flutter/material.dart';
import 'package:stook_shared/stook_shared.dart';

import '../../../common/constants/constants.dart';
import '../bloc/task_scope.dart';
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
    final sortedTasks = tasks.toList();
    sortedTasks.sort(
      (a, b) => (a.deadlineDate?.millisecondsSinceEpoch ?? 0).compareTo(
        b.deadlineDate?.millisecondsSinceEpoch ?? 0,
      ),
    );
    sortedTasks.sort(
      (a, b) => a.status.sortIndex.compareTo(b.status.sortIndex),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: Visibility(
        visible:
            sortedTasks.isNotEmpty && lastImportanceAlgorithmRunTime != null,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(sortedTasks.length, (index) {
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
                      fromScreenIndex: 1,
                    ),
                  ),
                );
              }),
              Text(
                'Актуально на: \n${kDateTimeFormat.format(lastImportanceAlgorithmRunTime ?? DateTime.now())}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async =>
                        await _HowItWorkBottomSheep().show(context),
                    child: const Text('Как это работает?'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => TaskScope.runImportanceAlgorithm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Обновить'),
                  ),
                ],
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async =>
                      await _HowItWorkBottomSheep().show(context),
                  child: const Text('Как это работает?'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => TaskScope.runImportanceAlgorithm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Запустить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Нижний лист с информацией о том, как работает алгоритм важности задач.
class _HowItWorkBottomSheep {
  Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(bottom: 32),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Как это работает?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Алгоритм важности задач позволяет выявить наиболее важные задачи, которые необходимо выполнить в первую очередь. Он основан на следующих параметрах:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '1. Крайний срок выполнения задачи.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '2. Приоритет задачи.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '3. Подзадачи.*',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '4. Задачи, от которых зависит плавание других задач.**',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Задача может зависить от задач, которые еще не выполнены. Такие задачи не будут планироваться, пока не будут выполнены задачи, от которых они зависят.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '* - если у задачи есть подзадачи, то в планировании учитываются только они, а не сама задача.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                '** - если у задачи есть зависимости, то в планировании учитываются только задачи, от которых она зависит. Для таких задач высчитывается приоритет зависимости, учитывающий приоритет задач, зависимых от нее.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
