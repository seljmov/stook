import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/extension/scaffold_x.dart';
import 'models.dart';
import 'utils/schedule_provider.dart';
import 'widget/week_widget.dart';

class SchedulePutScreen extends StatefulWidget {
  const SchedulePutScreen({super.key});

  @override
  State<SchedulePutScreen> createState() => _SchedulePutScreenState();
}

class _SchedulePutScreenState extends State<SchedulePutScreen> {
  late final ValueNotifier<List<Week>> weeksNotifer;

  @override
  void initState() {
    weeksNotifer = ValueNotifier<List<Week>>([
      Week(
        number: 1,
        days: List.generate(6, (index) => Day(number: index + 1)),
      ),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleProvider(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Укажите расписание'),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: Consumer<ScheduleProvider>(
            builder: (context, provider, child) => Column(
              children: [
                Expanded(
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
                ),
                ElevatedButton(
                  onPressed: () => provider.addWeek(),
                  child: const Text('Добавить неделю'),
                ),
              ],
            ),
          ),
        ).withBottomPadding();
      }),
    );
  }
}
