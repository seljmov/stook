import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/enums.dart';

import '../../../common/constants/constants.dart';
import '../bloc/task_scope.dart';
import '../entities/task_entity.dart';

/// Страница экрана добавления/изменения задачи.
class TaskPutScreen extends StatefulWidget {
  const TaskPutScreen({
    super.key,
    this.task,
    this.allTasks = const [],
    this.fromScreenIndex = 0,
  });

  final TaskEntity? task;
  final List<TaskEntity> allTasks;
  final int fromScreenIndex;

  @override
  State<TaskPutScreen> createState() => _TaskPutScreenState();
}

class _TaskPutScreenState extends State<TaskPutScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineNotifier = ValueNotifier<DateTime?>(null);
  final taskPriorityNotifier = ValueNotifier<TaskPriority?>(null);
  final subTasksIdsNotifier = ValueNotifier<List<int>>([]);
  final dependsTasksIdsNotifier = ValueNotifier<List<int>>([]);

  @override
  void initState() {
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      deadlineNotifier.value = widget.task!.deadlineDate;
      taskPriorityNotifier.value = widget.task!.priority;
      subTasksIdsNotifier.value = widget.task!.subtasksIds;
      dependsTasksIdsNotifier.value = widget.task!.dependOnTasksIds;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    deadlineNotifier.dispose();
    taskPriorityNotifier.dispose();
    subTasksIdsNotifier.dispose();
    dependsTasksIdsNotifier.dispose();
    super.dispose();
  }

  /// Признак того, что задача только для чтения.
  bool get isReadOnly =>
      widget.task != null && widget.task?.status == TaskStatus.completed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.task == null ? 'Добавить задачу' : 'Изменить задачу'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          Visibility(
            visible: widget.task != null,
            child: IconButton(
              onPressed: () async {
                final deleted = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Удаление задачи'),
                      content:
                          const Text('Вы уверены, что хотите удалить задачу?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Да'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Нет'),
                        ),
                      ],
                    );
                  },
                );
                if (deleted != null && deleted) {
                  TaskScope.deleteTask(
                    context,
                    widget.task!,
                    widget.fromScreenIndex,
                  );
                  Navigator.of(context).pop(widget.fromScreenIndex);
                }
              },
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
            ),
          ),
          Visibility(
            visible: !isReadOnly,
            child: IconButton(
              onPressed: () {
                if (widget.task != null &&
                    widget.task?.status == TaskStatus.completed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Нельзя изменить завершенную задачу'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                final title = titleController.text;
                final description = descriptionController.text;
                final deadline = deadlineNotifier.value;
                final priority = taskPriorityNotifier.value;

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Введите название задачи'),
                    ),
                  );
                  return;
                }

                final puttedTask = TaskEntity(
                  id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
                  title: title,
                  description: description,
                  createdDate: widget.task?.createdDate ?? DateTime.now(),
                  deadlineDate: deadline,
                  priority: priority,
                  status: widget.task?.status ?? TaskStatus.pending,
                  subtasksIds: subTasksIdsNotifier.value,
                  dependOnTasksIds: dependsTasksIdsNotifier.value,
                );
                TaskScope.savePuttedTask(context, task: puttedTask);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.save,
                size: 28.0,
                //color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  TextFormField(
                    readOnly: isReadOnly,
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      hintText: 'Название',
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  TextFormField(
                    readOnly: isReadOnly,
                    controller: descriptionController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      hintText:
                          isReadOnly ? 'Описание' : 'Описание (необязательно)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0)
                        .copyWith(right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Крайний срок',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isReadOnly) {
                              return;
                            }

                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              helpText: 'Выберите дату',
                              cancelText: 'Отмена',
                              confirmText: 'Выбрать',
                              barrierLabel: 'Выбор даты',
                            );
                            if (pickedDate != null) {
                              deadlineNotifier.value = pickedDate;
                            }
                          },
                          child: ValueListenableBuilder<DateTime?>(
                            valueListenable: deadlineNotifier,
                            builder: (context, deadline, child) {
                              return Text(
                                deadline == null
                                    ? 'Не выбран'
                                    : kDateFormat.format(deadline),
                                style: TextStyle(
                                  color: deadline == null
                                      ? Colors.grey
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12.0).copyWith(
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Приоритет',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isReadOnly) {
                              return;
                            }
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          'Выберите приоритет',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        //mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          TaskPriority.values.length,
                                          (index) {
                                            final priority =
                                                TaskPriority.values[index];
                                            return ListTile(
                                              title: Text(
                                                priority.name,
                                                style: TextStyle(
                                                  color: priority.color,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              subtitle: Text(
                                                priority.description,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              onTap: () {
                                                taskPriorityNotifier.value =
                                                    priority;
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: ValueListenableBuilder<TaskPriority?>(
                            valueListenable: taskPriorityNotifier,
                            builder: (context, priority, child) {
                              return Text(
                                priority == null ? 'Не выбран' : priority.name,
                                style: TextStyle(
                                  color: priority == null
                                      ? Colors.grey
                                      : priority.color,
                                  fontSize: 16,
                                  fontWeight: priority == null
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: taskPriorityNotifier,
            builder: (context, priority, child) {
              if (priority == null) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  priority.description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12.0).copyWith(
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Подзадачи',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isReadOnly) {
                              return;
                            }

                            if (widget.allTasks.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Нет доступных задач'),
                                ),
                              );
                              return;
                            }
                            final filteredTasks = widget.allTasks
                                .where((task) =>
                                    task.id != widget.task?.id &&
                                    !dependsTasksIdsNotifier.value
                                        .contains(task.id))
                                .toList();
                            final subTasks =
                                await BottomSheepMultiSelector.show(
                              context,
                              tasks: filteredTasks,
                              selectedIds: subTasksIdsNotifier.value,
                            );
                            subTasksIdsNotifier.value = subTasks;
                          },
                          child: ValueListenableBuilder<List<int>>(
                            valueListenable: subTasksIdsNotifier,
                            builder: (context, subTasks, child) {
                              return Text(
                                subTasks.isEmpty
                                    ? 'Не выбраны'
                                    : '${subTasks.length} шт.',
                                style: TextStyle(
                                  color: subTasks.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12.0).copyWith(
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Зависит от задач',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isReadOnly) {
                              return;
                            }

                            if (widget.allTasks.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Нет доступных задач'),
                                ),
                              );
                              return;
                            }
                            final filteredTasks = widget.allTasks
                                .where((task) =>
                                    task.id != widget.task?.id &&
                                    !subTasksIdsNotifier.value
                                        .contains(task.id))
                                .toList();
                            final dependsTasks =
                                await BottomSheepMultiSelector.show(
                              context,
                              tasks: filteredTasks,
                              selectedIds: dependsTasksIdsNotifier.value,
                            );
                            dependsTasksIdsNotifier.value = dependsTasks;
                          },
                          child: ValueListenableBuilder<List<int>>(
                            valueListenable: dependsTasksIdsNotifier,
                            builder: (context, dependsTasks, child) {
                              return Text(
                                dependsTasks.isEmpty
                                    ? 'Не выбраны'
                                    : '${dependsTasks.length} шт.',
                                style: TextStyle(
                                  color: dependsTasks.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isReadOnly,
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 24.0),
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Text(
                        'Завершенная задача доступна только для чтения или удаления.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Мультивыбор задач.
class BottomSheepMultiSelector {
  static Future<List<int>> show(
    BuildContext context, {
    required List<TaskEntity> tasks,
    List<int> selectedIds = const [],
  }) async {
    final selectedTasksNotifier = ValueNotifier<List<TaskEntity>>(
      tasks.where((task) => selectedIds.contains(task.id)).toList(),
    );
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Выберите задачи',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Visibility(
                visible: tasks.isEmpty,
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        'Нет доступных задач',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                replacement: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedTasksNotifier,
                      builder: (context, selectedTasks, child) {
                        return Column(
                          children: List.generate(
                            tasks.length,
                            (index) {
                              final task = tasks[index];
                              return GestureDetector(
                                onTap: () {
                                  if (selectedTasks.contains(task)) {
                                    selectedTasksNotifier.value = selectedTasks
                                        .where((t) => t != task)
                                        .toList();
                                  } else {
                                    selectedTasksNotifier.value = [
                                      ...selectedTasks,
                                      task,
                                    ];
                                  }
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: selectedTasks.contains(task),
                                      onChanged: (value) {
                                        if (value != null && value == true) {
                                          selectedTasksNotifier.value = [
                                            ...selectedTasks,
                                            task,
                                          ];
                                        } else {
                                          selectedTasksNotifier.value =
                                              selectedTasks
                                                  .where((t) => t != task)
                                                  .toList();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Закрыть'),
                ),
              ),
            ],
          ),
        );
      },
    );
    return selectedTasksNotifier.value.map((task) => task.id).toList();
  }
}
