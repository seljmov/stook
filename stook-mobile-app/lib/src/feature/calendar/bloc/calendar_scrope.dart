import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_bloc.dart';

/// Область видимости блока календаря.
abstract class CalendarScope {
  /// Получить блок.
  static ICalendarBloc of(BuildContext context) {
    return BlocProvider.of<ICalendarBloc>(context);
  }

  /// Загрузить данные.
  static void load(BuildContext context) {
    of(context).add(const CalendarEvent.load());
  }
}
