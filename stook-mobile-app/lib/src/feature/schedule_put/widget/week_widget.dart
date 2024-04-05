import 'package:flutter/material.dart';

import '../models.dart';
import 'day_card.dart';

/// Виджет недели.
class WeekWidget extends StatelessWidget {
  const WeekWidget({
    super.key,
    required this.week,
    required this.onWeekUpdate,
    required this.onWeekRemove,
  });

  final Week week;
  final void Function(Week updatedWeek) onWeekUpdate;
  final void Function(Week week) onWeekRemove;

  @override
  Widget build(BuildContext context) {
    final collapsedNotifier = ValueNotifier<bool>(week.isHidden);
    return ValueListenableBuilder(
      valueListenable: collapsedNotifier,
      builder: (context, isCollapsed, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 8.0,
              bottom: 4.0,
              right: 16.0,
            ),
            child: Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Неделя ${week.number}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 4.0),
                    // remove button
                    IconButton(
                      icon: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        onWeekRemove(week);
                      },
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Visibility(
                    visible: isCollapsed,
                    child: const Icon(Icons.keyboard_arrow_down),
                    replacement: const Icon(Icons.keyboard_arrow_up),
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    collapsedNotifier.value = !isCollapsed;
                    week.isHidden = collapsedNotifier.value;
                    onWeekUpdate(week);
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isCollapsed,
            child: Column(
              children: List.generate(week.days.length, (index) {
                final day = week.days[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: DayCard(
                    day: day,
                    onAddLesson: (day) {
                      week.days[index] = day;
                      onWeekUpdate(week);
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
