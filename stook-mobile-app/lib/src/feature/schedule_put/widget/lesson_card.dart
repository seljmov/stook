import 'package:flutter/material.dart';
import 'package:stook_database/models/models.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extension/time_of_day_x.dart';
import '../../../common/widget/type_card.dart';
import '../models.dart';

/// Карточка занятия.
class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.onLessonEdit,
    required this.onLessonUpdate,
    required this.onLessonRemove,
  });

  final LessonEntity lesson;
  final void Function(LessonEntity lesson) onLessonEdit;
  final String? Function(LessonEntity lesson) onLessonUpdate;
  final void Function(LessonEntity lesson) onLessonRemove;

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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
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
                        TypeCard(
                          title: lesson.type.name,
                          color: lesson.type.color,
                        ),
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
