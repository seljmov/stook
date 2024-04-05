import 'package:flutter/material.dart';

import '../models.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return const Text('TODO: LessonCard widget');
    // return Row(
    //   children: [
    //     Column(
    //       children: [
    //         Text(lesson.name),
    //         Text(lesson.teacher),
    //       ],
    //     ),
    //     const Spacer(),
    //     IconButton(
    //       icon: const Icon(Icons.edit),
    //       onPressed: () {
    //         // edit lesson
    //       },
    //     ),
    //     IconButton(
    //       icon: const Icon(Icons.delete),
    //       onPressed: () {
    //         // delete lesson
    //       },
    //     ),
    //   ],
    // );
  }
}
