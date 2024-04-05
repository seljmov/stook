import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:octopus/octopus.dart';

import '../../feature/home/home_screen.dart';
import '../../feature/notes/notes_screen.dart';
import '../../feature/resources/resources_screen.dart';
import '../../feature/tasks/tasks_screen.dart';

/// Маршруты приложения.
enum Routes with OctopusRoute {
  home('home'),
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
        Routes.tasks => const TasksScreen(),
        Routes.resources => const ResourcesScreen(),
        Routes.notes => const NotesScreen(),
      };
}
