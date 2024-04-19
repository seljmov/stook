import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/extension/scaffold_x.dart';
import 'bloc/schedule_put_bloc.dart';
import 'bloc/schedule_put_bloc_scope.dart';
import 'models.dart';
import 'utils/schedule_provider.dart';
import 'widget/week_widget.dart';

/// Экран для указания расписания.
class SchedulePutScreen extends StatefulWidget {
  const SchedulePutScreen({super.key});

  @override
  State<SchedulePutScreen> createState() => _SchedulePutScreenState();
}

class _SchedulePutScreenState extends State<SchedulePutScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ISchedulePutBloc, SchedulePutState>(
      bloc: SchedulePutBlocScope.of(context)
        ..add(const SchedulePutEvent.load()),
      listener: (context, state) {
        state.mapOrNull(
          initial: (_) => SchedulePutBlocScope.load(context),
          loaderShow: (_) => context.loaderOverlay.show(),
          loaderHide: (_) => context.loaderOverlay.hide(),
          successUpdate: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Расписание успешно обновлено.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          },
          errorUpdate: (state) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ошибка при обновлении расписания: ${state.message}',
              ),
              backgroundColor: Colors.redAccent,
            ),
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: state.whenOrNull(
            loaded: (weeks) => ScheduleWidget(weeks: weeks),
          ),
        );
      },
    );
  }
}

/// Виджет расписания.
class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({
    super.key,
    required this.weeks,
  });

  final List<WeekEntity> weeks;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleProvider(weeks),
      child: Builder(builder: (context) {
        return Consumer<ScheduleProvider>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Укажите расписание'),
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () async {
                      final error = provider.verifySchedule();
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      final currentWeekNumber = await _selectStartWeekNumber(
                          context,
                          provider.weeks.map((e) => e.number).toList());

                      if (currentWeekNumber == null) {
                        return;
                      }

                      SchedulePutBlocScope.save(
                        context,
                        currentWeekNumber,
                        provider.weeks,
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Visibility(
                    visible: provider.weeks.isNotEmpty,
                    child: ListView.builder(
                      itemCount: provider.weeks.length,
                      itemBuilder: (context, index) {
                        final week = provider.weeks[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index != 0 && !week.isHidden ? 16.0 : 0,
                          ),
                          child: WeekWidget(
                            week: week,
                            onWeekUpdate: (updatedWeek) {
                              provider.updateWeek(index, updatedWeek);
                            },
                            onWeekRemove: (week) {
                              provider.removeWeek(index);
                            },
                          ),
                        );
                      },
                    ),
                    replacement: const Center(
                      child: Text('Добавьте неделю'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (provider.weeks.length == 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Максимальное количество недель - 4.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }
                    provider.addWeek();
                  },
                  child: const Text('Добавить неделю'),
                ),
              ],
            ),
          ).withBottomPadding(),
        );
      }),
    );
  }

  Future<int?> _selectStartWeekNumber(
    BuildContext context,
    List<int> weekNumbers,
  ) async {
    if (weekNumbers.length == 1) {
      return weekNumbers.first;
    }
    return await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Выберите начальную неделю',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              weekNumbers.length,
              (index) {
                final weekNumber = weekNumbers[index];
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Неделя $weekNumber'),
                  onTap: () {
                    Navigator.of(context).pop(weekNumber);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
