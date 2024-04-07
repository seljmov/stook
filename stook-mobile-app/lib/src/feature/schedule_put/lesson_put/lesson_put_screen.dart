import 'package:flutter/material.dart';

import '../../../common/extension/time_of_day_x.dart';
import '../models.dart';

/// Экран для редактирования занятия.
class LessonPutScreen extends StatefulWidget {
  const LessonPutScreen({
    super.key,
    required this.lesson,
    required this.onLessonUpdate,
  });

  final Lesson lesson;
  final String? Function(Lesson updatedLesson) onLessonUpdate;

  @override
  State<LessonPutScreen> createState() => _LessonPutScreenState();
}

class _LessonPutScreenState extends State<LessonPutScreen> {
  final nameController = TextEditingController();
  final teacherController = TextEditingController();
  final placeController = TextEditingController();
  final startNotifier = ValueNotifier<TimeOfDay?>(null);
  final endNotifier = ValueNotifier<TimeOfDay?>(null);

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
                        content: Text('Введите название предмета.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  if (startNotifier.value == null ||
                      endNotifier.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Введите время начала и конца занятия.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final updatedLesson = widget.lesson.copyWith(
                    name: nameController.text,
                    teacher: teacherController.text,
                    place: placeController.text,
                    timeStart: startNotifier.value!,
                    timeEnd: endNotifier.value!,
                  );
                  final result = widget.onLessonUpdate(updatedLesson);
                  if (result == null) {
                    Navigator.of(context).pop();
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
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
                        hintText: 'Предмет',
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
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0)
                          .copyWith(right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Начало',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: startNotifier.value ??
                                    const TimeOfDay(hour: 8, minute: 30),
                                initialEntryMode: TimePickerEntryMode.input,
                                cancelText: 'Отмена',
                                confirmText: 'Выбрать',
                                helpText: 'Выбор времени начала занятия',
                                errorInvalidText: 'Неверное время',
                                hourLabelText: 'Часы',
                                minuteLabelText: 'Минуты',
                                barrierLabel: 'Выбор времени начала занятия',
                              );
                              startNotifier.value = timeOfDay;
                              endNotifier.value = timeOfDay?.addMinutes(90);
                            },
                            child: ValueListenableBuilder<TimeOfDay?>(
                              valueListenable: startNotifier,
                              builder: (context, time, child) {
                                return Text(
                                  time?.format(context) ?? 'Выбрать',
                                  style: TextStyle(
                                    color: time == null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0)
                          .copyWith(right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Конец',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final timeOfDay = await showTimePicker(
                                context: context,
                                initialTime:
                                    startNotifier.value?.addMinutes(90) ??
                                        const TimeOfDay(hour: 10, minute: 0),
                                initialEntryMode: TimePickerEntryMode.input,
                                cancelText: 'Отмена',
                                confirmText: 'Выбрать',
                                helpText: 'Выбор времени конца занятия',
                                errorInvalidText: 'Неверное время',
                                hourLabelText: 'Часы',
                                minuteLabelText: 'Минуты',
                                barrierLabel: 'Выбор времени конца занятия',
                              );

                              if (timeOfDay != null &&
                                  (startNotifier.value == null ||
                                      timeOfDay
                                          .isBefore(startNotifier.value!))) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Время конца занятия не может быть раньше времени начала.',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }
                              endNotifier.value = timeOfDay;
                            },
                            child: ValueListenableBuilder<TimeOfDay?>(
                              valueListenable: endNotifier,
                              builder: (context, time, child) {
                                return Text(
                                  time?.format(context) ?? 'Выбрать',
                                  style: TextStyle(
                                    color: time == null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
