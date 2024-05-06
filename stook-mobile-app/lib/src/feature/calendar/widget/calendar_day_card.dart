import 'package:flutter/material.dart';
import 'package:stook_shared/stook_shared.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extension/date_time_x.dart';
import '../../tasks/widget/task_status_card.dart';
import '../models.dart';
import 'calendar_lesson_card.dart';

/// Карточка дня в расписании.
class CalendarDayCard extends StatelessWidget {
  const CalendarDayCard({
    super.key,
    required this.day,
    required this.tasks,
  });

  final CalendarDayEntity day;
  final List<CalendarTaskEntity> tasks;

  String _upWordsFirstLetter(String str) {
    return str
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _lessonsCount(int count) {
    if (count == 0) {
      return 'занятий нет';
    } else if (count == 1) {
      return '1 занятие';
    } else if (count < 5) {
      return '$count занятия';
    } else {
      return '$count занятий';
    }
  }

  String _tasksCount(int count) {
    if (count == 0) {
      return 'задач нет';
    } else if (count == 1) {
      return '1 задача';
    } else if (count < 5) {
      return '$count задачи';
    } else {
      return '$count задач';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _upWordsFirstLetter(
                    kCalendarDayOfWeekFormatter.format(day.date)),
                style: day.date.isToday || day.lessons.isNotEmpty
                    ? Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )
                    : Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.grey.shade600, fontSize: 20),
              ),
              Row(
                children: [
                  Text(
                    "${_upWordsFirstLetter(kCalendarDateFormatter.format(day.date))} - ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.grey.shade600),
                  ),
                  Text(
                    "${_lessonsCount(day.lessons.length)}, ${_tasksCount(tasks.length)}",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: day.lessons.isNotEmpty,
          child: Column(
            children: List.generate(
              day.lessons.length,
              (index) => CalendarLessonDay(lesson: day.lessons[index]),
            ),
          ),
        ),
        Visibility(
          visible: tasks.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(top: day.lessons.isNotEmpty ? 4.0 : 8.0),
            child: Column(
              children: List.generate(
                tasks.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    top: index != 0 ? 12 : 0,
                    left: 16,
                    right: 16,
                  ),
                  child: _CalendarDayTask(task: tasks[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarDayTask extends StatelessWidget {
  const _CalendarDayTask({required this.task});

  final CalendarTaskEntity task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                const SizedBox(height: 4.0),
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
