/// Расширение для DateTime.
extension DateTimeX on DateTime {
  /// Проверка на сегодня.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
