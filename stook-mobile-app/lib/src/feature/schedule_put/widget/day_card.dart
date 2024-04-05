import 'package:flutter/material.dart';

import '../models.dart';
import 'lesson_card.dart';

class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.day,
    required this.onAddLesson,
  });

  final Day day;
  final void Function(Day week) onAddLesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(day.name),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
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
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: LessonCard(lesson: lesson),
                    ),
                    const Divider(),
                  ],
                ),
              TextButton(
                onPressed: () {
                  day.addLesson();
                  onAddLesson(day);
                },
                child: const Text('Добавить урок'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
