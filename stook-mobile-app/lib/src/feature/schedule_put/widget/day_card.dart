import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../common/extension/time_of_day_x.dart';
import '../lesson_put/lesson_put_screen.dart';
import '../models.dart';
import 'lesson_card.dart';

/// Карточка дня в расписании.
class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.day,
    required this.onAddLesson,
    required this.onUpdateDay,
  });

  final DayEntity day;
  final void Function(DayEntity day) onAddLesson;
  final void Function(DayEntity day) onUpdateDay;

  String? _updateLesson(LessonEntity lesson, void Function() onUpdateLesson) {
    if (lesson.name.isEmpty) {
      return 'Название занятия не может быть пустым';
    }

    if (day.lessons.any((l) => l.id != lesson.id && l.name == lesson.name)) {
      return 'Занятие с таким названием уже существует';
    }

    final intersectedLesson = day.lessons.firstWhereOrNull(
      (l) =>
          l.id != lesson.id &&
          (l.timeStart.isBefore(lesson.timeEnd) &&
              l.timeEnd.isAfter(lesson.timeStart)),
    );
    if (intersectedLesson != null) {
      return 'Время пересекается с занятием "${intersectedLesson.name}"';
    }

    onUpdateLesson();
    onUpdateDay(day);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(day.name),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              for (final lesson in day.lessons
                  .sorted((a, b) => a.timeStart.compareTo(b.timeStart)))
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: LessonCard(
                        lesson: lesson,
                        onLessonEdit: (lesson) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonPutScreen(
                                lesson: lesson,
                                onLessonUpdate: (updatedLesson) =>
                                    _updateLesson(updatedLesson, () {
                                  day.lessons[day.lessons.indexOf(lesson)] =
                                      updatedLesson;
                                }),
                              ),
                            ),
                          );
                        },
                        onLessonUpdate: (lesson) => _updateLesson(lesson, () {
                          day.lessons[day.lessons.indexOf(lesson)] = lesson;
                        }),
                        onLessonRemove: (lesson) {
                          day.lessons.remove(lesson);
                          onUpdateDay(day);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 42),
                      child: Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              Visibility(
                visible: day.lessons.length < 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LessonPutScreen(
                          lesson: const LessonEntity(),
                          onLessonUpdate: (lesson) => _updateLesson(lesson, () {
                            final newLesson = lesson.copyWith(
                              id: DateTime.now().microsecondsSinceEpoch,
                            );
                            day.lessons.add(newLesson);
                          }),
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Добавить'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
