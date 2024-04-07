import 'dart:convert';

class Week {
  int number;
  bool isHidden;
  final List<Day> days;

  Week({required this.number, this.isHidden = false, List<Day>? days})
      : days = days ?? [];

  /// Неделя не пуста, если все дни содержат хотя бы одно занятие.
  bool get isCorrect => days.every((day) => day.lessons.isNotEmpty);
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

  Lesson({this.name = 'Занятие', this.place = '', this.teacher = ''});

  Lesson copyWith({
    String? name,
    String? place,
    String? teacher,
  }) {
    return Lesson(
      name: name ?? this.name,
      place: place ?? this.place,
      teacher: teacher ?? this.teacher,
    );
  }

  (String, String) timeByNumber(int number) {
    switch (number) {
      case 1:
        return ('08:30', '10:00');
      case 2:
        return ('10:15', '11:45');
      case 3:
        return ('12:00', '13:30');
      case 4:
        return ('14:00', '15:30');
      case 5:
        return ('15:45', '17:15');
      case 6:
        return ('17:30', '19:00');
      case 7:
        return ('19:15', '20:45');
      case 8:
        return ('21:00', '22:30');
      default:
        return ('', '');
    }
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      name: json['name'] ?? '',
      place: json['place'] ?? '',
      teacher: json['teacher'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'place': place,
      'teacher': teacher,
    };
  }

  String get toStr => jsonEncode(toJson());
}
