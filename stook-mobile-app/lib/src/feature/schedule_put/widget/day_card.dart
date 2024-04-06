import 'package:flutter/material.dart';

import '../lesson_put/lesson_put_screen.dart';
import '../models.dart';
import 'lesson_card.dart';

class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.day,
    required this.onAddLesson,
    required this.onUpdateDay,
  });

  final Day day;
  final void Function(Day day) onAddLesson;
  final void Function(Day day) onUpdateDay;

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
              for (final lesson in day.lessons)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: LessonCard(
                        number: day.lessons.indexOf(lesson) + 1,
                        lesson: lesson,
                        onLessonEdit: (lesson) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonPutScreen(
                                lesson: lesson,
                                onLessonUpdate: (updatedLesson) {
                                  day.lessons[day.lessons.indexOf(lesson)] =
                                      updatedLesson;
                                  onUpdateDay(day);
                                },
                              ),
                            ),
                          );
                        },
                        onLessonUpdate: (lesson) {
                          day.lessons[day.lessons.indexOf(lesson)] = lesson;
                          onUpdateDay(day);
                        },
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LessonPutScreen(
                        lesson: Lesson(),
                        onLessonUpdate: (lesson) {
                          day.lessons.add(lesson);
                          onUpdateDay(day);
                        },
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
            ],
          ),
        ),
      ],
    );
  }
}
