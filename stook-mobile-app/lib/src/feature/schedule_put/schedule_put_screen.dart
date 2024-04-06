import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/extension/scaffold_x.dart';
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
    return ChangeNotifierProvider(
      create: (context) => ScheduleProvider(),
      child: Builder(builder: (context) {
        return Consumer<ScheduleProvider>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Укажите расписание'),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () {
                      if (provider.weeks.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('В расписании нет недель.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else if (!provider.isCorrect) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('В расписании есть дни без занятий.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Navigator.of(context).pop(provider.weeks);
                      }
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
}
