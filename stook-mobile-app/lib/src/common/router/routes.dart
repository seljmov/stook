import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:octopus/octopus.dart';
import 'package:stook_database/database_context.dart';

import '../../feature/home/home_screen.dart';
import '../../feature/notes/notes_screen.dart';
import '../../feature/resources/resources_screen.dart';
import '../../feature/calendar/calendar_screen.dart';
import '../../feature/schedule_put/schedule_put_screen.dart';
import '../../feature/tasks/tasks_screen.dart';
import '../infrastructure/di_configurator.dart';

/// Маршруты приложения.
enum Routes with OctopusRoute {
  home('home'),
  calendar('calendar'),
  schedulePut('schedulePut'),
  tasks('tasks'),
  resources('resources'),
  notes('notes');

  const Routes(this.name);

  @override
  final String name;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) =>
      switch (this) {
        Routes.home => const HomeScreen(),
        Routes.calendar => CalendarScreen(
            databaseContext: injector.get<DatabaseContext>(),
          ),
        Routes.schedulePut => SchedulePutScreen(
            databaseContext: injector.get<DatabaseContext>(),
          ),
        Routes.tasks => const TasksScreen(),
        Routes.resources => const ResourcesScreen(),
        Routes.notes => const NotesScreen(),
      };
}
