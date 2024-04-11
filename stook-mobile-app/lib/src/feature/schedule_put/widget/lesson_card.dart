import 'package:flutter/material.dart';

import '../models.dart';
import 'lesson_type_card.dart';

/// Карточка занятия.
class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.number,
    required this.lesson,
    required this.onLessonEdit,
    required this.onLessonUpdate,
    required this.onLessonRemove,
  });

  final int number;
  final Lesson lesson;
  final void Function(Lesson lesson) onLessonEdit;
  final String? Function(Lesson lesson) onLessonUpdate;
  final void Function(Lesson lesson) onLessonRemove;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 36,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => onLessonRemove(lesson),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // lesson times
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lesson.timeStart.format(context),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          lesson.timeEnd.format(context),
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
            const VerticalDivider(),
            Flexible(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LessonTypeCard(lessonType: lesson.type),
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
                  IconButton(
                    onPressed: () {
                      onLessonEdit(lesson);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
