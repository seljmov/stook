import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../models.dart';
import 'calendar_lesson_card.dart';

/// Карточка дня в расписании.
class CalendarDayCard extends StatelessWidget {
  const CalendarDayCard({
    super.key,
    required this.day,
  });

  final CalendarDayEntity day;

  String upWordsFirstLetter(String str) {
    return str
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String lessonsCount(int count) {
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
                upWordsFirstLetter(
                    kCalendarDayOfWeekFormatter.format(day.date)),
                style: day.lessons.isNotEmpty
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
                    "${upWordsFirstLetter(kCalendarDateFormatter.format(day.date))} - ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.grey.shade600),
                  ),
                  Text(
                    lessonsCount(day.lessons.length),
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
      ],
    );
  }
}
