import 'package:flutter/material.dart';

import '../models.dart';

/// Экран для редактирования занятия.
class LessonPutScreen extends StatefulWidget {
  const LessonPutScreen({
    super.key,
    required this.lesson,
    required this.onLessonUpdate,
  });

  final Lesson lesson;
  final void Function(Lesson updatedLesson) onLessonUpdate;

  @override
  State<LessonPutScreen> createState() => _LessonPutScreenState();
}

class _LessonPutScreenState extends State<LessonPutScreen> {
  final nameController = TextEditingController();
  final teacherController = TextEditingController();
  final placeController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.lesson.name;
    teacherController.text = widget.lesson.teacher;
    placeController.text = widget.lesson.place;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    teacherController.dispose();
    placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Подробнее'),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(Icons.check_circle),
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Введите название занятия.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final updatedLesson = widget.lesson.copyWith(
                    name: nameController.text,
                    teacher: teacherController.text,
                    place: placeController.text,
                  );
                  widget.onLessonUpdate(updatedLesson);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Название',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    TextFormField(
                      controller: teacherController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Преподаватель',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    TextFormField(
                      controller: placeController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Аудитория',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
