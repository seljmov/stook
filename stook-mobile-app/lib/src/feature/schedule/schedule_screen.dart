import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stook_database/database_context.dart';

import 'models.dart';
import 'widget/calendar_day_card.dart';

/// TODO: Переименовать в календарь.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.databaseContext});

  final DatabaseContext databaseContext;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Future<List<ScheduleDayEntity>> getScheduleFromDatabase() async {
    final lessons = await widget.databaseContext.lessonsDao.getAllLessons();
    final lessonsByWeek = lessons.groupListsBy((lessons) => lessons.weekNumber);

    final prefs = await SharedPreferences.getInstance();
    var currentWeekNumber = prefs.getInt('currentWeekNumber') ?? 1;
    final currentDate =
        prefs.getString('currentDate') ?? DateTime.now().toString();
    final weeksBetween = countWeeks(
      DateTime.parse(currentDate),
      DateTime.now(),
    );
    currentWeekNumber =
        (currentWeekNumber + weeksBetween) % lessonsByWeek.length;
    final scheduleDays = <ScheduleDayEntity>[];
    for (var i = 0; i < 14; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final dayOfWeek = date.weekday;
      final lessonsByDay = lessonsByWeek[currentWeekNumber]
              ?.groupListsBy((lesson) => lesson.dayOfWeek.index + 1) ??
          {};
      final lessons = lessonsByDay[dayOfWeek] ?? [];
      final scheduleDay = ScheduleDayEntity(
        date: date,
        lessons: lessons
            .where((lesson) => lesson.weekNumber == currentWeekNumber)
            .map((lesson) {
          return ScheduleLessonEntity(
            name: lesson.title,
            place: lesson.place,
            teacher: lesson.teacher,
            timeStart: TimeOfDay.fromDateTime(lesson.timeStart),
            timeEnd: TimeOfDay.fromDateTime(lesson.timeEnd),
            type: lesson.lessonType,
          );
        }).toList(),
      );

      if (dayOfWeek == 7) {
        currentWeekNumber += 2;
        currentWeekNumber %= lessonsByWeek.length;
        currentWeekNumber++;
      }

      scheduleDays.add(scheduleDay);
    }

    return scheduleDays;
  }

  // count weeks between two dates
  int countWeeks(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2).inDays;
    return (difference / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<List<ScheduleDayEntity>>(
        future: getScheduleFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // days with paddings
            return ListView(
              children: snapshot.data!
                  .map((day) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: CalendarDayCard(day: day),
                      ))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}
