import 'package:flutter/material.dart';

import '../models.dart';

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
  final void Function(Lesson lesson) onLessonUpdate;
  final void Function(Lesson lesson) onLessonRemove;

  @override
  Widget build(BuildContext context) {
    final lessonTimes = lesson.timeByNumber(number);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 36,
      ),
      //height: 36,
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
                          lessonTimes.$1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          lessonTimes.$2,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              child: Text(
                                ", ${lesson.teacher}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: lesson.place.isNotEmpty,
                          child: Text(
                            lesson.place,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
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
