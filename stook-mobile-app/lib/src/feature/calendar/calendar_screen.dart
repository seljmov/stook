import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octopus/octopus.dart';
import 'package:stook_database/database_context.dart';

import '../../common/router/routes.dart';
import 'bloc/calendar_bloc.dart';
import 'bloc/calendar_scrope.dart';
import 'widget/calendar_day_card.dart';

/// Экран календаря.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.databaseContext});

  final DatabaseContext databaseContext;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_calendar_rounded,
              size: 24,
              color: Colors.grey.shade700,
            ),
            onPressed: () => context.octopus.push(Routes.schedulePut),
          ),
        ],
      ),
      body: BlocConsumer<ICalendarBloc, CalendarState>(
        bloc: CalendarBloc(databaseContext: widget.databaseContext)
          ..add(const CalendarEvent.load()),
        listener: (context, state) {
          state.mapOrNull(
            initial: (_) => CalendarScope.load(context),
            loaderShow: (_) => context.loaderOverlay.show(),
            loaderHide: (_) => context.loaderOverlay.hide(),
            scheduleOpened: (_) => context.octopus.push(Routes.schedulePut),
          );
        },
        builder: (context, state) {
          return Center(
            child: state.whenOrNull(
              loaded: (days) => Visibility(
                visible: days.isEmpty,
                child: const Center(
                  child: Text('Расписание пусто'),
                ),
                replacement: ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CalendarDayCard(day: day),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
