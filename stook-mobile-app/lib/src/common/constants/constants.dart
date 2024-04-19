import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Форматтер дня недели.
final kCalendarDayOfWeekFormatter = DateFormat.EEEE('ru');

/// Форматтер даты.
final kCalendarDateFormatter = DateFormat.MMMMd('ru');

/// Форматтер даты.
final kDateFormat = DateFormat('dd.MM.yyyy г.');

/// Физика скролла по умолчанию.
const kDefaultPhysics = BouncingScrollPhysics();
