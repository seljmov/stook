class Week {
  int number;
  bool isHidden;
  final List<Day> days;

  Week({required this.number, this.isHidden = false, List<Day>? days})
      : days = days ?? [];
}

class Day {
  final int number;
  final List<Lesson> lessons;

  Day({required this.number, List<Lesson>? lessons}) : lessons = lessons ?? [];

  void addLesson() {
    lessons.add(Lesson());
  }

  String get name {
    switch (number) {
      case 1:
        return 'Понедельник';
      case 2:
        return 'Вторник';
      case 3:
        return 'Среда';
      case 4:
        return 'Четверг';
      case 5:
        return 'Пятница';
      case 6:
        return 'Суббота';
      case 7:
        return 'Воскресенье';
      default:
        return '';
    }
  }
}

class Lesson {
  final String name;
  final String place;
  final String teacher;

  Lesson({this.name = '', this.place = '', this.teacher = ''});
}
