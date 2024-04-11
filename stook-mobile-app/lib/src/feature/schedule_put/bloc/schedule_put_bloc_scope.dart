import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models.dart';
import 'schedule_put_bloc.dart';

/// Область видимости блока для указания расписания.
abstract class SchedulePutBlocScope {
  /// Получить блок.
  static ISchedulePutBloc of(BuildContext context) {
    return BlocProvider.of<ISchedulePutBloc>(context);
  }

  /// Загрузить данные.
  static void load(BuildContext context) {
    of(context).add(const SchedulePutEvent.load());
  }

  /// Сохранить данные.
  static void save(
    BuildContext context,
    int currentWeekNumber,
    List<WeekEntity> weeks,
  ) {
    of(context).add(SchedulePutEvent.save(
      currentWeekNumber: currentWeekNumber,
      weeks: weeks,
    ));
  }
}
