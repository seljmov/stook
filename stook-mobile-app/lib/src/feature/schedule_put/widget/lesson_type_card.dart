import 'package:flutter/material.dart';
import 'package:stook_database/models/enums/lesson_type.dart';

/// Карточка типа занятия.
class LessonTypeCard extends StatelessWidget {
  const LessonTypeCard({
    super.key,
    required this.lessonType,
  });

  final LessonType lessonType;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: lessonType.color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: Text(
          lessonType.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
