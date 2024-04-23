import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extension/time_of_day_x.dart';
import '../models.dart';

/// Карточка дня в расписании.
class CalendarLessonDay extends StatelessWidget {
  const CalendarLessonDay({
    super.key,
    required this.lesson,
  });

  final CalendarLessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kTimeFormat.format(lesson.timeStart.toDateTime()),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  kTimeFormat.format(lesson.timeEnd.toDateTime()),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 4.0).copyWith(left: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              Visibility(
                visible: lesson.teacher.isNotEmpty,
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    Text(
                      lesson.teacher,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: lesson.place.isNotEmpty,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    Text(
                      lesson.place,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
