import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:stook_database/database_context.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:stook_database/models/models.dart';

import '../../common/extension/scaffold_x.dart';
import 'models.dart' as models;
import 'models.dart';
import 'utils/schedule_provider.dart';
import 'widget/week_widget.dart';

/// Экран для указания расписания.
class SchedulePutScreen extends StatefulWidget {
  const SchedulePutScreen({
    super.key,
    required this.databaseContext,
  });

  final DatabaseContext databaseContext;

  @override
  State<SchedulePutScreen> createState() => _SchedulePutScreenState();
}

class _SchedulePutScreenState extends State<SchedulePutScreen> {
  Future<List<Week>> _loadFromDatabase() async {
    final lessons = await widget.databaseContext.lessonsDao.getAllLessons();
    final lessonsByWeek = lessons.groupListsBy((lessons) => lessons.weekNumber);
    final weeks = <Week>[];
    for (final weekNumber in lessonsByWeek.keys) {
      final week = Week(
        number: weekNumber,
        days: List.generate(
          6,
          (index) => Day(dayOfWeek: DayOfWeek.values[index]),
        ),
      );
      final lessonsByDay =
          lessonsByWeek[weekNumber]!.groupListsBy((lesson) => lesson.dayOfWeek);
      for (final dayOfWeek in lessonsByDay.keys) {
        final day = week.days.firstWhere(
          (day) => day.dayOfWeek == dayOfWeek,
        );
        final lessons = lessonsByDay[dayOfWeek] ?? [];
        day.lessons.addAll(lessons.map((lesson) {
          return models.Lesson(
            id: lesson.id,
            name: lesson.title,
            place: lesson.place,
            teacher: lesson.teacher,
            timeStart: TimeOfDay.fromDateTime(lesson.timeStart),
            timeEnd: TimeOfDay.fromDateTime(lesson.timeEnd),
            type: lesson.lessonType,
          );
        }));
      }
      weeks.add(week);
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final weeks = snapshot.data as List<Week>;

          return ChangeNotifierProvider(
            create: (context) => ScheduleProvider(weeks),
            child: Builder(builder: (context) {
              return Consumer<ScheduleProvider>(
                builder: (context, provider, child) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Укажите расписание'),
                    centerTitle: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.data_array),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DriftDbViewer(widget.databaseContext)));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          icon: const Icon(Icons.check_circle),
                          onPressed: () async {
                            if (provider.weeks.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('В расписании нет недель.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                            // else if (!provider.isCorrect) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('В расписании есть дни без занятий.'),
                            //       backgroundColor: Colors.redAccent,
                            //     ),
                            //   );
                            // }
                            else {
                              final lessons = provider.weeks
                                  .map((week) => week.toLessons())
                                  .expand((element) => element)
                                  .toList();
                              final oldLessons = await widget
                                  .databaseContext.lessonsDao
                                  .getAllLessons();
                              await widget.databaseContext.lessonsDao
                                  .deleteAllLessons();
                              try {
                                await widget.databaseContext.lessonsDao
                                    .insertLessonsCompanions(lessons);
                              } catch (e) {
                                await widget.databaseContext.lessonsDao
                                    .insertLessons(oldLessons);
                                rethrow;
                              }
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: provider.weeks.isNotEmpty,
                          child: ListView.builder(
                            itemCount: provider.weeks.length,
                            itemBuilder: (context, index) {
                              final week = provider.weeks[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      index != 0 && !week.isHidden ? 16.0 : 0,
                                ),
                                child: WeekWidget(
                                  week: week,
                                  onWeekUpdate: (updatedWeek) {
                                    provider.updateWeek(index, updatedWeek);
                                  },
                                  onWeekRemove: (week) {
                                    provider.removeWeek(index);
                                  },
                                ),
                              );
                            },
                          ),
                          replacement: const Center(
                            child: Text('Добавьте неделю'),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (provider.weeks.length == 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Максимальное количество недель - 4.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          provider.addWeek();
                        },
                        child: const Text('Добавить неделю'),
                      ),
                    ],
                  ),
                ).withBottomPadding(),
              );
            }),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
