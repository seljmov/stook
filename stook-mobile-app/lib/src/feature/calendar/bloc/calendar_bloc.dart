import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stook_database/database_context.dart';

import '../models.dart';

part 'calendar_bloc.freezed.dart';

/// Интерфейс блока календаря.
abstract class ICalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  ICalendarBloc() : super(const CalendarState.initial());
}

/// Блок календаря.
class CalendarBloc extends ICalendarBloc {
  final DatabaseContext _databaseContext;

  CalendarBloc({
    required DatabaseContext databaseContext,
  }) : _databaseContext = databaseContext {
    on<CalendarEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        openSchedule: (event) => _openSchedule(event, emit),
      ),
    );
  }

  Future<void> _load(
    _CalendarLoadEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(const CalendarState.loaderShow());
    final tasks = await _getTasksBeforeDate(
      DateTime.now().add(const Duration(days: 21)),
    );
    final lessons = await _databaseContext.lessonsDao.getAllLessons();
    if (lessons.isEmpty) {
      emit(const CalendarState.loaderHide());
      emit(CalendarState.loaded(days: [], tasks: tasks));
      return;
    }

    final lessonsByWeek =
        lessons.groupListsBy((lessons) => lessons.weekNumber - 1);

    final prefs = await SharedPreferences.getInstance();
    var currentWeekNumber = (prefs.getInt('currentWeekNumber') ?? 1) - 1;
    final currentDate =
        prefs.getString('currentDate') ?? DateTime.now().toString();

    final weeksBetween = _countWeeks(
      DateTime.parse(currentDate),
      DateTime.now(),
    );
    currentWeekNumber += weeksBetween;
    currentWeekNumber %= lessonsByWeek.length;

    final scheduleDays = <CalendarDayEntity>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < 42; i++) {
      final date = today.add(Duration(days: i));
      final dayOfWeek = date.weekday;
      final lessonsByDay = lessonsByWeek[currentWeekNumber]
              ?.groupListsBy((lesson) => lesson.dayOfWeek.index + 1) ??
          {};
      final lessons = lessonsByDay[dayOfWeek] ?? [];
      final scheduleDay = CalendarDayEntity(
        date: date,
        lessons: lessons
            .where((lesson) => lesson.weekNumber == currentWeekNumber + 1)
            .map((lesson) {
          return CalendarLessonEntity(
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
        currentWeekNumber++;
        currentWeekNumber %= lessonsByWeek.length;
      }

      scheduleDays.add(scheduleDay);
    }

    emit(const CalendarState.loaderHide());
    emit(CalendarState.loaded(days: scheduleDays, tasks: tasks));
  }

  Future<void> _openSchedule(
    _CalendarOpenScheduleEvent event,
    Emitter<CalendarState> emit,
  ) async {}

  int _countWeeks(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2).inDays;
    return (difference / 7).ceil();
  }

  Future<List<CalendarTaskEntity>> _getTasksBeforeDate(DateTime date) async {
    final tasks = await _databaseContext.tasksDao.getAllTasks();
    return tasks
        .where((task) =>
            task.deadlineDate != null && task.deadlineDate!.isBefore(date))
        .map((task) => CalendarTaskEntity(
              id: task.id,
              title: task.title,
              priority: task.priority,
              status: task.status,
              deadlineDate: task.deadlineDate ?? DateTime.now(),
            ))
        .toList();
  }
}

/// Событие блока календаря.
@freezed
abstract class CalendarEvent with _$CalendarEvent {
  /// Загрузка.
  const factory CalendarEvent.load() = _CalendarLoadEvent;

  /// Открыть расписание.
  const factory CalendarEvent.openSchedule() = _CalendarOpenScheduleEvent;
}

/// Состояние блока календаря.
@freezed
abstract class CalendarState with _$CalendarState {
  /// Начальное состояние.
  const factory CalendarState.initial() = _CalendarInitialState;

  /// Показать загрузчик.
  const factory CalendarState.loaderShow() = _CalendarLoaderShowState;

  /// Скрыть загрузчик.
  const factory CalendarState.loaderHide() = _CalendarLoaderHideState;

  /// Данные.
  const factory CalendarState.loaded({
    required List<CalendarDayEntity> days,
    required List<CalendarTaskEntity> tasks,
  }) = _CalendarLoadedState;

  /// Открыто расписание.
  const factory CalendarState.scheduleOpened() = _CalendarScheduleOpenedState;
}
