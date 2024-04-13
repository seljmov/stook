import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_database/models/enums/enums.dart';

import '../../../common/extension/time_of_day_x.dart';
import '../models.dart';

part 'schedule_put_bloc.freezed.dart';

/// Блок для указания расписания.
abstract class ISchedulePutBloc
    extends Bloc<SchedulePutEvent, SchedulePutState> {
  ISchedulePutBloc() : super(const SchedulePutState.initial());
}

/// Блок для указания расписания.
class SchedulePutBloc extends ISchedulePutBloc {
  final DatabaseContext _databaseContext;

  SchedulePutBloc({
    required DatabaseContext databaseContext,
  }) : _databaseContext = databaseContext {
    on<SchedulePutEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        save: (event) => _save(event, emit),
      ),
    );
  }

  Future<void> _load(
    _SchedulePutLoadEvent event,
    Emitter<SchedulePutState> emit,
  ) async {
    emit(const SchedulePutState.loaderShow());
    final lessons = await _databaseContext.lessonsDao.getAllLessons();
    final lessonsByWeek = lessons.groupListsBy((lessons) => lessons.weekNumber);
    final weeks = <WeekEntity>[];
    for (final weekNumber in lessonsByWeek.keys) {
      final week = WeekEntity(
        number: weekNumber,
        days: List.generate(
          6,
          (index) => DayEntity(dayOfWeek: DayOfWeek.values[index]),
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
          return LessonEntity(
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

    emit(const SchedulePutState.loaderHide());
    emit(SchedulePutState.loaded(weeks: weeks));
  }

  Future<void> _save(
    _SchedulePutSaveEvent event,
    Emitter<SchedulePutState> emit,
  ) async {
    emit(const SchedulePutState.loaderShow());
    final lessons = <LessonsCompanion>[];
    for (final week in event.weeks) {
      lessons.addAll(week.days.expand((day) {
        return day.lessons.map((lesson) {
          return LessonsCompanion.insert(
            title: lesson.name,
            place: lesson.place,
            teacher: lesson.teacher,
            timeStart: lesson.timeStart.toDateTime(),
            timeEnd: lesson.timeEnd.toDateTime(),
            weekNumber: week.number,
            dayOfWeek: day.dayOfWeek,
            lessonType: lesson.type,
          );
        });
      }));
    }
    final oldLessons = await _databaseContext.lessonsDao.getAllLessons();
    await _databaseContext.lessonsDao.deleteAllLessons();
    try {
      await _databaseContext.lessonsDao.insertLessonsCompanions(lessons);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentWeekNumber', event.currentWeekNumber);
      await prefs.setString('currentDate', DateTime.now().toString());
      emit(const SchedulePutState.loaderHide());
      emit(const SchedulePutState.successUpdate());
    } catch (e) {
      await _databaseContext.lessonsDao.insertLessons(oldLessons);
      emit(const SchedulePutState.loaderHide());
      emit(SchedulePutState.errorUpdate(message: e.toString()));
    }
  }
}

@freezed
abstract class SchedulePutEvent with _$SchedulePutEvent {
  /// Загрузить расписание.
  const factory SchedulePutEvent.load() = _SchedulePutLoadEvent;

  /// Сохранить расписание.
  const factory SchedulePutEvent.save({
    required int currentWeekNumber,
    required List<WeekEntity> weeks,
  }) = _SchedulePutSaveEvent;
}

@freezed
abstract class SchedulePutState with _$SchedulePutState {
  /// Начальное состояние.
  const factory SchedulePutState.initial() = _SchedulePutInitialState;

  /// Состояние загрузки.
  const factory SchedulePutState.loaderShow() = _SchedulePutLoaderShowState;

  /// Состояние загрузки скрыто.
  const factory SchedulePutState.loaderHide() = _SchedulePutLoaderHideState;

  /// Состояние загружено.
  const factory SchedulePutState.loaded({
    required List<WeekEntity> weeks,
  }) = _SchedulePutLoadedState;

  /// Состояние успешного завершения.
  const factory SchedulePutState.successUpdate() =
      _SchedulePutSuccessUpdateState;

  /// Состояние ошибки.
  const factory SchedulePutState.errorUpdate({
    required String message,
  }) = _SchedulePutErrorUpdateState;
}
