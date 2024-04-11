import 'package:flutter/widgets.dart';
import 'package:stook_database/models/enums/day_of_week.dart';

import '../models.dart';

/// Провайдер для управления расписанием.
class ScheduleProvider with ChangeNotifier {
  final List<Week> _weeks = [];

  ScheduleProvider(List<Week> weeks) {
    if (weeks.isNotEmpty) {
      _weeks.addAll(weeks);
    } else {
      _weeks.add(Week(
        number: 1,
        days: List.generate(
          6,
          (index) => Day(dayOfWeek: DayOfWeek.values[index]),
        ),
      ));
    }
  }

  /// Список недель.
  List<Week> get weeks => _weeks;

  /// Расписание корректно, если все дни в неделях не пусты.
  bool get isCorrect => _weeks.every((week) => week.isCorrect);

  /// Добавить неделю.
  void addWeek() {
    _weeks.add(Week(
      number: _weeks.length + 1,
      days: List.generate(
        6,
        (index) => Day(dayOfWeek: DayOfWeek.values[index]),
      ),
    ));
    notifyListeners();
  }

  /// Обновить неделю.
  void updateWeek(int index, Week week) {
    _weeks[index] = week;
    notifyListeners();
  }

  /// Удалить неделю.
  void removeWeek(int index) {
    _weeks.removeAt(index);
    for (var i = index; i < _weeks.length; i++) {
      _weeks[i].number = i + 1;
    }
    notifyListeners();
  }

  /// Добавить урок.
  void addLesson(int weekIndex, int dayIndex) {
    _weeks[weekIndex].days[dayIndex].addLesson();
    notifyListeners();
  }

  /// Удалить урок.
  void removeLesson(int weekIndex, int dayIndex, int lessonIndex) {
    _weeks[weekIndex].days[dayIndex].lessons.removeAt(lessonIndex);
    notifyListeners();
  }

  /// Обновить урок.
  void updateLesson(
    int weekIndex,
    int dayIndex,
    int lessonIndex,
    Lesson lesson,
  ) {
    _weeks[weekIndex].days[dayIndex].lessons[lessonIndex] = lesson;
    notifyListeners();
  }
}
