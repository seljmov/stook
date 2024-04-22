import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Форматтер дня недели.
final kCalendarDayOfWeekFormatter = DateFormat.EEEE('ru_RU');

/// Форматтер даты.
final kCalendarDateFormatter = DateFormat.MMMMd('ru_RU');

/// Форматтер даты.
final kDateFormat = DateFormat('dd.MM.yyyy г.', 'ru_RU');

final kTimeFormat = DateFormat('HH:mm', 'ru_RU');

/// Форматтер даты и времени.
final kDateTimeFormat = DateFormat('dd.MM.yyyy HH:mm', 'ru_RU');

/// Физика скролла по умолчанию.
const kDefaultPhysics = BouncingScrollPhysics();
